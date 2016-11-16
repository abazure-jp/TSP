% Befor use this repository, you have to add the path at once.
% p = path;
% pathAssets = strcat(pwd,'/assets/');
% path(path,pathAssets);

%% --- Create cities and map
nStops = 100; % you can use any number, but the problem size scales as N^2
[distMap stopsLon stopsLat] = initCities(nStops);

%% --- params of Simulated Aneealing
times = 499; % 探索の回数
temperature = 25000;
cool_coefficient = 0.998;

%% --- search
initTour = getRandomTour(nStops);
doPlot = 1;
[ bestCost bestTour ] = doSimulatedAnnealing(distMap,stopsLon,stopsLat,times,temperature,nStops,initTour,doPlot);
