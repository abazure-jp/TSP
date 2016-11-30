function [ bestCost, bestTour ] = doSimulatedAnnealing(map,conf,initTour,doPlot);
  %% initialize
  load('usborder.mat','x','y','xx','yy');
  neighborList = zeros(conf.timesNeighbor,2);
  neighborTours = zeros(conf.timesNeighbor,map.nStops);
  neighborTourCosts = zeros(conf.timesNeighbor,1);
  tourCost = getTotalDist(initTour,map.distMap);
  bestCost = tourCost;
  eachCosts = tourCost;
  bestCosts = bestCost;
  bestTour = initTour;
  tour = initTour;
  climedCount = 0;

  probability = [ ];
  temperature_hist = conf.temperature;

  %% Simulated Annealing
  while conf.temperature > 10
  %% 2-optで交換する都市のペアを要素とした集合を作成しておく
    for i = 1:conf.timesNeighbor
      temp = sort(getNRandomCities(2,map.nStops));
      j = temp(1);
      k = temp(2);

      while searchDuplication(neighborList,j,k) == 1
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
    [neighborMinCost, neighborMinTour, ~] = getBetterSolution(neighborTours,neighborTourCosts);
    tour = neighborMinTour;

    %% 最良近傍がより優れていれば(小さければ)、その近傍へ遷移する
    if neighborMinCost <= tourCost
      tour = neighborMinTour;
      if neighborMinCost <= bestCost
        bestCost = neighborMinCost;
        bestTour = neighborMinTour;
      end
      % 悪い場合でも、確率で更新する。
    elseif rand <= exp(-(neighborMinCost - tourCost)/conf.temperature)
      display('climbed');
      climedCount = climedCount + 1;
      tour = neighborMinTour;
    end

    probability=[ probability; exp(-(neighborTourCost - tourCost)/conf.temperature)];
    conf.temperature = conf.cool_coefficient * conf.temperature;
    temperature_hist = [temperature_hist;conf.temperature];
    tourCost = getTotalDist(tour,map.distMap);
    eachCosts = [eachCosts ; tourCost];
    bestCosts = [bestCosts ; bestCost];
  end

  % 可視化
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
    xlabel('Iteration');
    ylabel('Best Cost');
    grid on;

    % 探索の推移
    figure('Name','Value of each iteration','NumberTitle','off')
    plot(eachCosts,'LineWidth',2);
    xlabel('Iteration');
    ylabel('Cost');
    grid on;

    % 温度の推移
    figure('Name','Temperatures','NumberTitle','off')
    plot(temperature_hist,'LineWidth',2);
    xlabel('Iteration');
    ylabel('Temperature');
    grid on;

    % 確率の推移
    figure('Name','Probability','NumberTitle','off')
    plot(probability,'LineWidth',2);
    xlabel('Iteration');
    ylabel('probability');
    grid on;
  end
end
