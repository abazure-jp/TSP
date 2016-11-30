function [ bestCost, bestTour ] = doTabuSearch(map,conf,initTour,doPlot);
  %% initialize
  load('usborder.mat','x','y','xx','yy');
  bestCosts = zeros(conf.times+1,1);
  neighborList = zeros(conf.timesNeighbor,2);
  neighborTours = zeros(conf.timesNeighbor,map.nStops);
  neighborTourCosts = zeros(conf.timesNeighbor,1);
  bestNeighborCosts = zeros(conf.times,1);

  totalCost = getTotalDist(initTour,map.distMap);
  bestCosts(1,1) =  totalCost;
  tabuList = [ 0  0 ];

  %% TabuSearch
  tour = initTour;
  bestTour = initTour;

  for n = 1:conf.times
    %% 2-optで交換する都市のペアを要素とした集合を作成しておく
    for i = 1:conf.timesNeighbor
      temp = sort(getNRandomCities(2,map.nStops));
      j = temp(1);
      k = temp(2);

      while searchDuplication(tabuList,j,k) == 1 && searchDuplication(neighborList,j,k) == 1
        display('Forbidden');
        temp = sort(getNRandomCities(2,map.nStops));
        j = temp(1);
        k = temp(2);
      end
      neighborList(i,:) = [ j k ];
    end

    %% 近傍のコストを計算する
    % 決してスマートとは言えないやり方。だれかissueだして誰か
    for i = 1:conf.timesNeighbor
      j = neighborList(i,1);
      k = neighborList(i,2);
      neighborTour = getNeighborhood(tour,j,k);
      neighborTourCost = getTotalDist(neighborTour,map.distMap);
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
    if size(tabuList,1) > conf.sizeTabuList
      tabuList = tabuList(2:end,:);
    end

    % 初期化
    neighborTours = zeros(conf.timesNeighbor,map.nStops);
    neighborTourCosts = zeros(conf.timesNeighbor,1);

    %% plot用の記録
    bestNeighborCosts(n,1) =  neighborMinCost;
    % 過去のベストな値との比較をして、優れば更新
    if getTotalDist(tour,map.distMap) < getTotalDist(bestTour,map.distMap)
      bestTour = tour;
    end

    bestCosts(n+1,1) = getTotalDist(bestTour,map.distMap);
  end

  bestCost = bestCosts(end,1);

  %% 可視化
  if doPlot == 1
    % initTour
    figure('Name','Initial Tour','NumberTitle','off')
    plot(x,y,'Color','red'); % draw the outside border
    hold on
    plot(map.lon,map.lat,'*b')
    drawTourPath(map.lon,map.lat,initTour);
    hold off

    % bestTour
    figure('Name','Best Tour','NumberTitle','off')
    plot(x,y,'Color','red'); % draw the outside border
    hold on
    plot(map.lon,map.lat,'*b')
    drawTourPath(map.lon,map.lat,bestTour);
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
