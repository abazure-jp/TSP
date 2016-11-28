% Befor use this repository, you have to add the path at once.
p = path;
pathAssets = strcat(pwd,'/assets/');
path(path,pathAssets);

clc;
close all;
clear;

%% --- Create cities and map
load('usborder.mat','x','y','xx','yy');
map.nStops = 10; % you can use any number, but the problem size scales as N^2
[map.distMap, map.lon, map.lat] = initCities(map.nStops);

%% --- params of Genetic Algorithm
numOfAgents = 10;
agents = zeros(numOfAgents,map.nStops+1);
genotype = 'Permutation';

% how to kill agents
kill.type ='Truncation';% Only had implemented 'Truncation'
kill.rate = 0.7;

% how decide parents or mutant
select.type = 'Roulette'; % Only had implemented 'Roulette'

% how method of crossover
crossover.type = 'One-point'; % Only had implemented 'One-point'
crossover.border = map.nStops * 0.5;
crossover.rate = 0.88;
crossover.parents = 2;

% mutationRate = 1 - crossoverRate;
generations = 2;

tour = 1:map.nStops;
cost = map.nStops + 1;

for i = 1:numOfAgents
  agents(i,tour) =  getRandomTour(map.nStops);
  agents(i,cost) = getTotalDist(agents(i,tour),map.distMap);
end

%% --- params of TabuSearch
times = 5; % 探索の回数
timesNeighbor = 10; % 近傍探索の回数
sizeTabuList = times * 0.4; % sizeTabuList < nStops * ( nStops -1 ) * 1/2
doPlot = 0;

eachBetterCosts = zeros(generations,1);
%% a-TLHA memetic
% 近傍探索で得た結果をGAさせる。その際局所探索の増加率を調査して次世代の近傍探索のパラメータを更新する
for j = 1:generations
  for k = 1:numOfAgents
    [bestCost, bestTour] = doTabuSearch(map.distMap,map.lon,map.lat,times,timesNeighbor,sizeTabuList,map.nStops,agents(k,tour),doPlot);
    gain = agents(k,cost) - bestCost;
    if gain > 0 % 改善された
      % 維持
      timesNeighbor = timesNeighbor + 1;
      if timesNeighbor > 15
        timesNeighbor = 15;
      end
    else % 改悪
      timesNeighbor = timesNeighbor - 1;
      if timesNeighbor < 5
        timesNeighbor = 5;
      end
    end
    agents(k,cost) = bestCost;
    agents(k,tour) = bestTour;
  end
  [ ~, ~, agents ] = doGeneticAlgorithm(map,agents,kill,select,crossover,1,0);
  agents = sortrows(agents,map.nStops + 1);
  eachBetterCosts(j,1) = agents(1,cost);
end

figure('Name','Best cost of each generation','NumberTitle','off')
plot(eachBetterCosts,'LineWidth',2);
xlabel('generation');
ylabel('Best Cost');
grid on;


    % lastTour
    figure('Name','Best Tour','NumberTitle','off')
    plot(x,y,'Color','red'); % draw the outside border
    hold on
    plot(stopsLon,stopsLat,'*b')
    drawTourPath(stopsLon,stopsLat,agents(1,tour);
    hold off

