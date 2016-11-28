function [bestTour bestCost] = doAntColonyOptimization(map,agents,gobackTimes,evaporationRate,acidQuantity,acidPow,heurisPow);
  %% initialize
  population = size(agents,1);
  acidMap       = getUpdatedAcidMap(triu(NaN(map.nStops,map.nStops))',agents,evaporationRate,acidQuantity);
  heuristicsMap = getHeuristicsMap(triu(NaN(map.nStops,map.nStops))',map.distMap); % 経路の逆数
  probMap = triu(NaN(map.nStops,map.nStops))';
  probMap = getUpdatedProbMap(acidMap,heuristicsMap,acidPow,heurisPow);
  cost = map.nStops + 1; % for index of agent
  tour = 1:map.nStops; % for index of agent

  % visualize
  load('usborder.mat','x','y','xx','yy');
  agents = sortrows(agents,cost);
  % bestInitAgent
  figure('Name','Best Initilized Tour of Agents','NumberTitle','off')
  plot(x,y,'Color','red'); % draw the outside border
  hold on
  plot(map.lon,map.lat,'*b')
  drawTourPath(map.lon,map.lat,agents(1,tour));
  hold off

  bestCosts = agents(1,cost);
  %% --- go and back
  for i = 1:gobackTimes
    for j = 1:population
      agents(j,tour) = getTourByProbability(map.nStops,probMap);
      agents(j,cost) = getTotalDist(agents(j,tour),map.distMap);
    end
    acidMap = getUpdatedAcidMap(triu(NaN(map.nStops,map.nStops))',agents,evaporationRate,acidQuantity);
    probMap = getUpdatedProbMap(acidMap,heuristicsMap,acidPow,heurisPow);
    agents = sortrows(agents,cost);
    bestCosts = [ bestCosts ; agents(1,cost) ];
  end

  bestCosts = bestCosts(2:end);
    % 各時点での最小値の遷移
    figure('Name','Best value of 100x iteration','NumberTitle','off')
    plot(bestCosts,'LineWidth',2);
    xlabel('iteration');
    ylabel('Best Cost');
    grid on;

  agents = sortrows(agents,cost);
  bestTour = agents(1,tour);
  bestCost = agents(1,cost);
end
