function [measurements, startNumber, endNumber] = measure(sampleDirectory, manualInput, toggleStartAndEndpoints)

if ~manualInput
    measurements = readtable('Measurements.xlsx','ReadVariableNames',false); %now brings in sample names also, no headings
end

if ~toggleStartAndEndpoints
    startNumber = 1;
    endNumber = length(sampleDirectory);
end

end