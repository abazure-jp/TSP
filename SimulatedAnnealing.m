% Befor use this repository, you have to add the path at once.
% p = path;
% pathAssets = strcat(pwd,'/assets/');
% path(path,pathAssets);
clc;
close all;
clear;

%% --- Create cities and map
map.nStops = 100; % you can use any number, but the problem size scales as N^2
[map.distMap, map.lon, map.lat] = initCities(map.nStops);

conf = getConfig('SimulatedAnnealing', map.nStops);

%% --- search
initTour = getRandomTour(map.nStops);
doPlot = 1;
[ bestCost, bestTour ] = doSimulatedAnnealing(map,conf,initTour,doPlot);
