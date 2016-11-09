function localmin = getBtterSolution(tours,tour_costs)
  [value, index] = min(tour_costs);
  localmin = [ value, tours( index, :)];
end
