function [ bestCost bestTour ] = doTabuSearch(distMap,stopsLon,stopsLat,times,timesNeighbor,sizeTabuList,nStops,initTour,doPlot)
  load('usborder.mat','x','y','xx','yy');
  % rng(3,'twister') % makes a plot with stops in Maine & Florida, and is reproducible

  bestCosts = zeros(times+1,1);
  neighborTours = zeros(timesNeighbor,nStops);
  neighborTourCosts = zeros(timesNeighbor,1);
  bestNeighborCosts = zeros(times,1);

  %% initialize
  totalCost = getTotalDist(initTour,distMap);
  bestCosts(1,1) =  totalCost;
  tabuList = [1 1];
  %% TabuSearch
  tour = initTour;
  bestTour = initTour;

  for n = 1:times
    % 現在のツアーの内、j番目とk番目(j!=k,j != 1, k != 1)を入れ替える。
    % これを近傍探索(2-opt)と定義してtimesNeighbor回繰り返す
    for i = 1:timesNeighbor
      flag = 1;
      % 近傍探索の乱数を選考する。タブーリストに抵触するようであれば乱数選考をやり直す
      j = randi(nStops);
      k = randi(nStops);
      while  flag == 1
        if j == k || j == 1 || k == 1
          j = randi(nStops);
          k = randi(nStops);
        else
          % 実装の関係で必ずj<kとなっていて欲しいのでそうする
          if j > k
            temp = j;
            j = k;
            k = temp;
          end

          if checkTabuList(tabuList,j,k) == 0
            flag = 0;
          else
            j = k;
          end
        end
      end

      neighborTour = getNeighborhood(tour,j,k);
      neighborTourCost = getTotalDist(neighborTour,distMap);
      neighborTours(i,:) = neighborTour;
      neighborTourCosts(i,:) = neighborTourCost;

      % tabuListが埋まったらデキューしてリストサイズを保つ
      tabuList = [ tabuList ; j k ];
      if size(tabuList,1) > sizeTabuList
        tabuList = tabuList(2:end,:);
      end
    end

    %% 近傍探索の結果から最良なものを判定する
    %% あくまで近傍のリストとタブーサーチは別物であることに留意
    tour_localmin = getBetterSolution(neighborTour,neighborTourCost);
    tour = tour_localmin(1,2:end); % tour_localmin = [ cost city_a city_e city_d ... ]
    neighborTours = [];
    neighborTourCosts = [];
    bestNeighborCosts(n,1) =  getTotalDist(tour,distMap);
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
