function map = getHeuristicsMap(mat,distMap)
  for i = 1:size(mat,1)
    for j = i+1:size(mat,1)
      map(i,j) = 1/distMap(strcat(num2str(i),'&',num2str(j)));
    end
  end
  map(size(mat,1),:) = NaN;
end