
disp('correcting drift')
p1 = polyfit(dataRaw(:,1), dataRaw(:,2),1);
p2 = polyfit(dataRaw(:,1), dataRaw(:,3),1);
p3 = polyfit(dataRaw(:,1), dataRaw(:,4),1);
p4 = polyfit(dataRaw(:,1), dataRaw(:,5),1);

y1 = polyval(p1,dataRaw(:,1));
y2 = polyval(p2,dataRaw(:,1));
y3 = polyval(p3,dataRaw(:,1));
y4 = polyval(p4,dataRaw(:,1));

V1 = dataRaw(:,2)-y1;
V2 = dataRaw(:,3)-y2;
F1 = dataRaw(:,4)-y3;
L1 = dataRaw(:,5)-y4;

data = [V1, V2, F1, L1];

disp('filtering data')
lowpassFilter = designfilt('lowpassfir','FilterOrder',60,'CutoffFrequency',11,'SampleRate',1000);
% data2=filter(lowpassFilter, data(:,2:5));
data2=filter(lowpassFilter, data);

disp('zeroing data')
zeroing= mean(data2(500:1000,:));
zeroingData= (data2-zeroing);

mergedData = [zeroingData(:,1)+zeroingData(:,2), zeroingData(:,3),zeroingData(:,4)];
calData = mergedData*calMatrix;
calData = calData(75:end,:);

figure
plot(calData)
legend('Vertical', 'Fore-Aft', 'Lateral')


% rollSpectrum1 = fftshift(fft(calData(:,1)));
% rollSpectrum2 = fftshift(fft(calData(:,2)));
% rollSpectrum3 = fftshift(fft(calData(:,3)));
% 
% [pks1,locs1] = findpeaks(abs(rollSpectrum1),'MinPeakProminence',10000);
% [pks2,locs2] = findpeaks(abs(rollSpectrum2),'MinPeakProminence',10000);
% [pks3,locs3] = findpeaks(abs(rollSpectrum3),'MinPeakProminence',10000);
% 
% test = lowpass(calData(:,1), 1, 1000);

