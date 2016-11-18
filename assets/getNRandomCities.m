% 上限がnStopsでかつ1でない重複しない乱数をN個返す
function vector = getNRandomCities(N,nStops)
  vector = randi(nStops-1,[1,N]);
  flag = 0;
  % 重複がなくなるまで乱数を選び直す
  while flag == 0
    for i = 1:N
      dup = size( vector( vector == vector(i) ),2);
      if dup ~= 1 %重複ありなら
        vector = randi(nStops-1,[1,N]);
        break;
      end
      if i == N
        flag = 1;
      end
    end
  end
  % 1を無くす
  vector = vector + 1;
 end
