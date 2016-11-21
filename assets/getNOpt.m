function tour = getNOpt(tour,N)
  nStops = size(tour,1);
  cities = getNRandomCities(N,nStops); % ランダムな都市番号がN個入っている
  temp = sort(cities); % これをソート

  for i = 1:N
    tour(cities(i)) = tour(temp(i)); % 入れ替える
  end

end
