

[kineDatName, kineDatPath] = uigetfile('*.*', 'Select your xyzpts file.');
kineDat = readtable([kineDatPath,kineDatName]);

kineDat = table2array(kineDat);
kineDat = [kineDat, binTime];
kineDatTrial = kineDat(binDat(:,5)==1,:);
time = kineDatTrial(:,end);

% Z = horizontal
% Y = vertical
% X = medial=lateral
% ZY = fish running across frame
% XY = firh running towards camera
% XZ = "ventral view"

pectFinPlanted = kineDatTrial(binDatTrial(:,2) == 1,:);

%find where pectoral fin is on the ground and set to zero
pectFinTip2D = [kineDatTrial(:,6), kineDatTrial(:,5)];
pectFinPlanted2D = [pectFinPlanted(:,6),pectFinPlanted(:,5)];
p = polyfit(pectFinPlanted2D(:,1),pectFinPlanted2D(:,2),1);
y = polyval(p, pectFinTip2D(:,1));

%shift everything to "ground = zero" in the vertical axis
eye2D = [kineDatTrial(:,3), kineDatTrial(:,2)-y];
pectFinTip2D = [kineDatTrial(:,6), kineDatTrial(:,5)-y];
tail2D = [kineDatTrial(:,9), kineDatTrial(:,8)-y];
shoulder2D = [kineDatTrial(:,12), kineDatTrial(:,11)-y];

trialTime = time(end)-time(1);
distance = pdist2([eye2D(1,1),eye2D(1,2)],[eye2D(end,1),eye2D(end,2)],'euclidean');
speed = distance/trialTime;

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

for i = 1:m
    [angle,angleDeg] = abc_angle(eye2D(i,:), shoulder2D(i,:), pectFinTip2D(i,:),[0,1,0]);
    shoulderAngle = [shoulderAngle;angleDeg];
end

[k,pectP] = findpeaks(pectFinTip2D(:,2),'MinPeakProminence',0.002);
pectPeakX = pectFinTip2D(pectP,1); pectPeakY = pectFinTip2D(pectP,2);
%     figure
%     plot(pectFinTip2D(:,1),pectFinTip2D(:,2))
%     axis equal
%     hold on
%     plot(pectPeakX, pectPeakY, 'ro')


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

timeStep = time(2)-time(1);
allFinPlants = sort([PectFinOn; PectFinOff]);
strokeDur = []; propulsive = []; recovery = [];
for j = 1:2:length(allFinPlants)-2
    cycle = allFinPlants(j:j+2);
    strokeDur = [strokeDur; timeStep*(cycle(end)-cycle(1))];
    propulsive = [propulsive; timeStep*(cycle(2)-cycle(1))];
    recovery = [recovery; timeStep*(cycle(end)-cycle(2))];
end
    

%%
[m2,~] = size(reZeroedForceDat);
verticalF = resample(reZeroedForceDat(:,1),m,m2);
foreaftF = resample(reZeroedForceDat(:,2),m,m2);
lateralF = resample(reZeroedForceDat(:,3),m,m2);

%%
mergedDat = [kineDatTrial, shoulderAngle, verticalF, foreaftF, lateralF];

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


