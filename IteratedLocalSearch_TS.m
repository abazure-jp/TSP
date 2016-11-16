%% --- Create cities and map
nStops = 100; % you can use any number, but the problem size scales as N^2
[distMap stopsLon stopsLat] = initCities(nStops);

%% --- params of TabuSearch
times = 99; % 探索の回数
timesNeighbor = 30; % 近傍探索の回数
sizeTabuList = timesNeighbor * times * 0.3;

%% --- params of IteratedLocalSearch
iterate = 19;
bestCosts = zeros(iterate+1,1);

%% --- Step1: output initial tour;
initTour = getRandomTour(nStops);

%% --- Step2: LocalSearch(tour)
% This code use Tabu Search (2-opt) as local search.
doPlot = 0;
[bestCost bestTour] = doTabuSearch(distMap,stopsLon,stopsLat,times,timesNeighbor,sizeTabuList,nStops,initTour,doPlot);
bestCosts(1,1) = bestCost;

%% --- Step3: LocalSearch(tour)
% 最初の近傍探索で得たツアーとはなるべく異なる点を初期値としてLocalSearchを行なう。
% 確率を使ってばらつきの保証をしたいところだが、面倒なのでひとまずは次の方法でばらつきの付与（笑)を試みる
% 局所探索で得た結果に対して、次の入れ替え処理を行なう。
% n番目に選択する都市 = 都市数 - n番目都市番号 + 2
% 逆数っぽいしょりなのでInversedTourと名付ける。
% これをiterate回行なう

for i = 1:iterate
  nextInitTour = getInversedTour(bestTour);
  [bestCost bestTour] = doTabuSearch(distMap,stopsLon,stopsLat,times,timesNeighbor,sizeTabuList,nStops,initTour,doPlot);
  bestCosts(i+1,1) = bestCost;
end

%% --- 可視化
if doPlot == 1
  % 各時点での最小値の遷移
  figure('Name','Best value of each iteration','NumberTitle','off')
  plot(bestCosts,'LineWidth',2);
  xlabel('iteration');
  ylabel('Best Cost');
  grid on;
end
