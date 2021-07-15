d = daq("ni");
ch = addinput(d,"Dev1",0:2,"Voltage");

ch(1).TerminalConfig = "Differential";
ch(1).Range = [-10.0 10.0];
ch(2).TerminalConfig = "Differential";
ch(2).Range = [-10.0 10.0];
ch(3).TerminalConfig = "Differential";
ch(3).Range = [-10.0 10.0];

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





%% Run Through calibrations take a time 
% one1=input('Before First weight drop');
% one=input('First weight drop');
% two2=input('Before Second weight drop');
% two=input('Second weight drop');
% three3=input('Before Third weight drop');
% three=input('Third weight drop');
% four4=input('Before Fourth weight drop');
% four0=input('Fourth weight drop');
% five5=input('Before Fifth weight drop');
% five=input('Fifth weight drop');
% 
% 
% 
% 
% 
% 
% Firstdiff= zeroingData(one1-one,:);
% Seconddiff=zeroingData(two2-two,:);
% Thirddiff=zeroingData(three3-three,:);
% Fourthdiff=zeroingData(four4-four,:);
% Fifthdiff=zeroingData(five5-five,:);
% 



% DUMMY=data;
% DataTemp=data;
% Newtons = DataTemp(:,1:3);
% %Newtons = Newtons*Calibration;
% NewtonCalibrationRAW=Newtons(end-100:end,:);
% for channel=1:3
%     NewtonCalibration(channel)=mean(NewtonCalibrationRAW(:,channel));
%     Newtons(:,channel)=Newtons(:,channel)-NewtonCalibration(channel);
% end
% for reading = 1:size(Newtons,1)
%     PYTHAG(reading,1)=sqrt((Newtons(reading,1)^2)+(Newtons(reading,2)^2));
% end
% Newtons(:,7)=PYTHAG;
% PYTHAGCalibrationRaw=Newtons(end-500:end,7);
% PYTHAGCalibration=mean(PYTHAGCalibrationRaw);
% Newtons(:,7)=Newtons(:,7)-PYTHAGCalibration;
% 
% ITERATION=5;
% lpFilt = designfilt('lowpassfir','FilterOrder',100,'CutoffFrequency',5,'SampleRate',1000);
% data=filter(lpFilt,Newtons);
% for iteration=1:ITERATION
%     data2=data;
%     data2(:,:,:)=0;
%     for column=1:size(data,2)
%         data2(:,column)=smooth(data(:,column));
%     end
%     data=data2;
% end