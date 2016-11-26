function tour = getRandomTour(numOfCities)
  load('usborder.mat','x','y','xx','yy');
  tour = zeros(1,numOfCities);
  tour(1,1) = 1; % スタート地点は必ず都市番号1とする

  % passedCities: 行番号は都市番号。各要素にはブール代数が入り、該当都市が通過済であれば1、でなければ0
  passedCities = zeros(1,numOfCities);
  passedCities(1,1) = 1; % 開始地点はすでに通過しているものとする

  for i = 1:numOfCities-1
    % passedCitiesを元に、次の行き先の都市番号が格納されたベクトルを作成する。
    nextList = getNextList(passedCities);
    % 次の候補地を決める。
    nextIs = nextList(1,randi(size(nextList,2)));
    tour(1,i+1) = nextIs;
    passedCities(1,nextIs) = 1;
  end
end
