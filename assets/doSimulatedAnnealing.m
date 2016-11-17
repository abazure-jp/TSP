function [ bestCost, bestTour ] = doSimulatedAnnealing(distMap,stopsLon,stopsLat,timesNeighbor,temperature,cool_coefficient,nStops,initTour,doPlot)
  %% initialize
  load('usborder.mat','x','y','xx','yy');
  neighborList = zeros(timesNeighbor,2);
  neighborTours = zeros(timesNeighbor,nStops);
  neighborTourCosts = zeros(timesNeighbor,1);
  tourCost = getTotalDist(initTour,distMap);
  bestCost = tourCost;
  eachCosts = tourCost;
  bestCosts = bestCost;
  bestTour = initTour;
  tour = initTour;

  probability = [ ];
  temperature_hist = temperature;

  %% Simulated Annealing
  while temperature > 10
  %% 2-optで交換する都市のペアを要素とした集合を作成しておく
    for i = 1:timesNeighbor
      [ j, k ] = get2RandomCities(nStops);

      while searchDuplication(neighborList,j,k) == 1
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
    elseif rand <= exp((neighborMinCost - tourCost)/temperature)
      tour = neighborMinTour;
    end

    probability=[ probability; exp((neighborTourCost - tourCost)/temperature)];
    temperature = cool_coefficient * temperature;
    temperature_hist = [temperature_hist;temperature];
    tourCost = getTotalDist(tour,distMap);
    eachCosts = [eachCosts ; tourCost];
    bestCosts = [bestCosts ; bestCost];
  end

  % 可視化
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
