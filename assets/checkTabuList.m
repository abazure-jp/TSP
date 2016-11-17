function bool = checkTabuList(tabuList,j,k)
  bool = 0;
  for i = 1:size(tabuList,1)
    if tabuList(i,:) == [j k]
      bool = 1;
    end
  end
end
