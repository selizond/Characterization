function [measurements, startNumber, endNumber, yieldStress, yieldLoad, yieldIndex, ultimateStrain, ultimateDisplacement,...
    youngsModulus, poissonsEffective, sampleNames, previousSheetNumber,...
    flexuralStrength, flexuralModulus, ILSStrength, supportSpan, loadSpan, setColor] = initialize(sampleDirectory,...
    manualInput, toggleStartAndEndpoints,testtype)

%%Measurements
if ~manualInput
    measurements = readtable('Measurements.xlsx','ReadVariableNames',false); %now brings in sample names also, no headings
end
if ~toggleStartAndEndpoints
    startNumber = 1;
    endNumber = length(sampleDirectory);
end
%% Initialize Output Variables
numberOfSamples = length(sampleDirectory);                      %The number of samples in the directory
fprintf('Files Found: %d\n', numberOfSamples);
if numberOfSamples == 0
    fprintf('Please relocate to a directory containing sample data\n');
    pause
end                                                             %Catch possible incorrect directory
yieldStress = zeros(numberOfSamples, 1);
yieldLoad = zeros(numberOfSamples, 1);
yieldIndex = zeros(numberOfSamples, 1);
ultimateStrain = zeros(numberOfSamples, 1);
ultimateDisplacement = zeros(numberOfSamples, 1);
youngsModulus = zeros(numberOfSamples, 1);
poissonsEffective = zeros(numberOfSamples, 1);
flexuralStrength = zeros(numberOfSamples, 1);
flexuralModulus = zeros(numberOfSamples, 1);
ILSStrength = zeros(numberOfSamples, 1);
sampleNames = string([]);
mkdir('plots');
previousSheetNumber = '';

%%For ILS & Flexure
supportSpan = 96;
loadSpan = 48;
setColor = [0 0 0];

end