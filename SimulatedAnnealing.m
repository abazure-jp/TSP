% Befor use this repository, you have to add the path at once.
% p = path;
% pathAssets = strcat(pwd,'/assets/');
% path(path,pathAssets);

%% --- Create cities and map
nStops = 100; % you can use any number, but the problem size scales as N^2
[distMap stopsLon stopsLat] = initCities(nStops);

%% --- params of Simulated Aneealing
temperature = 4000;
cool_coefficient = 0.935;

%% --- search
initTour = getRandomTour(nStops);
doPlot = 1;
[ bestCost bestTour ] = doSimulatedAnnealing(distMap,stopsLon,stopsLat,timesNeighbor,temperature,cool_coefficient,nStops,initTour,doPlot)
