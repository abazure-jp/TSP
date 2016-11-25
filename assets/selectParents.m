function idxs = selectParents(numOfParents,listOfCandidates)
  idxs = zeros(1,numOfParents);
  % 最小化問題なので^-1しとく
  listOfCandidates = listOfCandidates.^-1;

  for j = 1:numOfParents
    sum_fitness = sum(listOfCandidates);
    r = rand * sum_fitness;
    sum_fitness = 0;

    for i = 1:size(listOfCandidates,1)
      sum_fitness = sum_fitness + listOfCandidates(i);
      if r < sum_fitness
        idxs(1,j) = i;
        listOfCandidates(i) = 0; % 次の親候補選考で重複を避けるため
        break;
      end
    end
  end
end
