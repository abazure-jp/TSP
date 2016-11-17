% Befor use this repository, you have to add the path at once.
% p = path;
% pathAssets = strcat(pwd,'/assets/');
% path(path,pathAssets);

%% --- Create cities and map
nStops = 20; % you can use any number, but the problem size scales as N^2
[distMap stopsLon stopsLat] = initCities(nStops);

%% --- params of TabuSearch
times = 249; % 探索の回数
timesNeighbor = 20; % 近傍探索の回数
sizeTabuList = 8;

%% --- search
initTour = getRandomTour(nStops);
doPlot = 1;
[bestCost bestTour] = doTabuSearch(distMap,stopsLon,stopsLat,times,timesNeighbor,sizeTabuList,nStops,initTour,doPlot);
