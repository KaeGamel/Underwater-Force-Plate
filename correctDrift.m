time = dataRaw{:,1};

p1 = polyfit(time, dataRaw{:,2},3);
p2 = polyfit(time, dataRaw{:,3},3);
p3 = polyfit(time, dataRaw{:,4},3);
p4 = polyfit(time, dataRaw{:,5},3);

y1 = polyval(p1,time);
y2 = polyval(p2,time);
y3 = polyval(p3,time);
y4 = polyval(p4,time);

V1 = dataRaw{:,2}-y1;
V2 = dataRaw{:,3}-y2;
F1 = dataRaw{:,4}-y3;
L1 = dataRaw{:,5}-y4;

data = [V1, V2, F1, L1];

%Try a lower cut-off freq (5?)
lowpassFilter = designfilt('lowpassfir','FilterOrder',60,'CutoffFrequency',11,'SampleRate',1000);
% data2=filter(lowpassFilter, data(:,2:5));
data2=filter(lowpassFilter, data);

% disp('zeroing data')
% zeroing= mean(data2(500:1000,:));
% zeroingData= (data2-zeroing);

% mergedData = [zeroingData(:,1)+zeroingData(:,2), zeroingData(:,3),zeroingData(:,4)];
mergedData = [data2(:,1)+data2(:,2), data2(:,3), data2(:,4)];
calData = mergedData*calMatrix;

figure
plot(calData)
legend('Vertical', 'Fore-Aft', 'Lateral')



