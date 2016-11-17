function [ bestCost, bestTour ] = doTabuSearch(distMap,stopsLon,stopsLat,times,timesNeighbor,sizeTabuList,nStops,initTour,doPlot)
  load('usborder.mat','x','y','xx','yy');
  % rng(3,'twister') % makes a plot with stops in Maine & Florida, and is reproducible

  bestCosts = zeros(times+1,1);
  neighborList = zeros(timesNeighbor,2);
  neighborTours = zeros(timesNeighbor,nStops);
  neighborTourCosts = zeros(timesNeighbor,1);
  bestNeighborCosts = zeros(times,1);

  %% initialize
  totalCost = getTotalDist(initTour,distMap);
  bestCosts(1,1) =  totalCost;
  tabuList = [ 0  0 ]; 

  %% TabuSearch
  tour = initTour;
  bestTour = initTour;

  for n = 1:times
    %% 2-optで交換する都市のペアを要素とした集合を作成しておく
    for i = 1:timesNeighbor
      [ j, k ] = get2RandomCities(nStops);

      while searchDuplication(tabuList,j,k) == 1 && searchDuplication(neighborList,j,k) == 1
        [ j, k ] = get2RandomCities(nStops);
      end
      neighborList(i,:) = [ j k ];
    end

    %% 近傍のコストを計算する
    % 決してスマートとは言えないやり方。だれかissueだして誰か
    for i = 1:timesNeighbor
      j = neighborList(i,1);
      k = neighborList(i,2);
      neighborTour = getNeighborhood(tour,j,k);
      neighborTourCost = getTotalDist(neighborTour,distMap);
      neighborTours(i,:) = neighborTour;
      neighborTourCosts(i,:) = neighborTourCost;
    end

    %% 近傍探索の結果から最良なものを判定する
    [neighborMinCost, neighborMinTour, index] = getBetterSolution(neighborTours,neighborTourCosts);
    tour = neighborMinTour;

    % tabuListを更新する
    j = neighborList(index,1);
    k = neighborList(index,2);
    tabuList = [tabuList ; j k];
    if size(tabuList,1) > sizeTabuList
      tabuList = tabuList(2:end,:);
    end

    % 初期化
    neighborTours = zeros(timesNeighbor,nStops);
    neighborTourCosts = zeros(timesNeighbor,1);

    %% plot用の記録
    bestNeighborCosts(n,1) =  neighborMinCost;
    % 過去のベストな値との比較をして、優れば更新
    if getTotalDist(tour,distMap) < getTotalDist(bestTour,distMap)
      bestTour = tour;
    end

    bestCosts(n+1,1) = getTotalDist(bestTour,distMap);
  end

  bestCost = bestCosts(end,1);

  %% 可視化
  if doPlot == 1
    % initTour
    figure('Name','Initial Tour','NumberTitle','off')
    plot(x,y,'Color','red'); % draw the outside border
    hold on
    plot(stopsLon,stopsLat,'*b')
    drawTourPath(stopsLon,stopsLat,initTour);
    hold off

    % bestTour
    figure('Name','Best Tour','NumberTitle','off')
    plot(x,y,'Color','red'); % draw the outside border
    hold on
    plot(stopsLon,stopsLat,'*b')
    drawTourPath(stopsLon,stopsLat,bestTour);
    hold off

    % 各時点での最小値の遷移
    figure('Name','Best value of each iteration','NumberTitle','off')
    plot(bestCosts,'LineWidth',2);
    xlabel('iteration');
    ylabel('Best Cost');
    grid on;

    % 各近傍探索の最小値
    figure('Name','Best value of each neighborhood search','NumberTitle','off')
    plot(bestNeighborCosts,'LineWidth',2);
    xlabel('iteration');
    ylabel('Best Neighborhood Cost');
    grid on;
  end
end
