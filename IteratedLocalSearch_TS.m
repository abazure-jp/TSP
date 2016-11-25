% Befor use this repository, you have to add the path at once.
p = path;
pathAssets = strcat(pwd,'/assets/');
path(path,pathAssets);
clc;
close all;
clear;

%% --- Create cities and map
nStops = 100; % you can use any number, but the problem size scales as N^2
[distMap, stopsLon, stopsLat] = initCities(nStops);

%% --- params of TabuSearch
times = 299; % 探索の回数
timesNeighbor = 30; % 近傍探索の回数
sizeTabuList = times * 0.4;

%% --- params of IteratedLocalSearch
iterate = 19;
bestCosts = zeros(iterate+1,1);

%% --- Step1: output initial tour;
initTour = getRandomTour(nStops);

%% --- Step2: LocalSearch(tour)
% This code use Tabu Search (2-opt) as local search.
doPlot = 1;
[bestCost, bestTour] = doTabuSearch(distMap,stopsLon,stopsLat,times,timesNeighbor,sizeTabuList,nStops,initTour,doPlot);
bestCosts(1,1) = bestCost;

%% --- Step3: LocalSearch(tour)
% Step2で得た局所解を中心に、局所解を抜け出す目的でN-Optを行った状態を初期値しとして局所解を行なう。
% これをiterate回行なう

for i = 1:iterate
  nextInitTour = getNOpt(bestTour,4);
  [bestCost, bestTour] = doTabuSearch(distMap,stopsLon,stopsLat,times,timesNeighbor,sizeTabuList,nStops,nextInitTour,doPlot);
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
