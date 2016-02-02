%iteration for 10s clip

start_time = 353251.55;
end_time = 353689.00;
[dataset,data_clip] = analyzeData('I001_P002_D01',start_time,600);

A = data_clip;
[M, N] = size(data_clip);

startIndex = 1;
endIndex = M;

line_length = f_line_length(A,startIndex,endIndex,dataset.sampleRate);

energy = f_energy(A, startIndex,endIndex,dataset.sampleRate);

plotter(line_length);