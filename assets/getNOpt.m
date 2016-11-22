function tour = getNOpt(tour,N)
  nStops = size(tour,2);
  cities = getNRandomCities(N,nStops); % 1以外かつ重複しないランダムな都市番号がN個入っている
  temp = sort(cities); % これをソート

  for i = 1:N
    tour(temp(i)) = cities(i)
  end

end
