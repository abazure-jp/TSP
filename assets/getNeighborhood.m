function tour = getNeighborhood(tour,j,k)
  temp = tour(j);
  tour(j) = tour(k);
  tour(k) = temp;
end