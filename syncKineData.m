%% To do before running
% STEP  0:  Run "syncVideoData"
% STEP 1a:  If you just ran "syncVideoDat", you are good to go
% STEP 1b:  If you ran "syncVideoDat" on another day, you need to import
%           your "TRIALNAME_binaryWithTime.csv" AS A MATRIX and rename it
%           "binDat"
% STEP 2a:  If you just ran "syncVideoDat", you are good to go
% STEP 2b:  If you ran "syncVideoDat" on another day, you need to import
%           your "TRIALNAME_trialBinDat.csv" AS A MATRIX and rename it
%           "binDatTrial"
% STEP 2a:  If you just ran "syncVideoDat", you are good to go
% STEP 2b:  If you ran "syncVideoDat" on another day, you need to import
%           your "TRIALNAME_trialForceDat_reZeroed.csv" AS A MATRIX and 
%           rename it "reZeroedForceDat"

%% Sync time of force data with time of digitized data
% Create seperate time array from binary file
binTime = binDat(:,6);

% Import your DLT coordinates
[kineDatName, kineDatPath] = uigetfile('*.*', 'Select your xyzpts file.');
kineDat = readtable([kineDatPath,kineDatName]);

% Use the calibrate time vector from "syncVideoDat" to set the weight drop
% as time "0" in the DLT coordinates as well
kineDat = table2array(kineDat);
kineDat = [kineDat, binTime];
kineDatTrial = kineDat(binDat(:,5)==1,:);
time = kineDatTrial(:,end);

%% Axis of DLT Files 
% Z = horizontal
% Y = vertical
% X = medial=lateral
% ZY = fish running across frame
% XY = firh running towards camera
% XZ = "ventral view"

%% Variable Names
% eye2D - position of the eye in the lateral (ZY) view
% pectFinTip2D - position of the pectoral fin in the lateral (ZY) view
% shoulder2D - position of the shoulder in the lateral (ZY) view
% tail2D - position of the tail in the lateral (ZY) view 


%% Set ground to Y = 0
%find where pectoral fin is on the ground and set to zero
pectFinPlanted = kineDatTrial(binDatTrial(:,2) == 1,:);
pectFinTip2D = [kineDatTrial(:,6), kineDatTrial(:,5)];
pectFinPlanted2D = [pectFinPlanted(:,6),pectFinPlanted(:,5)];
p = polyfit(pectFinPlanted2D(:,1),pectFinPlanted2D(:,2),1);
y = polyval(p, pectFinTip2D(:,1));

%shift everything to "ground = zero" in the vertical axis
eye2D = [kineDatTrial(:,3), kineDatTrial(:,2)-y];
pectFinTip2D = [kineDatTrial(:,6), kineDatTrial(:,5)-y];
tail2D = [kineDatTrial(:,9), kineDatTrial(:,8)-y];
shoulder2D = [kineDatTrial(:,12), kineDatTrial(:,11)-y];

% calculate speed as [euclidean distance fish eye traveled] / [trial time]
trialTime = time(end)-time(1);
distance = pdist2([eye2D(1,1),eye2D(1,2)],[eye2D(end,1),eye2D(end,2)],'euclidean');
speed = distance/trialTime;

% find the peaks of max eye elevation
[k,p] = findpeaks(eye2D(:,2),'MinPeakProminence',0.002);
eyePeakX = eye2D(p,1); eyePeakY = eye2D(p,2);
%     figure
%     plot(eye2D(:,1),eye2D(:,2))
%     axis equal
%     hold on
%     plot(eyePeakX, eyePeakY, 'ro')

%% Pectoral fin kinematics
[m,~] = size(kineDatTrial);
shoulderAngle = [];

% find the angle between the eye, shoulder, and fin tip in the lateral view
for i = 1:m
    [angle,angleDeg] = abc_angle(eye2D(i,:), shoulder2D(i,:), pectFinTip2D(i,:),[0,1,0]);
    shoulderAngle = [shoulderAngle;angleDeg];
end

% find the peaks of max fin angle
[k,pectP] = findpeaks(pectFinTip2D(:,2),'MinPeakProminence',0.002);
pectPeakX = pectFinTip2D(pectP,1); pectPeakY = pectFinTip2D(pectP,2);
%     figure
%     plot(pectFinTip2D(:,1),pectFinTip2D(:,2))
%     axis equal
%     hold on
%     plot(pectPeakX, pectPeakY, 'ro')

% find start and stop times of indivudial steps
if PectFinOn(1) > PectFinOff(1)
% Fish starts with fin planted
    PectFinOn = [1; PectFinOn];
else
    PectFinOff = [1; PectFinOff];
end

if PectFinOn(end) > PectFinOff(end)
% Fish ends with fin planted
    PectFinOn = [PectFinOn;m];
