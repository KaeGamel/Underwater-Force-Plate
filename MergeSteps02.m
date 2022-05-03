trials = dir('*.mat');
fish = trials(1).name(1:end-24);

VerticalF = [];
ForeAftF = [];
LateralF = [];
PelvOnS = [];
PelvOffS = [];
PectOnS = [];
PectOffS = [];
Angle = [];
EyeHeightX = [];
EyeHeightY = [];

for i = 1:length(trials)
    trial = load(trials(i).name);
    trial = trial.steps;
    cycles = fieldnames(trial);
    
    for j = 1:length(cycles)
        cycle = trial.(cycles{j});
%         time = cycle(:,13);
        perc = cycle(:,20);
        Vert = cycle(:,17);
        Fore = cycle(:,18);
        Late = cycle(:,19);
        
        [samples,~] = size(Late);
        
%         timeRes = resample(time, 100, samples);
%         percRes = resample(perc, 100, samples);
        VertRes = resample(Vert, 100, samples);
        ForeRes = resample(Fore, 100, samples);
        LateRes = resample(Late, 100, samples);
        AngRes = resample(cycle(:,14),100, samples);
        EHxRes = resample(cycle(:,15), 100, samples);
        EHyRes = resample(cycle(:,16), 100, samples);
        
        VerticalF = [VerticalF, VertRes];
        ForeAftF = [ForeAftF, ForeRes];
        LateralF = [LateralF, LateRes];
        Angle = [Angle, AngRes];
        EyeHeightX = [EyeHeightX, EHxRes];
        EyeHeightY = [EyeHeightY, EHyRes];
        
        PectFin = cycle(2:end,21)-(cycle(1:end-1,21));
            PectFinOff = find(PectFin == -1);
            PectFinOn = 1;

        PelvFin = cycle(2:end,22)-(cycle(1:end-1,22));
            PelvFinOff = find(PelvFin == -1);
            PelvFinOn = find(PelvFin == 1);
            
        PectOnS = [PectOnS; perc(PectFinOn)];
        PectOffS = [PectOffS; perc(PectFinOff+1)];
        PelvOnS = [PelvOnS; perc(PelvFinOn-1)];
        PelvOffS = [PelvOffS; perc(PelvFinOff+1)];
    end
    
end
Perc = linspace(0,100,100);

PectOnMedian = median(PectOnS);
PectOffMedian = median(PectOffS);
PelvOnMedian = median(PelvOnS);
PelvOffMedian = median(PelvOffS);

Vert_mean_2 = mean(VerticalF,2);
Fore_mean_2 = mean(ForeAftF,2);
Late_mean_2 = mean(LateralF,2);
Angle_mean = mean(Angle, 2);
EHX_mean = mean(EyeHeightX, 2);
EHY_mean = mean(EyeHeightY, 2);

%% Vertical
figure
subplot(4,1,3)
hold on
rectangle('Position',[PectOnMedian, 0.925, PectOnMedian+PectOffMedian, 0.15],'FaceColor',[0 .5 .5])
boxplot(PectOffS, 'orientation','horizontal')
xlim([0,100])
boxplot(PectOnS, 'orientation','horizontal')
ylabel('Pect Fin')

subplot(4,1,4)
hold on
rectangle('Position',[0, 0.925, PelvOffMedian, 0.15],'FaceColor',[0 .5 .5])
rectangle('Position',[PelvOnMedian, 0.925, 100, 0.15],'FaceColor',[0 .5 .5])
boxplot(PelvOffS, 'orientation','horizontal')
xlim([0,100])
boxplot(PelvOnS, 'orientation','horizontal')
ylabel('Pelv Fin')

subplot(4,1,[1,2])
hold on
plot(Perc, VerticalF)
plot(Perc, Vert_mean_2, 'LineWidth', 2, 'Color','k')
ylabel('Vertical Force (g)')
xlabel('Step Cycle %')
title(fish)
yyaxis right
plot(Perc, EHY_mean,  'LineWidth', 2, 'Color','b', 'LineStyle','--')
ylabel('Shoulder Angle (deg)')



%% Fore Aft
figure
subplot(4,1,3)
hold on
rectangle('Position',[PectOnMedian, 0.925, PectOnMedian+PectOffMedian, 0.15],'FaceColor',[0 .5 .5])
boxplot(PectOffS, 'orientation','horizontal')
xlim([0,100])
boxplot(PectOnS, 'orientation','horizontal')
ylabel('Pect Fin')

subplot(4,1,4)
hold on
rectangle('Position',[0, 0.925, PelvOffMedian, 0.15],'FaceColor',[0 .5 .5])
rectangle('Position',[PelvOnMedian, 0.925, 100, 0.15],'FaceColor',[0 .5 .5])
boxplot(PelvOffS, 'orientation','horizontal')
xlim([0,100])
boxplot(PelvOnS, 'orientation','horizontal')
ylabel('Pelv Fin')

subplot(4,1,[1,2])
hold on
plot(Perc, ForeAftF)
plot(Perc, Fore_mean_2, 'LineWidth', 2, 'Color','k')
title(fish)
xlabel('Step Cycle %')
ylabel('Fore-Aft Force (g)')
yyaxis right
plot(Perc, Angle_mean,  'LineWidth', 2, 'Color','b', 'LineStyle','--')
ylabel('Shoulder Angle (deg)')

%% Lateral
figure
subplot(4,1,3)
hold on
rectangle('Position',[PectOnMedian, 0.925, PectOnMedian+PectOffMedian, 0.15],'FaceColor',[0 .5 .5])
boxplot(PectOffS, 'orientation','horizontal')
xlim([0,100])
boxplot(PectOnS, 'orientation','horizontal')
ylabel('Pect Fin')

subplot(4,1,4)
hold on
rectangle('Position',[0, 0.925, PelvOffMedian, 0.15],'FaceColor',[0 .5 .5])
rectangle('Position',[PelvOnMedian, 0.925, 100, 0.15],'FaceColor',[0 .5 .5])
boxplot(PelvOffS, 'orientation','horizontal')
xlim([0,100])
boxplot(PelvOnS, 'orientation','horizontal')
ylabel('Pelv Fin')

subplot(4,1,[1,2])
hold on
plot(Perc, LateralF)
plot(Perc, Late_mean_2, 'LineWidth', 2, 'Color','k')
title(fish)
xlabel('Step Cycle %')
ylabel('Lateral Force (g)')
yyaxis right
plot(Perc, Angle_mean,  'LineWidth', 2, 'Color','b', 'LineStyle','--')
ylabel('Shoulder Angle (deg)')