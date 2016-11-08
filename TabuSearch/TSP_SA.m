clc;
clear all;
figure;

% �܂��e�m�[�h���v���b�g����B
% ���ȃm�[�h���s�s�ł��B
load('usborder.mat','x','y','xx','yy');
rng(3,'twister') % makes a plot with stops in Maine & Florida, and is reproducible
nStops = 5; % you can use any number, but the problem size scales as N^2
stopsLon = zeros(nStops,1); % allocate x-coordinates of nStops
stopsLat = stopsLon; % allocate y-coordinates
n = 1;
while (n <= nStops)
    xp = rand*1.5;
    yp = rand;
    if inpolygon(xp,yp,xx,yy) % test if inside the border
        stopsLon(n) = xp;
        stopsLat(n) = yp;
        n = n+1;
    end
end
plot(x,y,'Color','red'); % draw the outside border
hold on
plot(stopsLon,stopsLat,'*b')
hold off

% idxs: ���ɑS�Ẵu�����`��ԗ���������
idxs = nchoosek(1:nStops,2);

% dist: �e�u�����`�̃R�X�g���A�ܓx�o�x���������s�^�S���X�̒藝�Ōv�Z����B
dist = hypot(stopsLat(idxs(:,1)) - stopsLat(idxs(:,2)), ...
             stopsLon(idxs(:,1)) - stopsLon(idxs(:,2)));

% lendsit: �u�����`�̑����BnStops*(nstops-1)/2
lendist = length(dist);

% -------------------------------------

% TSP�́A�e�n�_����M���ŏ��鑍���H�̃R�X�g���ŏ���������ł���B
% �e�o�H�̃R�X�g���������x�N�g�� dist ����A�ŗǂȌv nStops �̌o�H��I��������ł���ƌ�����B
% �����ŁA�ǂ̌o�H��I�����邩���L�����o�C�i���x�N�g�� x_tsp ��p�ӂ���ƁA
% ���͎��̂悤�ɏ����\����B

%
%      min ( dist' * x_tsp )   �� x_tsp��dist�Ɠ��������̃x�N�g���ł���
%

% ��������ƁA����̐��������ݒ�o���邱�Ƃ�������B
% ��́A x_tsp �̔񕉒l�͂��傤�� nStops �łȂ���΂Ȃ�Ȃ��Ƃ�������ł���B
% ������́A��x�ʂ���

Aeq = spones(1:length(idxs)); % Adds up the number of trips
beq = nStops;

% �ȉ���for loop�ł͑I���\�ȃm�[�h���O�p�s��ŕ\�����Ă���H�̂��H
Aeq = [Aeq;spalloc(nStops,length(idxs),nStops*(nStops-1))] % allocate a sparse matrix
for ii = 1:nStops
    whichIdxs = (idxs == ii) % find the trips that include stop ii
    whichIdxs = sparse(sum(whichIdxs,2)) % include trips where ii is at either end
    whichIdxs = sum(whichIdxs,2) % include trips where ii is at either end
    Aeq(ii+1,:) = whichIdxs' % include in the constraint matrix
end
beq = [beq; 2*ones(nStops,1)];


intcon = 1:lendist;
lb = zeros(lendist,1);
ub = ones(lendist,1);

%%Initialize


opts = optimoptions('intlinprog','Display','off');
[x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,[],[],Aeq,beq,lb,ub,opts);

%% Visualize the Solution

hold on
segments = find(x_tsp); % Get indices of lines on optimal path
lh = zeros(nStops,1); % Use to store handles to lines on plot
lh = updateSalesmanPlot(lh,x_tsp,idxs,stopsLon,stopsLat);
title('Solution with Subtours');

tours = detectSubtours(x_tsp,idxs);
numtours = length(tours); % number of subtours
fprintf('# of subtours: %d\n',numtours);

%%
% Include the linear inequality constraints to eliminate subtours, and
% repeatedly call the solver, until just one subtour remains.

title('Solution with Subtours Eliminated');
hold off

disp(output.absolutegap)