function baby = getCrossover(crossover,parents)
  baby = parents(1,:);
  if crossover.type == 'One-point'
    baby(1,crossover.border:end) = parents(2,crossover.border:end);
  else
    display('hogehoge~~');
  end
end
