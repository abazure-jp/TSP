function [inversedTour] = getInversedTour(tour)
  tourSize = size(tour,2);
  for i = 2:tourSize
    inversedTour(1,i) = tourSize - tour(1,i) + 2;
  end
  inversedTour(1,1) = 1;
end
