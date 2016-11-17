% j != k && j != 1 && k != 1 && j < k
% を満たすjとkを返す
function  [ j, k ] = get2RandomCities(nStops)
  j = randi(nStops);
  k = randi(nStops);

  while j == k || j == 1 || k == 1
    j = randi(nStops);
    k = randi(nStops);
  end

  % 実装の関係で必ず j < k となっていて欲しいのでそうする
  if j > k
    temp = j;
    j = k;
    k = temp;
  end

end
