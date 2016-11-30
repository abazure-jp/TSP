% passedCitiesはNx1のバイナリベクトル。
function nextList = getNextList(passedCities)
  nextList = NaN(1,size(passedCities,1) -sum(passedCities));
  for city = 1:size(passedCities,2)
    if passedCities(1,city) == 0
        nextList(1,size(nextList,2)+1) = city;
    end
  end
end
