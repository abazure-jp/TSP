function tour = getTourByProbability(numOfCities,prob)
  load('usborder.mat','x','y','xx','yy');
  tour = zeros(1,numOfCities);
  tour(1,1) = 1; % スタート地点は必ず都市番号1とする

  % passedCities: 行番号は都市番号。各要素にはブール代数が入り、該当都市が通過済であれば1、でなければ0
  passedCities = zeros(1,numOfCities);
  passedCities(1,1) = 1; % 開始地点はすでに通過しているものとする

  for i = 1:numOfCities-1
    % passedCitiesを元に、次の行き先の都市番号が格納されたベクトルを作成する。
    nextList = getNextList(passedCities);
    % 次の候補地を確率で決める。
    current = tour(1,i);
    nextProb = zeros(size(nextList,2),2); % [nextcity prob]
    % 経路の候補を作る
    for k=1:size(nextList,2)
      nextProb(k,1) = nextList(1,k);

      if current > nextProb(k,1)
        from = nextProb(k,1);
        to = current;
      else
        from = current;
        to = nextProb(k,1);
      end
      nextProb(k,2) = prob(from,to) ;
    end

    %% TODO: matlabの確率分布関数で実装する
    nextProb = sortrows(nextProb,-2);
    sumProb = sum(nextProb(:,2));
    r = rand * sumProb;
    sumProb = 0;

    for l = 1:size(nextProb,1)
      sumProb = sumProb + nextProb(l,2);
      if r < sumProb
        nextIs = nextProb(l,1);
      break;
      end
    end

    tour(1,i+1) = nextIs;
    passedCities(1,nextIs) = 1;
  end
end
