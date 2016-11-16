function [ bestCost bestTour ] = doSimulatedAnnealing(distMap,stopsLon,stopsLat,times,temperature,cool_coefficient,nStops,initTour,doPlot)
  load('usborder.mat','x','y','xx','yy');
  bestCosts = zeros(times+1,1);
  %% initialize
  totalCost = getTotalDist(initTour,distMap);
  bestCosts(1,1) =  totalCost;

  %% Simulated Annealing
  theBestTour = initTour;
  while temperature > 0
    % まず近傍を出す
    j = randi(nStops);
    k = randi(nStops);
    while j == k || j == 1 || k == 1
      j = randi(nStops);
      k = randi(nStops);
    end
    neighborTour = getNeighborhood(tour,j,k);

    % よいスコアならtourを更新する
    tourCost = getTotalDist(tour,distMap)
    neighborTourCost = getTotalDist(neighborTour,distMap)

    if getTotalDist(tour,distMap) < getTotalDist(neighborTour,distMap)
      tour = neighborTour;
    elseif rand <= exp(temperature'*(neighborTourCost - tourCost))
      %悪いスコアでも確率pでtourを更新する
      tour = neighborTour;
    end

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
