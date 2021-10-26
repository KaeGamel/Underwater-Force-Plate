%% FORCE PLATE 2021 

FPmatrix = [11.00972234, -0.15282199; %% FP matrices [Vert, vert/hor
              -0.45381547, 13.71403446]; %%           vert/ Hor, Hor]

  
[filename,pathnameFPdata]= uigetfile('*.csv');
cd(pathnameFPdata);%changes the working directory so it's not pulling from matlab scripts
rawforcedata=csvread(filename,1,0); 

figure
FPdata=rawforcedata(:,1:2);
caldata= FPdata * FPmatrix;
calmN= caldata* 9.8; %% goes from grams to mN
[calmN]=[calmN(:,1), -calmN(:,2)]; %% flipped to make intuitive sense
plot(calmN);