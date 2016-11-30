function acidMap = getUpdatedAcidMap(acidMap,agents,evaporationRate,acidQuantity)
  tourSize = size(agents,2)-1;
  % evaporation
  acidMap = ( 1 - evaporationRate) * acidMap;
  for i = 1:size(agents,1)
    for j = 1:tourSize
      from = agents(i,j); 
      if j == tourSize
        to = 1;
      else
        to = agents(i,j+1);
      end
      if  from > to % Require this permutation
        temp = from;
        from = to;
        to = temp;
      end
      acidMap(from,to) = acidMap(from,to) + acidQuantity/agents(i,end);
    end
  end
end
