%% To do before running
% STEP 0:   Run "correctDrift" first to get the force plate data in your
%           workspace, or read in the force data manually.
% STEP 1:   Read in the binary file AS A NUMERIC MATRIX by navigating to
%           the file in the Current Folder window and double clicking
% STEO 3:   Rename the imported matrix "binDat"


%% Zero Video according to weight drop
FR = 240;               % Frame rate of the camera
[m,n] = size(binDat);   % Size of the binary data matrix
totalTime = m/240;      % Total time represented in the binary data file
timeS = linspace(0,totalTime,m)'; % time array of the binary file

% Find the time in the binary file where the weight is put on the plate
weight = find(binDat(:,4)==1);
weight0 = min(weight);

% create a time array where the time the weight hits the plate is "zero"
% (everything after the weight drop will be positive and everything before
%  will be negative)
timePost = timeS(1:m-weight0+1);
timePre = -flip(timeS(2:weight0));
binTime = [timePre; timePost];
binDat(:,6) = binTime;

% Subset  binary data to include only frames that are part of the trial"
binDatTrial = binDat(binDat(:,5) ==1,:);
TrialStart = binDatTrial(1,6); TrialEnd = binDatTrial(end,6);

%% Zero Force Trace according to weight drop
FRQ = 1000;
[m2,n2] = size(calData);

% Select weight drop
plot(calData(:,1),'k.');
hold on
zoom on
pause;
    [x, y] = getpts();
    [k,dist] = dsearchn([calData(:,1),linspace(1,m2,m2)'],[y,x]);
    yNew = calData(k,1);
plot(x,y,'y.',k,yNew,'r+'); hold off

% create a time array where the time the weight hits the plate is "zero"
% This will match the time array for the binary data table
forceTimeTotal = m2/1000;
forceTimePost = time(1:m2-k+1);
forceTimePre = -flip(time(2:k));
forceTime = [forceTimePre;forceTimePost];
calData(:,4) = forceTime;

% Subset force data to include only frames that are part of the "trial"
A = repmat(forceTime,[1 2]);
[minValue,closestIndex] = min(abs(A-[TrialStart, TrialEnd]));
forceDatTrial = calData(closestIndex(1):closestIndex(2), :);

%% Find row value of fin on and off the plate (for plotting)
PectFin = binDatTrial(2:end,2)-(binDatTrial(1:end-1,2));
PectFinOff = find(PectFin == -1);
PectFinOn = find(PectFin == 1);

PelvFin = binDatTrial(2:end,3)-(binDatTrial(1:end-1,3));
PelvFinOff = find(PelvFin == -1);
PelvFinOn = find(PelvFin == 1);

%% Re-zero data so that we are accounting for the weight of the fish
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

%% Save the re-zeroed data so you don't have to run all this next time %%%
% saveName = 'Pbarb38_03_2021_11_19_'; %%% <- change this name
saveName = input('Save Name: ','s');
writematrix(binDatTrial, [saveName,'_trialBinDat.csv'])
writematrix(forceDatTrial, [saveName,'_trialForceDat.csv'])
writematrix(reZeroedForceDat, [saveName,'_trialForceDat_reZeroed.csv'])
writematrix(binDat, [saveName,'_binaryWithTime.csv']) % this will be used
                                                      % to sync kine data
%%

%% Plot data
% Use a command like this to plot a subset of the data
% reZeroedForceDat = reZeroedForceDat(25:end-10,:);
% reZeroedForceDat = reZeroedForceDat(1000:end-400,:);

figure
hold on
plot(reZeroedForceDat(:,4), reZeroedForceDat(:,1), 'Color', '#000000','LineWidth',1.5)
plot(reZeroedForceDat(:,4), reZeroedForceDat(:,2), 'Color', '#0072BD','LineWidth',1.5)
plot(reZeroedForceDat(:,4), reZeroedForceDat(:,3), 'Color', '#EDB120','LineWidth',1)
xline(binDatTrial(PectFinOff,6),'k')
xline(binDatTrial(PectFinOn,6),'r')
set(gca,'FontSize',18)
title('Force Trace with Pectoral Fin Bars')
xlabel('Time from Weight Drop (s)') 
ylabel('Force (g)') 
legend('Vertical', 'Fore-Aft', 'Lateral')

figure
hold on
plot(reZeroedForceDat(:,4), reZeroedForceDat(:,1), 'Color', '#000000','LineWidth',1.5)
plot(reZeroedForceDat(:,4), reZeroedForceDat(:,2), 'Color', '#0072BD','LineWidth',1.5)
plot(reZeroedForceDat(:,4), reZeroedForceDat(:,3), 'Color', '#EDB120','LineWidth',1)
xline(binDatTrial(PelvFinOff,6),'k')
xline(binDatTrial(PelvFinOn,6),'r')
set(gca,'FontSize',18)
title('Force Trace with Pelvic Fin Bars')
xlabel('Time from Weight Drop (s)') 
ylabel('Force (g)') 
legend('Vertical', 'Fore-Aft', 'Lateral')

% run this if you want to clean up your workspace
% clearvars -except binDat binDatTrial reZeroedForceDat PectFinOn PectFinOff
