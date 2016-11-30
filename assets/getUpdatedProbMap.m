function probMap = getUpdatedProbMap(acidMap,heuristicsMap,acidPow,heurisPow)
  tourSize = size(acidMap,1);
  probMap = zeros(tourSize,tourSize);
  % evaporation
  for i = 1:tourSize
    for j = i + 1:tourSize
      if acidMap(i,j) == 0
        probMap(i,j) = 1*heuristicsMap(i,j)^heurisPow;
      else
        probMap(i,j) = acidMap(i,j)^acidPow*heuristicsMap(i,j)^heurisPow;
      end
    end
  end
  probMap(tourSize,:) = NaN;
end
