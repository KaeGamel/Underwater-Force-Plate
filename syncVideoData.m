
%%% Zero Video according to weight drop
FR = 240;
[m,n] = size(binDat);
totalTime = m/240;
timeS = linspace(0,totalTime,m)';

weight = find(binDat(:,4)==1);
weight0 = min(weight);

timePost = timeS(1:m-weight0+1);
timePre = -flip(timeS(2:weight0));
binTime = [timePre; timePost];
binDat(:,6) = binTime;

binDatTrial = binDat(binDat(:,5) ==1,:);
TrialStart = binDatTrial(1,6); TrialEnd = binDatTrial(end,6);

%%% Zero Force Trace according to weight drop
FRQ = 1000;
[m2,n2] = size(calData);

%% Select weight drop
plot(calData(:,1),'k.');
hold on
zoom on
pause;
    [x, y] = getpts();
    [k,dist] = dsearchn([calData(:,1),linspace(1,m2,m2)'],[y,x]);
    yNew = calData(k,1);
plot(x,y,'y.',k,yNew,'r+'); hold off

forceTimeTotal = m2/1000;
forceTimePost = time(1:m2-k+1);
forceTimePre = -flip(time(2:k));
forceTime = [forceTimePre;forceTimePost];
calData(:,4) = forceTime;

A = repmat(forceTime,[1 2]);
[minValue,closestIndex] = min(abs(A-[TrialStart, TrialEnd]));

forceDatTrial = calData(closestIndex(1):closestIndex(2), :);

%% Plot Data
PectFin = binDatTrial(2:end,2)-(binDatTrial(1:end-1,2));
PectFinOff = find(PectFin == -1);
PectFinOn = find(PectFin == 1);

figure
hold on
plot(forceDatTrial(:,4), forceDatTrial(:,1),'b')
plot(forceDatTrial(:,4), forceDatTrial(:,2),'c')
plot(forceDatTrial(:,4), forceDatTrial(:,3),'m')
xline(binDatTrial(PectFinOff,6),'k')
xline(binDatTrial(PectFinOn,6),'r')


PelvFin = binDatTrial(2:end,3)-(binDatTrial(1:end-1,3));
PelvFinOff = find(PelvFin == -1);
PelvFinOn = find(PelvFin == 1);

figure
hold on
plot(forceDatTrial(:,4), forceDatTrial(:,1),'b')
plot(forceDatTrial(:,4), forceDatTrial(:,2),'c')
plot(forceDatTrial(:,4), forceDatTrial(:,3),'m')
xline(binDatTrial(PelvFinOff,6),'k')
xline(binDatTrial(PelvFinOn,6),'r')

saveName = 'Pbarb38_03_2021_11_19_';
% writematrix(binDatTrial, [saveName,'_trialBinDat.csv'])
% writematrix(forceDatTrial, [saveName,'_trialForceDat.csv'])

%%Re-zero if necessary
p1 = polyfit(forceDatTrial(:,4), forceDatTrial(:,1),1);
p2 = polyfit(forceDatTrial(:,4), forceDatTrial(:,2),1);
p3 = polyfit(forceDatTrial(:,4), forceDatTrial(:,3),1);

y1 = polyval(p1,forceDatTrial(:,4));
y2 = polyval(p2,forceDatTrial(:,4));
y3 = polyval(p3,forceDatTrial(:,4));

V1 = forceDatTrial(:,1)-y1;
F1 = forceDatTrial(:,2)-y2;
L1 = forceDatTrial(:,3)-y3;

reZeroedForceDat = [V1, F1, L1, forceDatTrial(:,4)];
% writematrix(reZeroedForceDat, [saveName,'_trialForceDat_reZeroed.csv'])

reZeroedForceDat = reZeroedForceDat(25:end-10,:);
reZeroedForceDat = reZeroedForceDat(1000:end-400,:);

figure
hold on
plot(reZeroedForceDat(:,4), reZeroedForceDat(:,1),'b','LineWidth',1.5)
plot(reZeroedForceDat(:,4), reZeroedForceDat(:,2),'c','LineWidth',1)
plot(reZeroedForceDat(:,4), reZeroedForceDat(:,3),'m','LineWidth',1)
xline(binDatTrial(PectFinOff,6),'k')
xline(binDatTrial(PectFinOn,6),'r')
set(gca,'FontSize',18)
xlim([-3.1,-2.0])

figure
hold on
plot(reZeroedForceDat(:,4), reZeroedForceDat(:,1),'b','LineWidth',1.5)
plot(reZeroedForceDat(:,4), reZeroedForceDat(:,2),'c','LineWidth',1)
plot(reZeroedForceDat(:,4), reZeroedForceDat(:,3),'m','LineWidth',1)
xline(binDatTrial(PelvFinOff,6),'k')
xline(binDatTrial(PelvFinOn,6),'r')
set(gca,'FontSize',18)
xlim([-3.1,-2.0])
