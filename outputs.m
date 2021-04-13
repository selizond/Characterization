function [] = outputs(outputToExcel, plotData, toggleIndividualPlots,...
    sheetPlot, previousSheetNumber, sampleDirectory, yieldStress, ...
    ultimateStrain, youngsModulus,poissonsEffective, flexuralStrength, flexuralModulus, sampleNames, testtype, ILSStrength)
    

    if plotData && ~toggleIndividualPlots
       saveas(sheetPlot,['plots\' previousSheetNumber '.tif']); 
    end
%}
    fprintf('Finished...\n')
    %% Output to Table and Excel
    
    if strcmp(testtype,'t')
        %%If test type is tensile
        outputTable = array2table([(1:length(sampleDirectory))', yieldStress, ultimateStrain, youngsModulus,poissonsEffective], 'RowNames', cellstr(sampleNames'));
        outputTable.Properties.VariableNames = {'Sample', 'UltimateStress', 'MaxStrain', 'TensileModulus', 'PoissonsEffective'};
        outputTable.Properties.VariableUnits = {'#', 'MPa', ' ', 'GPa',' '};
        if outputToExcel
            summary(outputTable)
            xlswrite('Output.xlsx', table2array(outputTable), 'Sheet1', 'B2');
            xlswrite('Output.xlsx', sampleNames', 'Sheet1', 'A2');
            xlswrite('Output.xlsx', outputTable.Properties.VariableNames, 'Sheet1', 'B1');
        end
        
    elseif strcmp(testtype,'f')
        %%If test type is flexure
        outputTable = array2table([(1:length(sampleDirectory))', flexuralStrength,flexuralModulus, ultimateStrain], 'RowNames', cellstr(sampleNames'));
        outputTable.Properties.VariableNames = {'Sample', 'Flexural Strength (MPa)','Flexural Modulus (GPa)','Max Strain'};
        outputTable.Properties.VariableUnits = {'#', 'MPa','MPa',' '};
        if outputToExcel
            summary(outputTable)
            xlswrite('Output.xlsx', table2array(outputTable), 'Sheet1', 'B2');
            xlswrite('Output.xlsx', sampleNames', 'Sheet1', 'A2');
            xlswrite('Output.xlsx', outputTable.Properties.VariableNames, 'Sheet1', 'B1');
        end
        
    elseif strcmp(testtype,'i')
        %%If test type is ILS
        outputTable = array2table([(1:length(sampleDirectory))', ILSStrength], 'RowNames', cellstr(sampleNames'));
        outputTable.Properties.VariableNames = {'Sample', 'ILSS'};
        outputTable.Properties.VariableUnits = {'#', 'MPa'};
        if outputToExcel
            summary(outputTable)
            xlswrite('Output.xlsx', table2array(outputTable), 'Sheet1', 'B2');
            xlswrite('Output.xlsx', sampleNames', 'Sheet1', 'A2');
            xlswrite('Output.xlsx', outputTable.Properties.VariableNames, 'Sheet1', 'B1');
        end

        %%Enter ILS output
        
    else
        fprintf("\nPlease enter correct test type and rerun\n")
    end
    
        

end
