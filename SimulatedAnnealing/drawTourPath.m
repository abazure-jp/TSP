function drawTourPath(stopsLon,stopsLat,tour)
  for i = 1:size(tour,2)
    from = tour(i);
    % ツアーの最後の行き先は開始地点だが、tourベクトルの最後の行き先は開始地点の一つ前の都市となっている。このままではtour(i+1)で参照エラーとなるため、最後のループのときだけ例外処理をする
    if i == size(tour,2)
      to = 1;
    else
      to = tour(i+1);
    end
  plot([stopsLon(from) stopsLon(to)],[stopsLat(from) stopsLat(to)],'-o')
  end
end