else
     PectFinOff = [PectFinOff;m];
end

% loop through all the steps and calculate variables
% strokeDur: length of a step from pect fin plant - pect fin plant
% propulsive: length of time fin spends on the ground
% recovery: length of time fin spends in the air
timeStep = time(2)-time(1);
allFinPlants = sort([PectFinOn; PectFinOff]);
strokeDur = []; propulsive = []; recovery = [];
for j = 1:2:length(allFinPlants)-2
    cycle = allFinPlants(j:j+2);
    strokeDur = [strokeDur; timeStep*(cycle(end)-cycle(1))];
    propulsive = [propulsive; timeStep*(cycle(2)-cycle(1))];
    recovery = [recovery; timeStep*(cycle(end)-cycle(2))];
end

strokeLength = median(strokeDur);       strokeSTD = std(strokeDur);
propulsiveLength = median(propulsive);  propulsiveSTD = std(propulsive);
recoveryLength = median(recovery);      recoverySTD = std(recovery);
steps = length(allFinPlants)/2;

variablesToSave = [trialTime, speed, steps, strokeLength, strokeSTD, propulsiveLength, propulsiveSTD, recoveryLength, recoverySTD];
variablesToSave = array2table(variablesToSave, 'VariableNames', ...
                              {'Time.s', 'Speed.mPs', 'Steps', 'StepLength.s', 'StepSTD.s', 'PropulsiveLength.s', 'PropulsiveSTD.s', ... 
                               'RecoveryLength.s', 'RecoverySTD.s'});
    

%% Re-sample force to be at the same read-rate as video data
% this is useful for directly comparing variables over time
[m2,~] = size(reZeroedForceDat);
verticalF = resample(reZeroedForceDat(:,1),m,m2);
foreaftF = resample(reZeroedForceDat(:,2),m,m2);
lateralF = resample(reZeroedForceDat(:,3),m,m2);

%% Merge force data with dlt raw and calcularted data
saveName = input('Save Name: ','s');
mergedDat = [kineDatTrial, shoulderAngle, eye2D, verticalF, foreaftF, lateralF];
writematrix(mergedDat, [saveName,'_mergedData.csv'])
writetable(variablesToSave, [saveName,'_calculatedVariables.csv'])

%% Plots
figure
[hAx,hLine1,hLine2] = plotyy(time, shoulderAngle, time,verticalF);
xlabel('Time (s)')
ylabel(hAx(1),'Shoulder Angle (deg)') % left y-axis 
ylabel(hAx(2),'Vertical F (g)') % right y-axis
hLine1.LineWidth = 1.5; hLine2.LineWidth = 1.5; hLine2.LineStyle = ':';

figure
[hAx,hLine1,hLine2] = plotyy(time, shoulderAngle, time,foreaftF);
xlabel('Time (s)')
ylabel(hAx(1),'Shoulder Angle (deg)') % left y-axis 
ylabel(hAx(2),'Fore-Aft F (g)') % right y-axis
hLine1.LineWidth = 1.5; hLine2.LineWidth = 1.5; hLine2.LineStyle = ':';

figure
[hAx,hLine1,hLine2] = plotyy(time, shoulderAngle, time,lateralF);
xlabel('Time (s)')
ylabel(hAx(1),'Shoulder Angle (deg)') % left y-axis 
ylabel(hAx(2),'Lateral F (g)') % right y-axis
hLine1.LineWidth = 1.5; hLine2.LineWidth = 1.5; hLine2.LineStyle = ':';

figure
[hAx,hLine1,hLine2] = plotyy(time, eye2D(:,2).*100, time,verticalF);
xlabel('Time (s)')
ylabel(hAx(1),'Eye Height (cm)') % left y-axis 
ylabel(hAx(2),'Vertical F (g)') % right y-axis
hLine1.LineWidth = 1.5; hLine2.LineWidth = 1.5; hLine2.LineStyle = ':';

figure
[hAx,hLine1,hLine2] = plotyy(time, eye2D(:,2).*100, time,foreaftF);
xlabel('Time (s)')
ylabel(hAx(1),'Eye Height (cm)') % left y-axis 
ylabel(hAx(2),'Fore-Aft F (g)') % right y-axis
hLine1.LineWidth = 1.5; hLine2.LineWidth = 1.5; hLine2.LineStyle = ':';

figure
[hAx,hLine1,hLine2] = plotyy(time, eye2D(:,2).*100, time,lateralF);
xlabel('Time (s)')
ylabel(hAx(1),'Eye Height (cm)') % left y-axis 
ylabel(hAx(2),'Lateral F (g)') % right y-axis
hLine1.LineWidth = 1.5; hLine2.LineWidth = 1.5; hLine2.LineStyle = ':';


