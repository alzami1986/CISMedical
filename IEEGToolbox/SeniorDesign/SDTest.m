

fileID = fopen('pt1/449377092_1_1069057_[2015 8 26]_[5 5 28].bin'); 
A = fread(fileID, [18,inf]); 
A = A'; 
fclose(fileID); 

valsPerSec = length(A)/(5*60); %aka fs = sample rate
windowSize = 10; %size of window in seconds
valsPerWindow = round(valsPerSec * windowSize); 
numWindows = 5*60/10; 

results = zeros(numWindows,18);
energy = zeros(numWindows, 18);

for i = 1:numWindows
    
    startIndex = (i-1)*valsPerWindow + 1;
    disp(startIndex);
    endIndex = i*valsPerWindow; 
    disp(endIndex); 
    
    result = f_line_length(A,startIndex,endIndex,valsPerSec); 
    results(i,:) = result; 
    
    singleEnergy = f_energy(A, startIndex,endIndex,valsPerSec);
    energy(i,:) = singleEnergy; 

    disp('================'); 
end


%plotter(results);
plotter(energy);


