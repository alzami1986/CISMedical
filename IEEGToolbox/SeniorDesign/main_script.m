start_time = (3.3562e11)/1e6; 
end_time = (3.358e11)/1e6; 
duration = end_time - start_time;

%[dataset,data_clip] = analyzeData('I001_P002_D01',start_time,duration);
load('I001_P002_D01 - data_clip.mat')

[M, N] = size(data_clip);

numMinutes = duration/60;
valsPerSec = dataset.sampleRate; %aka fs = sample rate
windowSize = 10; %size of window in seconds
valsPerWindow = round(valsPerSec * windowSize); 
numWindows = numMinutes*60/10; 

line_lengths = zeros(numWindows, N);
energy = zeros(numWindows, N);
corr_coeffs = zeros(numWindows,(((N-1)*N)/2)); 

for i = 1:numWindows
    
    startIndex = (i-1)*valsPerWindow + 1;
    disp(startIndex);
    endIndex = min(i*valsPerWindow,M); 
    disp(endIndex); 
    
%     line_length = f_line_length(data_clip,startIndex,endIndex,valsPerSec); 
%      line_lengths(i,:) = line_length; 
%      
%      singleEnergy = f_energy(data_clip, startIndex,endIndex,valsPerSec);
%      energy(i,:) = singleEnergy; 

    corr_coeff = f_corr_coeff(data_clip, startIndex,endIndex,valsPerSec);
    corr_coeffs(i,:) = corr_coeff; 
    

    disp('================'); 
end

%plotter(energy,line_lengths,data_clip); 

