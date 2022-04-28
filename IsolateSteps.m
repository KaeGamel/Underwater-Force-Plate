binDatNames = dir('*trialBinDat.csv');
mergedDatNames = dir('*mergedData.csv');

for j = 1:length(binDatNames)
    binDatTrial = csvread(binDatNames(j).name);
    mergedData = csvread(mergedDatNames(j).name);

    %% Find row value of fin on and off the plate (for plotting)
    PectFin = binDatTrial(2:end,2)-(binDatTrial(1:end-1,2));
    PectFinOff = find(PectFin == -1);
    PectFinOn = find(PectFin == 1);

    numSteps = length(PectFinOn)-1;
    steps = struct;
    names = {};
    for i = 1:numSteps
        elementName = {['cycle',num2str(i)]};
        cycleData = mergedData(PectFinOn(i)+1:PectFinOn(i+1),:);
        cycleData(:,end+1) = linspace(0,100, length(cycleData));
        cycleData(:,end+1) = binDatTrial(PectFinOn(i)+1:PectFinOn(i+1),2);
        cycleData(:,end+1) = binDatTrial(PectFinOn(i)+1:PectFinOn(i+1),3);
        steps.(elementName{1}) = cycleData;
    end

    save([binDatNames(j).name(1:end-15), 'steps.mat'], 'steps')
end