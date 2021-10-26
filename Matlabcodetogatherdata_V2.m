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
data = read(d,seconds(20));
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

figure
plot(data.Time(60:end), zeroingData(60:end,:));
legend('Vertical 1', 'Vertical 2', 'Fore-aft','Lateral');
