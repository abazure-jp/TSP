%% --- params of Cities
nStops =  48; % you can use any number, but the problem size scales as N^2

%% --- params of TabuSearch
times = 99; % 探索の回数
timesNeighbor = 30; % 近傍探索の回数
sizeTabuList = timesNeighbor * times * 0.3;

%% --- params of IteratedLocalSearch
iterate = 5;

%% --- Step1: output initial tour;
initTour = getRandomTour(nStops);

%% --- Step2: LocalSearch(tour)
% This code use Tabu Search (2-opt) as local search.
[bestCost bestTour] = doTabuSearch(times,timesNeighbor,sizeTabuList,nStops,initTour);

%% --- Step3: LocalSearch(tour)
% 最初の近傍探索で得たツアーとはなるべく異なる点を初期値としてLocalSearchを行なう。
% 確率を使ってばらつきの保証をしたいところだが、面倒なのでひとまずは次の方法でばらつきの付与（笑)を試みる
% 局所探索で得た結果に対して、次の入れ替え処理を行なう。
% n番目に選択する都市 = 都市数 - n番目都市番号 + 2
% 逆数っぽいしょりなのでInversedTourと名付ける。
% これをiterate回行なう

for i = 1:iterate
  nextInitTour = getInversedTour(bestTour);
  [bestCost bestTour] = doTabuSearch(times,timesNeighbor,sizeTabuList,nStops,nextInitTour);
end

