function writeToCSV(allData)
allData = allData(:,1);
% allData(not(allData)) = NaN;
tic
[m,n] = size(allData);

headers = 'time';
for j = 1:n
    channel = ['channel' num2str(j)];
    headers = char( headers, channel );
end
headers = cellstr(headers);
headers = headers';

Xtime = zeros(m,1);
j = 0;
for i = 1:m
    j = j + 10;
    Xtime(i) = j;
end
% set buffer for header row and time column
data = zeros(m+1,n+1);
data(2:end,1) = Xtime;
data(2:end,2:end) = allData;

% give spacing between channels
[m,n] = size(data);
for k = 2:n
    data(:,k) = data(:,k) + k*100;
end

% add header to top row of data
data = num2cell(data);
for jj = 1:n
    data{1,jj} = headers{jj};
end
[m,n] = size(data);
s = cell(1, m);

%create header format string
fs = '';
for i = 1:(n-1)
    fs = [fs '%s,'];
end
fs = [fs '%s\n'];

% print header values to one string
s{1} = sprintf(fs,data{1,:});


%create data format string
fs = '';
fs = [fs '%d,'];
for i = 2:(n-1)
    fs = [fs '%f,'];
end
fs = [fs '%f\n'];

% write actual data to string
for i = 2:m
    s{i} = sprintf(fs,data{i,:});
end
str = [s{:}];

% write data all at once to file
fid = fopen('patient1_100.csv','w');
fwrite(fid, str);
fclose(fid);

toc
end