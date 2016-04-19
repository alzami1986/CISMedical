data = zeros(5,2);
data = num2cell(data);
[m,n] = size(data);
s = cell(1, m);



%create data format string
fs = '';
fs = [fs '%d,'];
for i = 2:(n-1)
    fs = [fs '%s,'];
end
fs = [fs '%s\n'];
for i = 1:m
    s{i} = sprintf(fs,data{i,:});
end
str = [s{:}];

 
% write data all at once
fid = fopen('patient2_3.csv','w');
fwrite(fid, str);
fclose(fid);
