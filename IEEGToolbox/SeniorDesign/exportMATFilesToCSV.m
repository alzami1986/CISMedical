listings = dir('data/patient1/*.mat');
len = length(listings);
filenames = [];
for i=1:len
    filenames = [filenames; listings(i).name];
end

numFiles = len(filenames);
for k=1:numFiles
    load(filenames(i));
    writeToCSV(allData,csvTime,csvfile);
end