function [bestTour bestCost] = doAntColonyOptimization(map,agents,conf);
  %% initialize
  population = size(agents,1);
  acidMap       = getUpdatedAcidMap(triu(NaN(map.nStops,map.nStops))',agents,conf.evaporationRate,conf.acidQuantity);
  heuristicsMap = getHeuristicsMap(triu(NaN(map.nStops,map.nStops))',map.distMap); % 経路の逆数
  probMap = triu(NaN(map.nStops,map.nStops))';
  probMap = getUpdatedProbMap(acidMap,heuristicsMap,conf.acidPow,conf.heurisPow);
  cost = map.nStops + 1; % for index of agent
  tour = 1:map.nStops; % for index of agent
  bestCosts = zeros(conf.gobackTimes+1,1);

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

  bestCosts(1,1) = agents(1,cost);
  %% --- go and back
  for i = 1:conf.gobackTimes
    if mod(i,10) == 0
      i
    end
    for j = 1:population
      agents(j,tour) = getTourByProbability(map.nStops,probMap);
      agents(j,cost) = getTotalDist(agents(j,tour),map.distMap);
    end
    acidMap = getUpdatedAcidMap(triu(NaN(map.nStops,map.nStops))',agents,conf.evaporationRate,conf.acidQuantity);
    probMap = getUpdatedProbMap(acidMap,heuristicsMap,conf.acidPow,conf.heurisPow);
    agents = sortrows(agents,cost);
    bestCosts(i+1,1) = agents(1,cost);
  end

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
