clc;
clear;
figure;

% �܂��e�m�[�h���v���b�g����B
% ���ȃm�[�h���s�s�ł��B
load('usborder.mat','x','y','xx','yy');
rng(3,'twister') % makes a plot with stops in Maine & Florida, and is reproducible
nStops =  10; % you can use any number, but the problem size scales as N^2
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

% idxs��dist��A���������o�H�����̍쐬
distMap = containers.Map;
% idxs��N�s�Q��̍s��ł���A���ꂼ��̗�ɈقȂ�s�s�ԍ����i�[����Ă���B
% ���̓�_����̕�����Ƃ��ĘA�����A�A�z�z��̃L�[�Ƃ��Ĉ����B
for i = 1:size(idxs,1)
    key = strcat(num2str(idxs(i,1)),'&',num2str(idxs(i,2)));
    value = dist(i);
    distMap(key) = value;
end

% lendsit: �u�����`�̑����BnStops*(nstops-1)/2
lendist = length(dist);

% ����ׂȏ����l���o�́B
initTour = getInitTour(nStops)

% ���������v�Z����B
totalCost = getTotalDist(initTour,distMap);
% TODO: ���݂̃c�A�[���O���t�ɕ\������





