function [value tour index] = getBetterSolution(tours,tour_costs)
  [value, index] = min(tour_costs);
  tour =  tours( index, :);
end
