listings = dir('data/patient1/*.mat');
len = length(listings);
filenames = [];
for i=1:len
    filenames = [filenames; listings(i).name];
end

[numFiles, ~] = size(filenames);
for k=1:numFiles
    tic
    load(['data/patient1/' filenames(i,:)]);
    writeToCSV(allData,csvTime,csvfile);
    toc
end