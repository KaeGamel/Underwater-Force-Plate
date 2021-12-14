% STEP 1:   Import force trace data AS A TABLE by navigating to the correct
%           folder in the "current Folder" window and double clicking on it
%           (an "import" window will pop up)
% STEP 2:   Rename the imported table to "dataRaw" by clicking on it in
%           your workspace
% STEP 3:   Import the calibration matrix AS A NUMERIC MATRIX the same way
%           NOTE: Make sure to select all 9 values in the 3x3 matrix
% STEP 4:   Rename to "calMatrix"

time = dataRaw{:,1};

% p1 = polyfit(time, dataRaw{:,2},1);
% p2 = polyfit(time, dataRaw{:,3},1);
% p3 = polyfit(time, dataRaw{:,4},1);
% p4 = polyfit(time, dataRaw{:,5},1);
% 
% y1 = polyval(p1,time);
% y2 = polyval(p2,time);
% y3 = polyval(p3,time);
% y4 = polyval(p4,time);
% 
% V1 = dataRaw{:,2}-y1;
% V2 = dataRaw{:,3}-y2;
% F1 = dataRaw{:,4}-y3;
% L1 = dataRaw{:,5}-y4;

% data = [V1, V2, F1, L1];
data = [dataRaw{:,2}, dataRaw{:,3}, dataRaw{:,4}, dataRaw{:,5}];

% Filter out electrical noise
lowpassFilter = designfilt('lowpassfir','FilterOrder',60,'CutoffFrequency',5,'SampleRate',1000);
data2=filter(lowpassFilter, data);

% Zeros data
zeroing= mean(data2(500:1000,:));
data2= (data2-zeroing);

% combines two vertical channels
mergedData = [data2(:,1)+data2(:,2), data2(:,3), data2(:,4)];

% applies calibration matrix
calData = mergedData*calMatrix;
calData = calData(75:end,:); % you can change this to include more 
                             % timepoints (ie a lower first number) based 
                             % on how noisy the start of the trial peak is

figure
plot(calData)
legend('Vertical', 'Fore-Aft', 'Lateral')

% run this if you want to clean up your workspace
% clearvars -except calData dataRaw calMatrix time



