d = daq("ni");
ch = addinput(d,"Dev1",0:2,"Voltage");

ch(1).TerminalConfig = "Differential";
ch(1).Range = [-10.0 10.0];
ch(2).TerminalConfig = "Differential";
ch(2).Range = [-10.0 10.0];
ch(3).TerminalConfig = "Differential";
ch(3).Range = [-10.0 10.0];
ch(4).TerminalConfig = "Differential";
ch(4).Range = [-10.0 10.0];

d.Rate = 1000;

data = read(d,seconds(10));
plot(data.Time, data.Variables);

%% Filter data
lowpassFilter = designfilt('lowpassfir','FilterOrder',60,'CutoffFrequency',11,'SampleRate',1000);
data2=filter(lowpassFilter, data.Variables);
%stackedplot(data.Time, data2);

%% Zeroing Data

zeroing= mean(data2(500:1000,:));
zeroingData= (data2-zeroing);

figure
plot(data.Time, zeroingData);
ylim([-9 9]);
legend('Vertical','Foraft','Medial-lateral');
