function [ bestCost bestTour ] = doTabuSearch(times,timesNeighbor,sizeTabuList,nStops)

  load('usborder.mat','x','y','xx','yy');
  % rng(3,'twister') % makes a plot with stops in Maine & Florida, and is reproducible
  %  nStops =  48; % you can use any number, but the problem size scales as N^2

  %% --- params of TabuSearch
  %  times =  99; % 探索の回数
  %  timesNeighbor = 30; % 近傍探索の回数
  % sizeTabuList = timesNeighbor * times * 0.3;

  bestCosts = zeros(times+1,1);
  neighborTours = zeros(timesNeighbor,nStops);
  neighborTourCosts = zeros(timesNeighbor,1);
  bestNeighborCosts = zeros(times,1);

  %% initialize
  [distMap stopsLon stopsLat] = initCities(nStops);
  initTour = getRandomTour(nStops);
  totalCost = getTotalDist(initTour,distMap);
  bestCosts(1,1) =  totalCost;

  % plot the path in the graph
  figure('Name','Initial Tour','NumberTitle','off')
  plot(x,y,'Color','red'); % draw the outside border
  hold on
  plot(stopsLon,stopsLat,'*b')
  drawTourPath(stopsLon,stopsLat,initTour);
  hold off

  %% TabuSearch
  tour = initTour;
  tabuList = initTour;
  bestTour = initTour;

  for n = 1:times
    % 現在のツアーの内、j番目とk番目(j!=k,j != 1, k != 1)を入れ替える。
    % これを近傍探索(2-opt)と定義してtimesNeighbor回繰り返す
    for i = 1:timesNeighbor
      flag = 1;
      % 近傍探索の乱数を選考する。タブーリストにかぶれば乱数選考をやり直す
      j = randi(nStops);
      k = randi(nStops);

      while  flag == 1
        if j == k || j == 1 || k == 1
          j = randi(nStops);
          k = randi(nStops);
        else
          neighborTour = getNeighborhood(tour,j,k);
          if checkTabuList(tabuList,neighborTour) == 0
            flag = 0;
          else
            j = k;
          end
        end
      end

      neighborTourCost = getTotalDist(neighborTour,distMap);
      neighborTours(i,:) = neighborTour;
      neighborTourCosts(i,:) = neighborTourCost;

      % tabuListが埋まったらデキューしてリストサイズを保つ
      tabuList = [ tabuList ; neighborTour ];
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

  % 可視化
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

  bestCost = bestCosts(end,1);
end
