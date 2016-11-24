function [ bestTour bestCost ] = doGeneticAlgorithm(map,agents,kill,select,crossover,generations);
  population = size(agents,1);
  border = population - (population * kill.rate); % 上から何番目

  cost = map.nStops + 1;
  tour = 1:map.nStops;

  for i = 1:generations
    agents = sortrows(agents,map.nStops + 1);
    agents(border:end,:) = 0;

    for j = border:population
      if rand < crossover.rate
        % 親を決める
        parent_idxs = selectParents(crossover.parents,agents(1:border-1,cost));
        parents = [ agents(parent_idxs(1),tour) ; agents(parent_idxs(2),tour) ];
        agents(j,tour) = getCrossover(crossover,parents);
        agents(j,cost) = getTotalDist(agents(j,tour),map.distMap);
      else
        % 親っていうかミュータント
        mutant_idx = selectParents(1,agents(1:border-1,cost));
        % genotypeがバイナリでないのでNOptを突然変異とする
        agents(j,tour) = getNOpt(agents(mutant_idx,tour),5);
        agents(j,cost) = getTotalDist(agents(j,tour),map.distMap);
      end
    end
  end
bestTour = agents(1,tour);
bestCost = agents(1,cost);
end
