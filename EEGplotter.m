% get data 

fileID = fopen('009586124_1_143873_[2015 6 13]_[5 0 43].bin'); 
A = fread(fileID, [18,inf]); 
A = A'; 
plot(A(1:2560,1));
fclose(fileID); 