%% Calibration Using Signal Analyzer!!!!!!!!
%Difference of two Whole numbers!!!! NOT 454.4 buttttt 454
%Use two Data Cursors to find the time to take the difference between two
%points

% one1=input('No weight');
% one=input('Weight drop');
% two2=input('Before Second weight drop');
% two=input('Second weight drop');
% three3=input('Before Third weight drop');x
% three=input('Third weight drop');
% four4=input('Before Fourth weight drop');
% four=input('Fourth weight drop');
% five5=input('Before Fifth weight drop');
% five=input('Fifth weight drop');


%% Point Select
plot(zeroingData(:,1),'k.'); hold on
zoom on
pause;
zeroX = ((1:length(zeroingData(:,1)))./100000)';
title('Vertical Zeroing')
    [x, y] = getpts();
    [k,dist] = dsearchn([zeroX, zeroingData(:,1)],[x./100000,y]);
plot(k,y,'y.',k,y,'r+'); hold off

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
            plot(zeroingData(:,1),'k.'); hold on
            zoom on
            pause;
                [x, y] = getpts();
                [k,dist] = dsearchn([zeroX, zeroingData(:,1)],[x./100000,y]);
                plot(k,y,'y.',k,y,'r+'); hold off
    end
end

%% Vertical weight differences

vertNoWeightX = k(1:2:end); 
vertNoWeightSignal = zeroingData(vertNoWeightX,1)+zeroingData(vertNoWeightX,2);
vertWeightX = k(2:2:end);
vertWeightSignal = zeroingData(vertWeightX,1)+zeroingData(vertWeightX,2);
diffVert = vertNoWeightSignal - vertWeightSignal;

%% Foreaft weight difference 
ForeNoWeightX = k(1:2:end); 
ForeNoWeightSignal = zeroingData(ForeNoWeightX,3);
ForeWeightX = k(2:2:end);
ForeWeightSignal = zeroingData(ForeWeightX,3);
diffFore = ForeNoWeightSignal - ForeWeightSignal;

%% Lateral weight difference
LatNoWeightX = k(1:2:end); 
LatNoWeightSignal = zeroingData(LatNoWeightX,4);
LatWeightX = k(2:2:end);
LatWeightSignal = zeroingData(LatWeightX,4);
diffLat = LatNoWeightSignal - LatWeightSignal;


%% Calibration Matrix
calibration = [diffVert, diffFore, diffLat];
           