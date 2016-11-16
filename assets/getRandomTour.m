function initTour = getRandomTour(numOfCities)
  initTour = zeros(1,numOfCities);
  initTour(1,1) = 1; % スタート地点は必ず都市番号1とする

  % passedCities: 行番号は都市番号。各要素にはブール代数が入り、該当都市が通過済であれば1、でなければ0
  passedCities = zeros(1,numOfCities);
  % 開始地点はすでに通過しているものとする
  passedCities(1,1) = 1;

  % passedCitiesを元に、次の行き先の都市番号が格納されたベクトルを作成する。
  nextList = getNextList(passedCities);

  for i = 1:numOfCities-1
    % 次の候補地を決める。
    nextIs = nextList(1,randi(size(nextList,2)));
    initTour(1,i+1) = nextIs;
    passedCities(1,nextIs) = 1;
    nextList = getNextList(passedCities);
  end
end
