%🐜( ఠൠఠ )
% Befor use this repository, you have to add the path at once.
p = path;
pathAssets = strcat(pwd,'/assets/');
path(path,pathAssets);

clc;
close all;
clear;

%% --- Create cities and map
load('usborder.mat','x','y','xx','yy');
map.nStops = 100; % you can use any number, but the problem size scales as N^2
[map.distMap, map.lon, map.lat] = initCities(map.nStops);


%% --- params of Ants
numOfAgents = 10; % agent is 🐜
agents = zeros(numOfAgents,map.nStops+1);
gobackTimes = 300;
evaporationRate = 0.90;
acidQuantity = 100;
acidPow = 1;
heurisPow = 4;

%% --- search
tour = 1:map.nStops;
cost = map.nStops + 1;

for i = 1:numOfAgents
  agents(i,tour) = getRandomTour(map.nStops);
  agents(i,cost) = getTotalDist(agents(i,tour),map.distMap);
end

doPlot = 1;
[bestTour bestCost] = doAntColonyOptimization(map,agents,gobackTimes,evaporationRate,acidQuantity,acidPow,heurisPow);
%% --- visualize
if doPlot == 1
  % bestTour
  figure('Name','Best Tour','NumberTitle','off')
  plot(x,y,'Color','red'); % draw the outside border
  hold on
  plot(map.lon,map.lat,'*b')
  drawTourPath(map.lon,map.lat,bestTour);
  hold off
end
bestCost
