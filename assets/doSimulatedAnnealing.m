function [ bestCost bestTour ] = doSimulatedAnnealing(distMap,stopsLon,stopsLat,timesNeighbor,temperature,cool_coefficient,nStops,initTour,doPlot)
  %% initialize
  load('usborder.mat','x','y','xx','yy');
  tourCost = getTotalDist(initTour,distMap);
  bestCost = tourCost;
  eachCosts = [tourCost];
  bestCosts = [bestCost];
  bestTour = initTour;
  tour = initTour;

  probability = [ ];
  temperature_hist = [temperature];

  %% Simulated Annealing
  while temperature > 10
    % まず近傍を出す
    j = randi(nStops);
    k = randi(nStops);
    while j == k || j == 1 || k == 1
      j = randi(nStops);
      k = randi(nStops);
    end

    neighborTour = getNeighborhood(tour,j,k);
    neighborTourCost = getTotalDist(neighborTour,distMap);

    % 近傍がより優れていれば(小さければ)、tourを更新する
    if neighborTourCost <= tourCost
      tour = neighborTour;
      if neighborTourCost <= bestCost
        bestCost = neighborTourCost;
        bestTour = neighborTour;
      end
      % 悪い場合でも、確率で更新する。
    elseif rand <= exp(inv(temperature)*(neighborTourCost - tourCost))
      tour = neighborTour;
    end
    probability=[ probability; exp(inv(temperature)*(neighborTourCost - tourCost))];
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
