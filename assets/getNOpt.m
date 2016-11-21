function tour = getNOpt(tour,N)
  nStops = size(tour,1);
  values = getNRandomCities(N,nStops);
  temp = sort(values);

  for i = 1:N
    tour(values(i)) = temp(i);
  end

end
