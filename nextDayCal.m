function [calMat, row, alignedData] = nextDayCal(data, name) 

answer = questdlg('Vertical, Fore-Aft, or Lateral drop?', ...
        name, ...
        'Vertical','Fore-Aft','Lateral', 'Lateral');
    switch answer
        case 'Vertical'
            row = 1;
            titleP = 'Vertical Zeroing';
        case 'Fore-Aft'
            row = 3;
            titleP = 'Fore-Aft Zeroing';
        case 'Lateral'
            row = 4;
            titleP = 'Lateral Zeroing';
    end
    
disp('filtering data')
lowpassFilter = designfilt('lowpassfir','FilterOrder',60,'CutoffFrequency',11,'SampleRate',1000);
data2=filter(lowpassFilter, data);

x = 200:1000;
[m,n] = size(data2);
p1 = polyfit(x,data2(200:1000,1),1); corr1 = polyval(p1,1:m);
p2 = polyfit(x,data2(200:1000,2),1); corr2 = polyval(p2,1:m);
p3 = polyfit(x,data2(200:1000,3),1); corr3 = polyval(p3,1:m);
p4 = polyfit(x,data2(200:1000,4),1); corr4 = polyval(p4,1:m);

V1 = data2(:,1)-corr1';
V2 = data2(:,2)-corr2';
F1 = data2(:,3)-corr3';
L1 = data2(:,4)-corr4';

alignedData = [V1, V2, F1, L1];

%% Point Select
plot(alignedData(:,row),'k.'); title(titleP);
hold on
zoom on
pause;
zeroX = ((1:length(alignedData(:,row)))./10000)';
    [x, y] = getpts();
    [k,dist] = dsearchn([alignedData(:,row),zeroX],[y,x./10000]);
    yNew = alignedData(k,row);
plot(x,y,'y.',k,yNew,'r+'); hold off

loop = 0;
while loop == 0
    answer = questdlg('Do these points look correct?', ...
        'CalPoints', ...
        'Yes','No','No');
    switch answer
        case 'Yes'
            loop = 1;
        case 'No'
            disp('Ok, try clicking again')
            plot(alignedData(:,row),'k.'); title(titleP);
            hold on
            zoom on
            pause;
                [x, y] = getpts();
                [k,dist] = dsearchn([zeroX, alignedData(:,row)],[x./10000,y]);
                yNew = alignedData(k,row);
                plot(x,y,'y.',k,yNew,'r+'); hold off
    end
end

%% Vertical weight differences

vertNoWeightX = k(1:2:end); 
vertNoWeightSignal = alignedData(vertNoWeightX,1)+alignedData(vertNoWeightX,2);
vertWeightX = k(2:2:end);
vertWeightSignal = alignedData(vertWeightX,1)+alignedData(vertWeightX,2);
diffVert = vertNoWeightSignal - vertWeightSignal;

%% Foreaft weight difference 
ForeNoWeightX = k(1:2:end); 
ForeNoWeightSignal = alignedData(ForeNoWeightX,3);
ForeWeightX = k(2:2:end);
ForeWeightSignal = alignedData(ForeWeightX,3);
diffFore = ForeNoWeightSignal - ForeWeightSignal;

%% Lateral weight difference
LatNoWeightX = k(1:2:end); 
LatNoWeightSignal = alignedData(LatNoWeightX,4);
LatWeightX = k(2:2:end);
LatWeightSignal = alignedData(LatWeightX,4);
diffLat = LatNoWeightSignal - LatWeightSignal;


%% Calibration Matrix
calMat = [diffVert, diffFore, diffLat];

end