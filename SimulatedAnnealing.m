close all;
clc;
clear;

load('usborder.mat','x','y','xx','yy');
rng(3,'twister') % makes a plot with stops in Maine & Florida, and is reproducible
nStops =  20; % you can use any number, but the problem size scales as N^2
times = 499; % 探索の回数
temperature = 2500;
cool_coefficient = 1;
stopsLon = zeros(nStops,1); % allocate x-coordinates of nStops
stopsLat = stopsLon; % allocate y-coordinates
theBestTour = [];
theBestCosts = [];

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


tour = initTour;
%% Simulated Annealing
theBestTour = initTour;
while temperature > 0

  % まず近傍を出す
  j = randi(nStops);
  k = randi(nStops);
  while j == k || j == 1 || k == 1
    j = randi(nStops);
    k = randi(nStops);
  end
  neighborTour = getNeighborhood(tour,j,k);

  % よいスコアならtourを更新する
  tourCost = getTotalDist(tour,distMap)
  neighborTourCost = getTotalDist(neighborTour,distMap)

  if getTotalDist(tour,distMap) < getTotalDist(neighborTour,distMap)
    tour = neighborTour;
  elseif rand <= exp(temperature'*(neighborTourCost - tourCost))
    %悪いスコアでも確率pでtourを更新する
    tour = neighborTour;
  end

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
