
function [stress, flexuralStrength, flexuralModulus,ILSStrength, strain, yieldStress, yieldIndex, ultimateStrain, youngsModulus,...
        poissonsEffective] = calculate(load, strain, displacement, strainTrans, sheetNumber,...
        sampleNumber, fileNumber, yieldStress, yieldLoad, yieldIndex, ultimateStrain,...
        ultimateDisplacement, youngsModulus,poissonsEffective, width, thickness,...
        supportSpan, loadSpan, flexuralStrength, flexuralModulus, testtype, ILSStrength)

    
    
    %% Common values for all tests
    %{
    crossSectionalArea = width * thickness;  %Calculate Cross Sectional Area
    yieldload(fileNumber) = max(load);                                                          %Ultimate Tensile load (MPa)
    yieldIndex(fileNumber) = find(load == yieldload(fileNumber), 1);                            %Index of data at which ultimate load takes place
    %ultimateDisplacement(fileNumber) = displacement(yieldIndex(fileNumber))                                    %displacement at the point of Ultimate load
     %}
    %% Calculations based on type of test
    if strcmp(testtype,'t')
        %%If test type is tensile
        
        %%Calculations
        stress = load / crossSectionalArea;                                                             %Stress (MPa)
        yieldStress(fileNumber) = max(stress);                                                          %Ultimate Tensile Stress (MPa)
        yieldIndex(fileNumber) = find(stress == yieldStress(fileNumber), 1);                            %Index of data at which ultimate stress takes place
        ultimateStrain(fileNumber) = strain(yieldIndex(fileNumber));                                    %Strain at the point of Ultimate Stress
        [~, modStartIdx] = min(abs(strain(1:yieldIndex(fileNumber))-(1e-03)));
        [~, modEndIdx] =  min(abs(strain(1:yieldIndex(fileNumber))-(3e-03)));
        bestFitLine = polyfit(strain(modStartIdx:modEndIdx), stress(modStartIdx:modEndIdx), 1);         %Generates the linear equation of best fit for the data
        youngsModulus(fileNumber) = bestFitLine(1) / 1e3;                               %Slope of the line then dividing by 1000 to transform from MPa to GPa
        poissonsEffective(fileNumber) = mean(-strainTrans(modStartIdx:modEndIdx)./strain(modStartIdx:modEndIdx));
    
    elseif strcmp(testtype,'f')
        %%If test type is Flexure
                
        %%We need displacement values between 1 - 3mm to calculate slope
        %%for modulus
        %{
        p = 1;
    
        while displacement(p) < 1
            p = p+1;
        end
    
        modStartIdx = p;
    
        p = 1;
    
        while displacement(p) < 3
            p = p+1;
        end
    
        modEndIdx = p;
    
        %[~, modStartIdx] = min(abs(displacement(1:yieldIndex(fileNumber))-(1e-03)));
        %[~, modEndIdx] =  min(abs(displacement(1:yieldIndex(fileNumber))-(3e-03)));
        bestFitLine = polyfit(displacement(modStartIdx:modEndIdx), load(modStartIdx:modEndIdx), 1);         %Generates the linear equation of best fit for the data
        %youngsModulus(fileNumber) = bestFitLine(1) / 1e3;                               %Slope of the line then dividing by 1000 to transform from MPa to GPa
        %}
        stress = (3 * supportSpan * load) / (4 * width * thickness^2);
        flexuralStrength(fileNumber) = max(stress);
        strain = 48*displacement*thickness/(11*supportSpan^2);
        %yieldStress(fileNumber) = max(stress);                                                          %Ultimate Tensile Stress (MPa)
        yieldIndex(fileNumber) = find(stress == flexuralStrength(fileNumber), 1);                            %Index of data at which ultimate stress takes place
        ultimateStrain(fileNumber) = strain(yieldIndex(fileNumber));                                    %Strain at the point of Ultimate Stress
        [~, modStartIdx] = min(abs(strain(1:yieldIndex(fileNumber))-(1e-03)));
        [~, modEndIdx] =  min(abs(strain(1:yieldIndex(fileNumber))-(3e-03)));
        bestFitLine = polyfit(strain(modStartIdx:modEndIdx), stress(modStartIdx:modEndIdx), 1);         %Generates the linear equation of best fit for the data
        flexuralModulus(fileNumber) = bestFitLine(1) / 1e3;                               %Slope of the line then dividing by 1000 to transform from MPa to GPa
        
        
        
    elseif strcmp(testtype,'i')
        %%If tyest type is ILS
        
        %%Calculations
        stress = 0.75*load/width/thickness; %Interlaminar Shear Stress (ILSS)
        ILSStrength(fileNumber) = max(stress);
        
    else
        fprintf("\nPlease Enter the correct test type and rerun\n")
        
        %%Enter command to stop entire script
        
    end %If else statements for detecting test type
    
    
    
end