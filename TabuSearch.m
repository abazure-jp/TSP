% Befor use this repository, you have to add the path at once.
% p = path;
% pathAssets = strcat(pwd,'/assets/');
% path(path,pathAssets);
clc;
close all;
clear;

%% --- Create cities and map
nStops = 100; % you can use any number, but the problem size scales as N^2
[distMap, stopsLon, stopsLat] = initCities(nStops);

%% --- params of TabuSearch
times = 499; % 探索の回数
timesNeighbor = 30; % 近傍探索の回数
sizeTabuList = times * 0.4; % sizeTabuList < nStops * ( nStops -1 ) * 1/2

%% --- search
initTour = getRandomTour(nStops);
doPlot = 1;
[bestCost, bestTour] = doTabuSearch(distMap,stopsLon,stopsLat,times,timesNeighbor,sizeTabuList,nStops,initTour,doPlot);
