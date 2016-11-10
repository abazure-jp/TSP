close all;
clc;
clear;

load('usborder.mat','x','y','xx','yy');
rng(3,'twister') % makes a plot with stops in Maine & Florida, and is reproducible
nStops =  20; % you can use any number, but the problem size scales as N^2
times = 499; % 探索の回数
timesNeighbor = 30; % 近傍探索の回数
sizeTabuList = timesNeighbor * times * 0.3;
stopsLon = zeros(nStops,1); % allocate x-coordinates of nStops
stopsLat = stopsLon; % allocate y-coordinates
neighborTours = [];
neighborTourCosts = [];
theBestTour = [];
theBestCosts = [];
localminCosts = [];
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

% idxs: 次に全てのブランチを網羅した索引
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

% lendsit: ブランチの総数。nStops*(nstops-1)/2
lendist = length(dist);

% 無作為な初期値を出力。
initTour = getInitTour(nStops);

% 総距離を計算する。
totalCost = getTotalDist(initTour,distMap);
theBestCosts = [ totalCost ];

% plot the path in the graph
figure;
plot(x,y,'Color','red'); % draw the outside border
hold on
plot(stopsLon,stopsLat,'*b')
drawTourPath(stopsLon,stopsLat,initTour);
hold off

%% TabuSearch
tour = initTour;
tabuList = initTour;
theBestTour = initTour;

for( n = 1:times )
% 現在のツアーの内、j番目とk番目(j!=k,j != 1, k != 1)を入れ替える。
% これを近傍探索とと定義してtimesNeighbor回繰り返す
  for i = 1:timesNeighbor

    % 近傍探索の乱数を選考する。タブーリストにかぶれば乱数選考をやり直す
    j = randi(nStops);
    k = randi(nStops);
    while j == k || j == 1 || k == 1
      j = randi(nStops);
      k = randi(nStops);
    end
    while 1
      neighborTour = getNeighborhood(tour,j,k);
      if checkTabuList(tabuList,neighborTour) == 0
        break;
      end
    end

    neighborTourCost = getTotalDist(neighborTour,distMap);
    neighborTours = [ neighborTours ; neighborTour ];
    neighborTourCosts = [ neighborTourCosts ; neighborTourCost ];

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
  localminCosts = [localminCosts ; getTotalDist(tour,distMap);];
  % 過去のベストな値との比較をして、優れば更新
  if getTotalDist(tour,distMap) < getTotalDist(theBestTour,distMap)
    theBestTour = tour;
  end
  theBestCosts = [theBestCosts ; getTotalDist(theBestTour,distMap);];
end

% 可視化
figure;
plot(x,y,'Color','red'); % draw the outside border
hold on
plot(stopsLon,stopsLat,'*b')
drawTourPath(stopsLon,stopsLat,theBestTour);
hold off

% 各時点での最小値の遷移
figure;
plot(theBestCosts,'LineWidth',2);
xlabel('iteration');
ylabel('Best Cost');
grid on;

% 各近傍探索の最小値
figure;
plot(localminCosts,'LineWidth',2);
xlabel('iteration');
ylabel('LocalMin Cost');
grid on;
