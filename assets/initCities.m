function [distMap, stopsLon, stopsLat] = initCities(numCities)
  load('usborder.mat','x','y','xx','yy');
  stopsLon = zeros(numCities,1); % allocate x-coordinates of numCities
  stopsLat = stopsLon; % allocate y-coordinates

  n = 1;
  while (n <= numCities)
      xp = rand*1.5;
      yp = rand;
      if inpolygon(xp,yp,xx,yy) % test if inside the border
          stopsLon(n) = xp;
          stopsLat(n) = yp;
          n = n+1;
      end
  end

  % idxs: 全てのブランチを網羅した索引
  idxs = nchoosek(1:numCities,2);

  % dist: 各ブランチのコストを、緯度経度をつかったピタゴラスの定理で計算する。
  dist = hypot(stopsLat(idxs(:,1)) - stopsLat(idxs(:,2)), ...
               stopsLon(idxs(:,1)) - stopsLon(idxs(:,2)));

  % idxsとdistを連結させた経路辞書の作成
  distMap = containers.Map;
  % idxsはN行２列の行列であり、それぞれの列に異なる都市番号が格納されている。
  % この二点を一つの文字列として連結し、連想配列のキーとして扱う。
  for i = 1:size(idxs,1)
      key = strcat(num2str(idxs(i,1)),'&',num2str(idxs(i,2)));
      value = dist(i);
      distMap(key) = value;
  end
end
