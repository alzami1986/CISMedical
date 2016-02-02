start_time = 3.3562e11 - 10e6; 
end_time = 3.358e11 + 10e6; 
duration = end_time - start_time;

[dataset,data_clip] = analyzeData('I001_P002_D01',start_time,duration);

total_line_length = []; 
total_energy = []; 

for i=start_time:10e6:3.358e11
    line_length = f_line_length(data_clip,start_time,start_time+10,dataset.sampleRate);
    energy = f_energy(data_clip, start_time,start_time+10,dataset.sampleRate);
end 

%start: 3.3562e11
%end: 3.358e11 

A = data_clip;
[M, N] = size(data_clip);

% startIndex = 1;
% endIndex = M;
% 
% line_length = f_line_length(A,startIndex,endIndex,dataset.sampleRate);
% 
% energy = f_energy(A, startIndex,endIndex,dataset.sampleRate);
% 
% plotter(line_length, A);