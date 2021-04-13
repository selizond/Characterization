function [sheetPlot,previousSheetNumber,sampleNames,setColor] = plotting(plotData, toggleIndividualPlots,...
        strain, stress, fileNumber, sheetNumber, sampleNumber, fileName, previousSheetNumber,...
        yieldIndex, sampleNames, sheetPlot,numberoftypes,testtype,setColor,displacement,load)

 if fileNumber == 1
     mkdir('plots');
 end

 if numberoftypes == 1
     if plotData
        if toggleIndividualPlots                                                                    %Plot each sample on a different plot
            f = figure('visible', 'off');
            hold off;
            
            %%Plotting based on test type (ILS requires Load-Disp.)
            if strcmp(testtype,'i')
                samplePlot = plot(displacement(1:yieldIndex(fileNumber)), load(1:yieldIndex(fileNumber)), 'Color', [rand rand rand]);
                legend([sheetNumber, '-', sampleNumber])
                xlabel('Displacement (mm)');
                ylabel('Load (N)');
                title(strcat("Load Displacement Curve ", replace(fileName(1:(strfind(fileName, '.') - 1)), '_', '-')  ));
                grid on; grid minor;
            else
                samplePlot = plot(strain(1:yieldIndex(fileNumber)), stress(1:yieldIndex(fileNumber)), 'Color', [rand rand rand]);
                legend([sheetNumber, '-', sampleNumber])
                xlabel('Strain');
                ylabel('Stress(MPa)');
                title(strcat("Stress Strain Curve ", replace(fileName(1:(strfind(fileName, '.') - 1)), '_', '-')  ));
                grid on;
            end
            
            saveas(samplePlot,['plots\' fileName(1:strfind(fileName, '.') - 1) '.tif']);
        else                                                                                        %Plot each specimen from the same sheet on the same plot
            if strcmp(sheetNumber, previousSheetNumber)
                
                %%ILS requires Load-Disp. plot
                if strcmp(testtype,'i')
                    sheetPlot = plot(displacement(1:yieldIndex(fileNumber)), load(1:yieldIndex(fileNumber)), 'DisplayName', "Sample " + extractBefore(sampleNumber, "-"));
                else                    
                    sheetPlot = plot(strain(1:yieldIndex(fileNumber)), stress(1:yieldIndex(fileNumber)), 'DisplayName', sampleNumber);
                end
                    
                if (mod(fileNumber, 2) == 1)
                    %text(strain(yieldIndex(fileNumber)), stress(yieldIndex(fileNumber)), sampleNumber(1:strfind(sampleNumber, '-') - 1), 'Fontsize', 10);
                end
            else
                
                fprintf("file Number is: \n")
                fileNumber
                if fileNumber > 1
                    saveas(sheetPlot,['plots\' previousSheetNumber '.tif']);
                end
                %}                
                previousSheetNumber = sheetNumber;
                f = figure('visible', 'on');
                
                if strcmp(testtype,'i')
                    legend('Location', 'southeast');
                    title(strcat("Load Displacement Curve—", sheetNumber));
                    xlabel('Displacement (mm)'); ylabel('Load (N)');
                    grid on; grid minor; hold on;
                    sheetPlot = plot(displacement(1:yieldIndex(fileNumber)), load(1:yieldIndex(fileNumber)), 'DisplayName', "Sample " + extractBefore(sampleNumber, "-"));
                else
                    legend('Location', 'southeast');
                    title(strcat("Stress Strain Curve—", sheetNumber));
                    xlabel('Strain'); ylabel('Stress (MPa)');
                    grid on; hold on;
                    sheetPlot = plot(strain(1:yieldIndex(fileNumber)), stress(1:yieldIndex(fileNumber)), 'DisplayName', sampleNumber);
                end
                %ylim([0 inf])
                %xlim([0 inf])
                
                
                grid minor
            
                if (mod(fileNumber, 2) == 1)
                    %text(strain(yieldIndex(fileNumber)), stress(yieldIndex(fileNumber)), sampleNumber(1:strfind(sampleNumber, '-') - 1), 'Fontsize', 10);
                end
            end %If plotting first specimen of new sheet
        end %If plotting individual plots Else plotting held plots per sheet
    end %End plotting
    sampleNames(fileNumber) = fileName(1:strfind(fileName, '.') - 1);
 else
     if strcmp(testtype,'t')
         %%If test type is Tensile
         
         if plotData
            if toggleIndividualPlots                                                                    %Plot each sample on a different plot
                f = figure('visible', 'off');
                hold off;
                samplePlot = plot(strain(1:yieldIndex(fileNumber)), stress(1:yieldIndex(fileNumber)), 'Color', [rand rand rand]);
                legend([sheetNumber, '-', sampleNumber])
                xlabel('Strain');
                ylabel('Stress(MPa)');
                title(strcat("Stress Strain Curve ", replace(fileName(1:(strfind(fileName, '.') - 1)), '_', '-')  ));
                grid on;
                saveas(samplePlot,['plots\' fileName(1:strfind(fileName, '.') - 1) '.tif']);
            else                                                                                        %Plot each specimen from the same sheet on the same plot
                if strcmp(sheetNumber, previousSheetNumber)
                    fprintf('FIRST IF \n\n')

                    sheetPlot = plot(strain(1:yieldIndex(fileNumber)), stress(1:yieldIndex(fileNumber)), 'DisplayName', sheetNumber + " Sample " + extractBefore(sampleNumber, "-"),'Color',setColor,'LineWidth',2);
                    xlim([0,0.03])
                    ylim([0,300])
                    grid minor
                else
                    set(0,'DefaultAxesColorOrder',[  0 39/255 255/255;  94/255 119/255 255/255; 22/255 35/255 107/255])%[0 0 1;0 1 0; 1 0 0])
                    if fileNumber > 1
                        saveas(sheetPlot,['plots\' previousSheetNumber 'Stress_strain.tif']);
                    end
                    previousSheetNumber = sheetNumber;
                    %f = figure('visible', 'on');
                    legend('Location', 'southeastoutside');

                    %%Load-Disp. curve for ILS, Stress-Strain curve for
                    %%Flexure

                    title(strcat("Stress Strain Curve — ", sheetNumber(1:2)," Series"));
                    xlabel('Strain (mm/mm)'); ylabel('Stress (MPa)');
                    %grid on; 
                    hold on;
                    fprintf('SECOND IF \n\n')
                    sheetPlot = plot(strain(1:yieldIndex(fileNumber)), stress(1:yieldIndex(fileNumber)), 'DisplayName', sheetNumber + " Sample " + extractBefore(sampleNumber, "-"),'LineWidth',2);
%                     xlim([0,0.05])
%                     ylim([0,550]) 


                    xlim([0,0.03])
                    ylim([0,500]) 
                        
                    setColor = get(sheetPlot,'Color');
                    grid on
                    grid minor
%                 %if strcmp(sheetNumber, previousSheetNumber)
%                     legend('Location', 'southeastoutside');
%                     title(strcat("Stress Strain Curve — ", sheetNumber(1:2)," Series"));
%                     xlabel('Strain'); ylabel('Stress(MPa)');
%                     sheetPlot = plot(strain(1:yieldIndex(fileNumber)), stress(1:yieldIndex(fileNumber)), 'DisplayName', sheetNumber);
%                     hold on
%                     if (mod(fileNumber, 2) == 1)
%                         text(strain(yieldIndex(fileNumber)), stress(yieldIndex(fileNumber)), sampleNumber(1:strfind(sampleNumber, '-') - 1), 'Fontsize', 10);
%                     end
%                 %else
% 
%                 %    if fileNumber > 1
%                 %        saveas(sheetPlot,['plots\' previousSheetNumber '.tif']);
%                 %    end
%                     previousSheetNumber = sheetNumber;
%                 %    f = figure('visible', 'on');
%                 %    legend('Location', 'southeastoutside');
%                 %    title(strcat("Stress Strain Curve—", sheetNumber));
%                 %    xlabel('Strain'); ylabel('Stress(MPa)');
%                 %    grid on; hold on;
%                 %    sheetPlot = plot(strain(1:yieldIndex(fileNumber)), stress(1:yieldIndex(fileNumber)), 'DisplayName', sampleNumber);
%                 %    if (mod(fileNumber, 2) == 1)
%                 %        text(strain(yieldIndex(fileNumber)), stress(yieldIndex(fileNumber)), sampleNumber(1:strfind(sampleNumber, '-') - 1), 'Fontsize', 10);
%                 %    end
                end %If plotting first specimen of new sheet
            end %If plotting individual plots Else plotting held plots per sheet
        end %End plotting
     
     elseif strcmp(testtype,'f')
         %%If test type is Flexure
         
             if plotData
                if toggleIndividualPlots                                                                    %Plot each sample on a different plot
                    f = figure('visible', 'off');
                    hold on;
                    
                    samplePlot = plot(strain(1:yieldIndex(fileNumber)), stress(1:yieldIndex(fileNumber)), 'Color', [rand rand rand]);
                    legend([sheetNumber, '-', sampleNumber])
                    xlabel('Strain (mm/mm)');
                    ylabel('Stress (MPa)');
                    title(strcat("Stress Strain Curve — ", sheetNumber(1:2)," Series"));
                    grid on;
                    
                    
                    saveas(samplePlot,['plots\' fileName(1:strfind(fileName, '.') - 1) 'Stress_strain.tif']);
                else                                                                                        %Plot each specimen from the same sheet on the same plot
                    if strcmp(sheetNumber, previousSheetNumber)
                        fprintf('FIRST IF \n\n')
                                     
                        sheetPlot = plot(strain(1:yieldIndex(fileNumber)), stress(1:yieldIndex(fileNumber)), 'DisplayName', sheetNumber + " Sample " + extractBefore(sampleNumber, "-"),'Color',setColor);
                        
                        
                    else
                        set(0,'DefaultAxesColorOrder',[ .7 .25 .25; 1 .5 .5; .4 0 0])
                        if fileNumber > 1
                            saveas(sheetPlot,['plots\' previousSheetNumber 'Stress_strain.tif']);
                        end
                        previousSheetNumber = sheetNumber;
                        %f = figure('visible', 'on');
                        legend('Location', 'southeastoutside');
                        
                        %%Load-Disp. curve for ILS, Stress-Strain curve for
                        %%Flexure
                                       
                        title(strcat("Stress Strain Curve — ", sheetNumber(1:2)," Series"));
                        xlabel('Strain (mm/mm)'); ylabel('Stress (MPa)');
                        grid on; hold on;
                        fprintf('SECOND IF \n\n')
                        sheetPlot = plot(strain(1:yieldIndex(fileNumber)), stress(1:yieldIndex(fileNumber)), 'DisplayName', sheetNumber + " Sample " + extractBefore(sampleNumber, "-"));
                        xlim([0,0.05])
                        ylim([0,550]) 
                        
                        
                        setColor = get(sheetPlot,'Color');
                        
                        grid minor
                    end % %If plotting first specimen of new sheet
                end %If plotting individual plots Else plotting held plots per sheet
            end %End plotting
         
     elseif strcmp(testtype,'i')
         %%If test type is ILS
         if strcmp(sheetNumber(length(sheetNumber)), 'C')
            Color = 'blue';
         else if strcmp(sheetNumber(length(sheetNumber)), 'A')
                Color = 'red';
             else if strcmp(sheetNumber(length(sheetNumber)), 'T')
                    Color = 'green';

                end
            end
        end

        if plotData
            if toggleIndividualPlots                                                                    %Plot each sample on a different plot
                f = figure('visible', 'off');
                hold on;

                samplePlot = plot(displacement(1:yieldIndex(fileNumber)), load(1:yieldIndex(fileNumber)), Color);
                %legend([sheetNumber, '-', sampleNumber])
                xlabel('Displacement (mm)');
                ylabel('Load (N)');
                title(strcat("Load Displacement Curve — ", sheetNumber(1:2)," Series"));
                grid on; grid minor;
                saveas(samplePlot,['plots\' fileName(1:strfind(fileName, '.') - 1) '.tif']);
            else                                                                                        %Plot each specimen from the same sheet on the same plot
                if strcmp(sheetNumber, previousSheetNumber)
                    fprintf('FIRST IF \n\n')
                    sheetPlot = plot(displacement(1:yieldIndex(fileNumber)), load(1:yieldIndex(fileNumber)), Color, 'DisplayName', sheetNumber + " Sample " + extractBefore(sampleNumber, "-"));
                    grid on; grid minor;
                    %{
                       if (mod(fileNumber, 2) == 1)
                        text(displacement(yieldIndex(fileNumber)), load(yieldIndex(fileNumber)), extractBefore(sampleNumber, "-"), 'Fontsize', 10);
                    end
                    %}
                else
                    if fileNumber > 1
                        saveas(sheetPlot,['plots\' previousSheetNumber '.tif']);
                    end
                    previousSheetNumber = sheetNumber;
                    %f = figure('visible', 'on');
                    legend('Location', 'southeastoutside');
                    title(strcat("Load Displacement Curve — ", sheetNumber(1:2)," Series"));
                    xlabel('Displacement (mm)'); ylabel('Load (N)');
                    grid on; grid minor; hold on;
                    fprintf('SECOND IF \n\n')
                    sheetPlot = plot(displacement(1:yieldIndex(fileNumber)), load(1:yieldIndex(fileNumber)), Color, 'DisplayName', sheetNumber + " Sample " + extractBefore(sampleNumber, "-"));
                    %{
                        if (mod(fileNumber, 2) == 1)
                        text(displacement(yieldIndex(fileNumber)), load(yieldIndex(fileNumber)), extractBefore(sampleNumber, "-"), 'Fontsize', 10);
                    end
                    %}
                end % %If plotting first specimen of new sheet
            end %If plotting individual plots Else plotting held plots per sheet
        end %End plotting
         %%ILS PLOTTING
     else
         fprintf("\nPlease enter correct test type and rerun\n")
     end
     
         
     sampleNames(fileNumber) = fileName(1:strfind(fileName, '.') - 1);
    
 end
    
end