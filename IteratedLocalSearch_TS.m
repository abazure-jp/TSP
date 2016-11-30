% Befor use this repository, you have to add the path at once.
p = path;
pathAssets = strcat(pwd,'/assets/');
path(path,pathAssets);
clc;
close all;
clear;

%% --- Create cities and map
map.nStops = 100;
[map.distMap, map.lon, map.lat] = initCities(map.nStops);

%% --- Load config
conf = getConfig( 'TabuSearch', map.nStops );

%% --- params of IteratedLocalSearch
iterate = 19;
bestCosts = zeros(iterate+1,1);

%% --- Step1: output initial tour;
initTour = getRandomTour(map.nStops);

%% --- Step2: LocalSearch(tour)
% This code use Tabu Search (2-opt) as local search.
doPlot = 1;
[ bestCost, bestTour ] = doTabuSearch(map,conf,initTour,doPlot);
bestCosts(1,1) = bestCost;

%% --- Step3: LocalSearch(tour)
% Step2で得た局所解を中心に、局所解を抜け出す目的でN-Optを行った状態を初期値しとして局所解を行なう。
% これをiterate回行なう

for i = 1:iterate
  nextInitTour = getNOpt(bestTour,4);
  [ bestCost, bestTour ] = doTabuSearch(map,conf,initTour,doPlot);
  bestCosts(i+1,1) = bestCost;
end

%% --- 可視化
if doPlot == 1
  % 各時点での最小値の遷移
  figure('Name','Best value of each local search','NumberTitle','off')
  plot(bestCosts,'LineWidth',2);
  xlabel('iteration');
  ylabel('Best Cost');
  grid on;
end
