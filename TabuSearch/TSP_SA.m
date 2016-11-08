clc;
clear all;
figure;

% まず各ノードをプロットする。
% ちなノード＝都市です。
load('usborder.mat','x','y','xx','yy');
rng(3,'twister') % makes a plot with stops in Maine & Florida, and is reproducible
nStops = 5; % you can use any number, but the problem size scales as N^2
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
plot(x,y,'Color','red'); % draw the outside border
hold on
plot(stopsLon,stopsLat,'*b')
hold off

% idxs: 次に全てのブランチを網羅した索引
idxs = nchoosek(1:nStops,2);

% dist: 各ブランチのコストを、緯度経度をつかったピタゴラスの定理で計算する。
dist = hypot(stopsLat(idxs(:,1)) - stopsLat(idxs(:,2)), ...
             stopsLon(idxs(:,1)) - stopsLon(idxs(:,2)));

% lendsit: ブランチの総数。nStops*(nstops-1)/2
lendist = length(dist);

% -------------------------------------

% TSPは、各地点を一筆書で巡る総順路のコストを最小化する問題である。
% 各経路のコストが入ったベクトル dist から、最良な計 nStops の経路を選択する問題であると言える。
% ここで、どの経路を選択するかを記したバイナリベクトル x_tsp を用意すると、
% 問題は次のように書き表せる。

%
%      min ( dist' * x_tsp )   ※ x_tspはdistと同じ長さのベクトルである
%

% そうすると、幾つかの制約条件を設定出来ることが分かる。
% 一つは、 x_tsp の非負値はちょうど nStops 個でなければならないという制約である。
% もう一つは、一度通った

Aeq = spones(1:length(idxs)); % Adds up the number of trips
beq = nStops;

% 以下のfor loopでは選択可能なノードを三角行列で表現している？のか？
Aeq = [Aeq;spalloc(nStops,length(idxs),nStops*(nStops-1))] % allocate a sparse matrix
for ii = 1:nStops
    whichIdxs = (idxs == ii) % find the trips that include stop ii
    whichIdxs = sparse(sum(whichIdxs,2)) % include trips where ii is at either end
    whichIdxs = sum(whichIdxs,2) % include trips where ii is at either end
    Aeq(ii+1,:) = whichIdxs' % include in the constraint matrix
end
beq = [beq; 2*ones(nStops,1)];


intcon = 1:lendist;
lb = zeros(lendist,1);
ub = ones(lendist,1);

%%Initialize


opts = optimoptions('intlinprog','Display','off');
[x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,[],[],Aeq,beq,lb,ub,opts);

%% Visualize the Solution

hold on
segments = find(x_tsp); % Get indices of lines on optimal path
lh = zeros(nStops,1); % Use to store handles to lines on plot
lh = updateSalesmanPlot(lh,x_tsp,idxs,stopsLon,stopsLat);
title('Solution with Subtours');

tours = detectSubtours(x_tsp,idxs);
numtours = length(tours); % number of subtours
fprintf('# of subtours: %d\n',numtours);

%%
% Include the linear inequality constraints to eliminate subtours, and
% repeatedly call the solver, until just one subtour remains.

title('Solution with Subtours Eliminated');
hold off

disp(output.absolutegap)