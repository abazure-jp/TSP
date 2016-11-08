function totalDist = getTotalDist(tour,distMap)
  totalDist = 0;

  for i = 1:size(tour,2)
    from = tour(i);
    % ツアーの最後の行き先は開始地点だが、tourベクトルの最後の行き先は開始地点の一つ前の都市となっている。このままではtour(i+1)で参照エラーとなるため、最後のループのときだけ例外処理をする
    if i == size(tour,2)
      to = 1;
    else
      to = tour(i+1);
    end

    % 無向グラフだが辞書の関係で現在地<行き先の関係になければならない。
    % 関係が逆の場合は入れ替える
    if  from > to
      temp = from;
      from = to;
      to = temp;
    end

    from = num2str(from);
    to = num2str(to);

    totalDist = totalDist + distMap(strcat(from,'&',to))
  end
end
