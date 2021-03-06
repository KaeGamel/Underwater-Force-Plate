 
%User Select Calibration Excel File
[ExcelCalFile,path] = uigetfile('*.*');

%Read in Data
M = readmatrix([path,'\',ExcelCalFile]);

inputVoltage = M(:,1:3);
knownWeight = M(:,4:6);

% note that backslash (A\b) solves the matrix Ax = b where A is the input
% voltage and b is the known weight in grams
calMatrix = inputVoltage\knownWeight;

%% Save in folder with origial weight drops
xlswrite([path,'\',ExcelCalFile(1:end-5),'_CalculatedMatrix.xlsx'],...
    calMatrix)

%% Save in Working Directory
% xlswrite(ExcelCalFile(1:end-5),'_CalculatedMatrix.xlsx'],...
%     calMatrix)