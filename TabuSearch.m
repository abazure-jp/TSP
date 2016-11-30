% Befor use this repository, you have to add the path at once.
p = path;
pathAssets = strcat(pwd,'/assets/');
path(path,pathAssets);
clc;
close all;
clear;

%% --- Load config
conf = getConfig('TabuSearch');

%% --- Create cities and map
map.nStops = 100;
[map.distMap, map.lon, map.lat] = initCities(map.nStops);

%% --- params of TabuSearch
times = conf.times; % 探索の回数
timesNeighbor = conf.timesNeighbor; % 近傍探索の回数
sizeTabuList = conf.sizeTabuList; % sizeTabuList < nStops * ( nStops -1 ) * 1/2

%% --- search
initTour = getRandomTour(map.nStops);
doPlot = 1;
[bestCost, bestTour] = doTabuSearch(map,conf,initTour,doPlot);
