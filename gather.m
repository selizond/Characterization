function [load, strain, displacement, strainTrans, width, thickness, sheetNumber, sampleNumber, fileName] = gather(fileNumber, ...
    sampleDirectory, manualInput, measurements, testtype)
%% Gather Measurements

    strain = 0;
    strainTrans = 0;
    displacement = 0;
    
    %% Parse Filename
    fileName = sampleDirectory(fileNumber).name
    fprintf('Starting Sample #%d: ''%s''\n', fileNumber, fileName)
    sheetNumber = fileName(1:(strfind(fileName, '_') - 1));
    sampleNumber = replace(fileName((strfind(fileName, '_')) + 1 : strfind(fileName, '.') - 1), '_', '-');
    
    %% Load Data (Different for each test)
    
    %%Old load and disp reading
    %data = csvread(fileName, 2, 0);
    %load = data(:,22);                                          %Load data in (N) is stored in the 22nd column, column V in Excel
    %strain = data(:,9);                                         %Strain data, e_yy, is stored in the 9th column, column I in Excel
    %strainTrans = data(:,8);
    
    if strcmp(testtype, 't')
        %%If test type is Tensile
        
        %%Smart Read
        [data,text] = xlsread(fileName);
        [~,loadcolumn] = find(contains(text,'Load_5kip_(N)'));
        [~,straincolumn] = find(contains(text,'eyy [1] - Lagrange'));
        [~,straintranscolumn] = find(contains(text,'exx [1] - Lagrange'));
    
        loadRAW = data(:,loadcolumn);                                          %Load data in (N) is stored in the 22nd column, column V in Excel
        strainRAW = data(:,straincolumn);                                         %Strain data, e_yy, is stored in the 9th column, column I in Excel
        %srainRAW = strainRAW - strainRAW(1);
        strainTransRAW = data(:,straintranscolumn);
        
        z = 1;
        %loadChange = loadRAW(2:end)-loadRAW(1:end-1);
        for i = 1:length(strainRAW)
            if strainRAW(i) < 0
                z = z+1;
            end
        end
        
        strain = strainRAW(z:length(strainRAW));
        strain = strain - strain(1);
        load = loadRAW(z:length(loadRAW));
        strainTrans = strainTransRAW(z:length(strainTransRAW));
        
        %{
        z=0;
        load = zeros(1,length(loadRAW));
        loadChange = loadRAW(2:end)-loadRAW(1:end-1);
        increaseIDX = 0;
        increaseThreshold = 10; %must find this many positive load changes in a row
        
        %%Offset to start at load ramp
        for i = 1:length(loadChange) %length of loadRAW and displacementRAW are same
            if loadChange(i)>0 %value is increasing
                increaseIDX = increaseIDX+1;
            else
                increaseIDX = 0;
            end
            if increaseIDX>increaseThreshold %has been increasing for 20 data points
                dataStartIDX = i-increaseThreshold;
                break
            end
        end %Offsets load and displacement to start where load starts to climb - in general just below 3 N
        load = loadRAW(dataStartIDX:end);
        %}
        
        
        %strain = strain - strain(1); %Offsets y-dir strain to start at 0 mm
        %strainTrans = strainTrans - strainTrans(1); %Offsets x-dir strain to start at 0 mm
        
    elseif strcmp(testtype, 'f')
        %%If test type if flexure
        
        %%Smart Read
        [data,text] = xlsread(fileName);
        [~,loadcolumn] = find(contains(text,'Load_5kip_(N)'));
        [~,straincolumn] = find(contains(text,'Vp [mm]'));
        
        %%Load and displacement formulas differ between ILS and Flexure
        %%tests. Also, load cell connections were inaccurate for Flexure
        %if strcmp(testtype, 'f')
            loadRAW = -data(:,loadcolumn); 
            displacementRAW = abs(data(:,straincolumn)); %RAW (without offset) displacement data, e_yy, is stored in the 1st column in Excel
        %elseif strcmp(testtype, 'i')
        %    loadRAW = -data(4:length(data),loadcolumn);
        %    displacementRAW = -data(4:length(data),straincolumn);
        %end 
        
        for i = 1:length(displacementRAW)
            if displacementRAW(i) < 0
                displacementRAW(i) = -1*displacementRAW(i);
            end
        end
        
        
        z=0;
        load = zeros(1,length(loadRAW));
        loadChange = loadRAW(2:end)-loadRAW(1:end-1);
        increaseIDX = 0;
        increaseThreshold = 10; %must find this many positive load changes in a row
        dataStartIDX = 1;
       
        %%Offset to start at load ramp
        for i = 1:length(loadChange) %length of loadRAW and displacementRAW are same
            if loadChange(i)>0 %value is increasing
                increaseIDX = increaseIDX+1;
            else
                increaseIDX = 0;
            end
            if increaseIDX>increaseThreshold %has been increasing for 20 data points
                dataStartIDX = i-increaseThreshold;
                break
            end
        end %Offsets load and displacement to start where load starts to climb - in general just below 3 N
        %}
        
        load = loadRAW(dataStartIDX:end);
        
        %%Offset to start displacement at zero
        displacement = displacementRAW(dataStartIDX:end);
   
        displacement = displacement - displacement(1); %Offsets displacement to start at 0 mm
        
    elseif strcmp(testtype,'i')
        %%If test type is ILS
        
        %%Copied from original script
        [data,text] = xlsread(fileName);
        [~,loadcolumn] = find(contains(text,'Force'));
        [~,straincolumn] = find(contains(text,'Displacement'));
        
        loadRAW = -data(4:length(data),loadcolumn);
        displacementRAW = -data(4:length(data),straincolumn);
        
        z=0;
        load = zeros(1,length(loadRAW));
        for i = 1:length(loadRAW)
            %%CHANGE BETWEEN ILS SINGLE AND MULTI
            if loadRAW(i) > 15 && displacementRAW(i) < 1 && displacementRAW(i) > 0
                z=z+1;
                load(z) = loadRAW(i-1);
                displacement(z) = displacementRAW(i-3);
            end
        end %Offsets load and displacement to start where load starts to climb - in general just below 3 N

        displacement = displacement - displacement(1); %Offsets displacement to start at 0 mm

    else
        fprintf('\nPlease Enter the correct test type and rerun\n')
        
        %%Enter command to stop entire script
        
    end %If else statements for detecting test type
        
    %% Measurement Values
    if (manualInput == true)                                    %The user decides whether to use a preloaded Measurements.xlsx file or input each sample's dimensions
        width = input('Sample Width (mm): ');                   %Sample width (mm)
        thickness = input('Sample Thickness (mm): ');           %Sample thickness (mm)
    else %find corrrect measurement row in measurements.xlsx
        nameParts = strsplit(fileName,'_');
        measureSearchName = [nameParts{1},'_',nameParts{2}];    %name to search for in measurements
        measureIdx = find(strcmp(measurements.Var1,measureSearchName));
        if size(measureIdx,1)==0
            disp('Specimen Measurements Missing or Mislabeled in Measurements.xlsx')
        end
        width = measurements.Var2(measureIdx(1));                    %Sample width
        thickness = measurements.Var3(measureIdx(1));                %Sample thickness, only need first idx since identical
    end
    
    
end