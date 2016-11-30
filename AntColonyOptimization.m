%🐜( ఠൠఠ )
% Befor use this repository, you have to add the path at once.
p = path;
pathAssets = strcat(pwd,'/assets/');
path(path,pathAssets);

clc;
close all;
clear;

%% --- measure
start_time = cputime;
allvars = whos;
memused1 = sum([allvars.bytes]);

%% --- Create cities and map
load('usborder.mat','x','y','xx','yy');
map.nStops = 100; % you can use any number, but the problem size scales as N^2
[map.distMap, map.lon, map.lat] = initCities(map.nStops);

%% --- Load config
conf = getConfig('AntColonyOptimization', map.nStops);
agents = zeros(conf.population,map.nStops+1);
if conf.randset == 1
   rng(3,'twister') % makes a plot with stops in Maine & Florida, and is reproducible
end

%% --- search
tour = 1:map.nStops;
cost = map.nStops + 1;

for i = 1:conf.population
  agents(i,tour) = getRandomTour(map.nStops);
  agents(i,cost) = getTotalDist(agents(i,tour),map.distMap);
end

doPlot = 1;
[bestTour bestCost] = doAntColonyOptimization(map,agents,conf);

%% --- measure end
allvars = whos;
memused2 = sum([allvars.bytes]);
memcost = memused2 - memused1;
end_time = cputime;
exec_time = end_time - start_time;
fprintf('\ntime taken = %f\t', exec_time);
fprintf('\nmemeory cost = %f\t', memcost);

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
