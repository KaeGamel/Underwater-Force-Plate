d = daq("ni");
ch = addinput(d,"Dev2",0:3,"Voltage");

ch(1).TerminalConfig = "Differential";
ch(1).Range = [-10.0 10.0];
ch(2).TerminalConfig = "Differential";
ch(2).Range = [-10.0 10.0];
ch(3).TerminalConfig = "Differential";
ch(3).Range = [-10.0 10.0];
ch(4).TerminalConfig = "Differential";
ch(4).Range = [-10.0 10.0];

d.Rate = 1000;

disp('reading data now')

%%%%% Change based on trial length %%%%%
data = read(d,seconds(20));
%%%%%

disp('data read complete')
plot(data.Time, data.Variables);
legend('Vertical 1','Vertical 2', 'Fore-Aft', 'Lateral')


%% Filter data
disp('filtering data')
lowpassFilter = designfilt('lowpassfir','FilterOrder',60,'CutoffFrequency',11,'SampleRate',1000);
data2=filter(lowpassFilter, data.Variables);
%stackedplot(data.Time, data2);

%% Zeroing Data
disp('zeroing data')
zeroing= mean(data2(500:1000,:));
zeroingData= (data2-zeroing);

%% Zeroing with drift correction?
% Polyfit with raw data so the majority of the points are around zero
dataRaw = data.Variables; time = seconds(data.Time);
p1 = polyfit(time, dataRaw(:,1),1);
p2 = polyfit(time, dataRaw(:,2),1);
p3 = polyfit(time, dataRaw(:,3),1);
p4 = polyfit(time, dataRaw(:,4),1);

y1 = polyval(p1,time);
y2 = polyval(p2,time);
y3 = polyval(p3,time);
y4 = polyval(p4,time);

V1 = dataRaw(:,1)-y1;
V2 = dataRaw(:,2)-y2;
F1 = dataRaw(:,3)-y3;
L1 = dataRaw(:,4)-y4;

correctedDrift = [V1, V2, F1, L1];
filteredCorrectedDrift=filter(lowpassFilter, correctedDrift);
zeroing2= mean(filteredCorrectedDrift(500:1000,:));
alignedData= (filteredCorrectedDrift-zeroing2);

%% How does it all look?
figure
plot(data.Time(60:end), zeroingData(60:end,:));
legend('Vertical 1', 'Vertical 2', 'Fore-aft','Lateral');

figure
plot(data.Time(60:end), alignedData(60:end,:));
legend('Vertical 1', 'Vertical 2', 'Fore-aft','Lateral');

%% Save Everything
saveName = input('Save Name: ','s');
writematrix(zeroingData, [saveName,'_dat.csv'])
writematrix(alignedData, [saveName,'_alg.csv'])
writetimetable(data, [saveName,'_raw.csv'])
