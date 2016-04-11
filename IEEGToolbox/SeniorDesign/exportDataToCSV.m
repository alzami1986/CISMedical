start_time = 0;
duration = 450; % in seconds
session = IEEGSession('I001_P005_D01', 'indaso', 'ind_ieeglogin');
dataset = session.data;

allData = [];
tic
for t = 1:192 % 72 for half a day, 864 for full day on 1st patient, 280, 7118 3rd patient
    disp([ 'Iteration: ', num2str(t) ]);
    disp([ 'Start_time: ', num2str(start_time) ]);
    try
        data_clip = dataset.getvalues(start_time*1e6,duration*1e6, ':');
    catch
        try
            data_clip = dataset.getvalues(start_time*1e6,duration*1e6, ':');
            
        catch
            try
                data_clip = dataset.getvalues(start_time*1e6,duration*1e6, ':');
            catch
                disp([ 'Error with segment. Skipping ', 'start_time: ', num2str(start_time) ]);
                start_time = start_time + duration;
                continue;
            end
            
        end
    end
    
%{    
    A = data_clip;
    [M, N] = size(data_clip);
    
        numMinutes = (duration/60)*(t+1);
    numMinutes = (duration/60);
    valsPerSec = length(A)/(numMinutes*60); %aka fs = sample rate
    windowSize = 10; %size of window in seconds
    valsPerWindow = round(valsPerSec * windowSize);
    numWindows = numMinutes*60/10;
%}  
    start_time = start_time + duration;
    % only for 05 patient
    data_clip(:,[5, 8]) = [];
    for j = 1:5000:(duration*5000)
        A = mean(data_clip(j:j+4999,:));
        A = int64(A);
        allData = [ allData; A ];
    end
end
toc
data = allData;
[m,n] = size(data);
headers = 'time';
for j = 1:n
    channel = ['channel' num2str(j)];
    headers = char( headers, channel );
end
Xtime = [];
% j = 1;
for i = 1:m
%     j = j + 1;
    Xtime = [Xtime; i];
end
data = [Xtime data];
[m,n] = size(data);
for k = 2:n
    data(:,k) = data(:,k) + 200;
end
headers = cellstr(headers);
csvwrite_with_headers('allChannelsMini.csv',data,headers)
% fileID = fopen('bigData2.bin','w');
% fwrite(fileID, data_clip);
% fclose(fileID);
toc