clc

clear all
close all

warning('off','all')
format short
%{
This script is used for calculating the modulus, strength, "effective" poisson's ratio, and displaying plots.
— Ensure the Current Folder is located where all the results '.csv' files are located.
   '.csv' files in the current directory should be named like: sampleName_sampleNumber_SysNumber.csv (ex: 12120304_1_Sys0.csv)
— Measurements.xlsx should be formatted like so...{
"SampleName", width, thickness --omit "" marks
"SampleName2", width, thickness...}
Author: David Kosakowski
Co-Author: Swapneel Kulkarni
Version: 06/05/2020
%}
sampleDirectory = dir('*.csv');                                 %Make a directory of all the '.csv' files from Current Folder's subfolders
%% User inputs
% Here is where the user must edit the script to suit their needs
%///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

%Please Enter number of plate types (C, A, T) in a single series here:
numberoftypes = 1;                                            

%%Please Enter the test that has been carried out below:
%Enter 't' for tensile
%Enter 'f' for flexure 4-point bending
%Enter 'i' for ILS 3-point bending

testtype = 'f';

manualInput = false;                                            %Manual Input of Data? (Warning: time-consuming)
plotData = true;                                                %Plot at all (will allow plotIndividualData checking)
toggleIndividualPlots = false;                                  %Toggle:
%false: Plot per sheet (ex: 12120304_1 - 12120304_7 all on the same sheet)
%Does not work with only 1 specimen
%true:  Plot each specimen individually
toggleStartAndEndpoints = false;                                 %Start from a number sample (to prevent having to repeat calculations) Wont output data. used for plotting or manual data collection
%false: Start from the first sample
%true:  Start from the specified directory's filenumber, startNumber
startNumber = 1;                                              %Number Sample to start from if startAtNumber is true
endNumber = 5;
outputToExcel = true;

%///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%% Initialization - Measurement Data and Output Variables
%Input user's preferences - manual input, start from a number sample and
%number of samples in the directory.
%Output measurement files, start and end numbers for loop and initialization of all output variables 


[measurements, startNumber, endNumber, yieldStress, yieldLoad, yieldIndex, ultimateStrain, ultimateDisplacement,...
    youngsModulus, poissonsEffective, sampleNames, previousSheetNumber,...
    flexuralStrength, flexuralModulus, ILSStrength, supportSpan, loadSpan, setColor] = initialize(sampleDirectory,...
    manualInput, toggleStartAndEndpoints,testtype);

%% loop to analyze each specimen
for fileNumber = startNumber:endNumber 
    
    %% Gather Function - gather all data before calculation
    %Input the current file number, directory, manual input preference and
    %measurment data
    %Output load vector, strain vector, width and thickness of current
    %sample and other necessary data for calculations
    
    [load, strain, displacement, strainTrans, width, thickness, sheetNumber, sampleNumber,...
        fileName] = gather(fileNumber, sampleDirectory, manualInput, measurements, testtype);
    
    %% Calculation Function - Calculation of desired parameters
    %Inputs - all values calculated in previous function
    %Outputs - required calculations for plotting and display
    [stress, flexuralStrength, flexuralModulus, ILSStrength, strain, yieldStress, yieldIndex, ultimateStrain, youngsModulus,...
        poissonsEffective] = calculate(load, strain, displacement, strainTrans, sheetNumber,...
        sampleNumber, fileNumber, yieldStress, yieldLoad, yieldIndex, ultimateStrain,...
        ultimateDisplacement, youngsModulus,poissonsEffective, width, thickness,...
        supportSpan, loadSpan, flexuralStrength, flexuralModulus, testtype, ILSStrength);
    
    %% Plotting Function - Plots the required data
    
    if fileNumber == 1
        sheetPlot = '';
    end
    %grid minor
    [sheetPlot,previousSheetNumber,sampleNames,setColor] = plotting(plotData, toggleIndividualPlots,...
        strain, stress, fileNumber, sheetNumber, sampleNumber, fileName, previousSheetNumber,...
        yieldIndex, sampleNames, sheetPlot,numberoftypes,testtype,setColor,displacement,load);
    
    
     %axis([0 max(ultimateStrain)*1.1 0 max(yieldStress)*1.1]) % for tensile
    
       
end %For each sample iteration


%% Output Function - Saves plots into folder and calculations into an excel file
%Function to save all calculated data in excel file and plots in the same
%directory
%Inputs - user preferences, plotting data, calculated data
%Outputs - None

outputs(outputToExcel, plotData, toggleIndividualPlots, sheetPlot, previousSheetNumber, ...
    sampleDirectory, yieldStress, ultimateStrain, youngsModulus, ...
    poissonsEffective, flexuralStrength, flexuralModulus, sampleNames, testtype, ILSStrength);

