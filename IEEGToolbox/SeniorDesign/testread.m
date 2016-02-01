fid = fopen('009586124_1_143873_[2015 6 13]_[5 0 43].bin', 'rb');
count = [18 inf];
col = fread(fid,'int16');
fclose(fid);