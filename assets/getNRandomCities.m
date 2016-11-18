% 上限がnStopsでかつ1でない重複しない乱数をN個返す
function value = getNRandomCities(N,nStops)
  value = randi(nStops-1,[1,N]);
  flag = 0;
  % 重複がなくなるまで乱数を選び直す
  while flag == 0
    for i = 1:N
      dup = size( value( value == value(i) ),2);
      if dup ~= 1 %重複ありなら
        value = randi(nStops-1,[1,N]);
        break;
      end
      if i == N
        flag = 1;
      end
    end
  end
  % 1を無くす
  value = value + 1;
  % ソート
  sort(value)
 end
