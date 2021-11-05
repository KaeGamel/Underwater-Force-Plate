
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

answer = questdlg('Vertical, Fore-Aft, or Lateral drop?', ...
        'Drop Direction', ...
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

%% Point Select
plot(zeroingData(:,row),'k.'); title(titleP);
hold on
zoom on
pause;
zeroX = ((1:length(zeroingData(:,row)))./10000)';
    [x, y] = getpts();
    [k,dist] = dsearchn([zeroingData(:,row),zeroX],[y,x./10000]);
    yNew = zeroingData(k,row);
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
            plot(zeroingData(:,row),'k.'); title(titleP);
            hold on
            zoom on
            pause;
                [x, y] = getpts();
                [k,dist] = dsearchn([zeroX, zeroingData(:,row)],[x./10000,y]);
                yNew = zeroingData(k,row);
                plot(x,y,'y.',k,yNew,'r+'); hold off
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

saveName = input('Save Name: ','s');
writematrix(calibration,[saveName,'_mat.csv'])
writematrix(zeroingData, [saveName,'_dat.csv'])
writematrix(alignedData, [saveName,'_alg.csv'])
writetimetable(data, [saveName,'_raw.csv'])
           