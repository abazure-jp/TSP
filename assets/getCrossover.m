% 親は二人の時だけ実装済
function baby = getCrossover(crossover,parents)
  baby = parents(1,:);
  baby(1,crossover.border:end) = parents(2,crossover.border:end);
  rest = size(parents,2) - crossover.border + 1;% 残りの遺伝子
  finalIdx = size(parents,2);

  if strcmp(crossover.type,'One-point') == 1
    baby(1,crossover.border:end) = parents(2,crossover.border:end);
    j = crossover.border;
    for i = 1:size(parents,2)
      if isempty(find(baby == parents(2,i), 1)) % まだ持っていない都市をサーチ
        baby(1,j) = parents(2,i); % 持っていない都市ならばbabyに採用
        j = j +1;
      end
      if j > finalIdx
        break;
      end
    end
  else
    display('hogehoge~~');
  end
end
