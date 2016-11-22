function tour = getNOpt(tour,N)
  nStops = size(tour,2);
  indx = getNRandomCities(N,nStops); % 1以外かつ重複しないランダムな番号がN個入っている

  temp = zeros(size(N,2));

  % indx番目に訪れる都市の番号をtempへ保存
  for i = 1:N
    temp(i) = tour(indx(i));
  end

  % temp(i)をsortしてtourに入れ直す。
  temp = sort(temp);
  for i = 1:N
    tour(indx(i)) = temp(i);
  end
end
