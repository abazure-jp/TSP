close all;
clc;
clear;

p = path;
pathAssets = strcat(pwd,'/assets/');
path(path,pathAssets);

load('usborder.mat','x','y','xx','yy');
% rng(3,'twister') % makes a plot with stops in Maine & Florida, and is reproducible
nStops =  48; % you can use any number, but the problem size scales as N^2

%% --- params of TabuSearch
times = 199; % 探索の回数
timesNeighbor = 30; % 近傍探索の回数
sizeTabuList = timesNeighbor * times * 0.3;
theBestCosts = zeros(times+1,1);
neighborTours = zeros(timesNeighbor,nStops);
neighborTourCosts = zeros(timesNeighbor,1);
bestNeighborCosts = zeros(times+1,1);

%% --- params of IteratedLocalSearch


stopsLon = zeros(nStops,1); % allocate x-coordinates of nStops
stopsLat = stopsLon; % allocate y-coordinates

n = 1;

while (n <= nStops)
    xp = rand*1.5;
    yp = rand;
    if inpolygon(xp,yp,xx,yy) % test if inside the border
        stopsLon(n) = xp;
        stopsLat(n) = yp;
        n = n+1;
    end
end

% idxs: 全てのブランチを網羅した索引
idxs = nchoosek(1:nStops,2);

% dist: 各ブランチのコストを、緯度経度をつかったピタゴラスの定理で計算する。
dist = hypot(stopsLat(idxs(:,1)) - stopsLat(idxs(:,2)), ...
             stopsLon(idxs(:,1)) - stopsLon(idxs(:,2)));

% idxsとdistを連結させた経路辞書の作成
distMap = containers.Map;
% idxsはN行２列の行列であり、それぞれの列に異なる都市番号が格納されている。
% この二点を一つの文字列として連結し、連想配列のキーとして扱う。
for i = 1:size(idxs,1)
    key = strcat(num2str(idxs(i,1)),'&',num2str(idxs(i,2)));
    value = dist(i);
    distMap(key) = value;
end

initTour = getInitTour(nStops);

totalCost = getTotalDist(initTour,distMap);
theBestCosts =  totalCost;

% plot the path in the graph
figure('Name','Initial Tour','NumberTitle','off')
plot(x,y,'Color','red'); % draw the outside border
hold on
plot(stopsLon,stopsLat,'*b')
drawTourPath(stopsLon,stopsLat,initTour);
hold off


%% Iterated Local Search
for N = 1:Iterater

  %% TabuSearch
  tour = initTour;
  tabuList = initTour;
  theBestTour = initTour;

  for n = 1:times
    % 現在のツアーの内、j番目とk番目(j!=k,j != 1, k != 1)を入れ替える。
    % これを近傍探索と定義してtimesNeighbor回繰り返す
    for i = 1:timesNeighbor
      flag = 1;
      % 近傍探索の乱数を選考する。タブーリストにかぶれば乱数選考をやり直す
      j = randi(nStops);
      k = randi(nStops);

      while  flag == 1
        if j == k || j == 1 || k == 1
          j = randi(nStops);
          k = randi(nStops);
        else
          neighborTour = getNeighborhood(tour,j,k);
          if checkTabuList(tabuList,neighborTour) == 0
            flag = 0;
          else
            j = k;
          end
        end
      end

      neighborTourCost = getTotalDist(neighborTour,distMap);
      neighborTours(i,:) = neighborTour;
      neighborTourCosts(i,:) = neighborTourCost;

      % tabuListが埋まったらデキューしてリストサイズを保つ
      tabuList = [ tabuList ; neighborTour ];
      if size(tabuList,1) > sizeTabuList
        tabuList = tabuList(2:end,:);
      end
    end

    %% 近傍探索の結果から最良なものを判定する
    %% あくまで近傍のリストとタブーサーチは別物であることに留意
    tour_localmin = getBetterSolution(neighborTour,neighborTourCost);
    tour = tour_localmin(1,2:end); % tour_localmin = [ cost city_a city_e city_d ... ]
    neighborTours = [];
    neighborTourCosts = [];
    bestNeighborCosts(n,1) =  getTotalDist(tour,distMap);
    % 過去のベストな値との比較をして、優れば更新
    if getTotalDist(tour,distMap) < getTotalDist(theBestTour,distMap)
      theBestTour = tour;
    end
    theBestCosts(n+1,1) = getTotalDist(theBestTour,distMap);
  end %% end of Tabu search
end %% end of iterated local search


% 可視化
figure('Name','Best Tour','NumberTitle','off')
plot(x,y,'Color','red'); % draw the outside border
hold on
plot(stopsLon,stopsLat,'*b')
drawTourPath(stopsLon,stopsLat,theBestTour);
hold off

% 各時点での最小値の遷移
figure('Name','Best value of each iteration','NumberTitle','off')
plot(theBestCosts,'LineWidth',2);
xlabel('iteration');
ylabel('Best Cost');
grid on;

% 各近傍探索の最小値
figure('Name','Best value of each neighborhood search','NumberTitle','off')
plot(bestNeighborCosts,'LineWidth',2);
xlabel('iteration');
ylabel('Best Neighborhood Cost');
grid on;

% reset path
path(p);
