% rng(3,'twister') % makes a plot with stops in Maine & Florida, and is reproducible
nStops =  48; % you can use any number, but the problem size scales as N^2

%% --- params of TabuSearch
times = 99; % 探索の回数
timesNeighbor = 3; % 近傍探索の回数
sizeTabuList = timesNeighbor * times * 0.3;
theBestCosts = zeros(times+1,1);
neighborTours = zeros(timesNeighbor,nStops);
neighborTourCosts = zeros(timesNeighbor,1);
bestNeighborCosts = zeros(times,1);

[bestCost bestTour] = doTabuSearch(times,timesNeighbor,sizeTabuList,nStops);
