
%User Select Calibration Excel File
[ExcelCalFile,path] = uigetfile('*.*');

%Read in Data
M = readmatrix([path,'\',ExcelCalFile]);

inputVoltage = M(:,1:3);
knownWeight = M(:,4:6);

calMatrix = inputVoltage\knownWeight;

xlswrite([path,'\',ExcelCalFile,'_CalculatedMatrix.xlsx'],...
    calMatrix)