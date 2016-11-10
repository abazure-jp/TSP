function bool = checkTabuList(tabuList,tour)
  bool = 0;
  for i = 1:size(tabuList,1)
    if tabuList(i,:) == tour
      bool = 1;
    end
  end

end
