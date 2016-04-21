% start_time = 0;
start_time = 334200;
duration = 600; % in seconds
session = IEEGSession('I001_P002_D01', 'indaso', 'ind_ieeglogin');
dataset = session.data;

dec_data = NaN(500,15);
downData = NaN(100,15);
numChannels = length(dataset.rawChannels);
numMinutes = (duration/60);
numWindows = duration/10;
downSampleRate = 5;
reSampleRate = 1000;
numRows = duration*reSampleRate;

% csvTime = 558*60000*10;
csvTime = 560*600000; % begin of seizure with ms timestamp
seizure_length = dataset.rawChannels(1).get_tsdetails.getDuration / 1e6;
% numDataWindows = floor(seizure_length / duration);
numDataWindows = 560+32;
maxDataRows = 1200000;
allData = NaN(maxDataRows, numChannels);
ind = 1;

for t = 560:numDataWindows
    tic
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
    
    % only for 05 patient
    %     data_clip(:,[5, 8]) = [];
    A = data_clip;
    [dm,dn] = size(data_clip);
    sampleRate = length(A)/(numMinutes*60); %aka fs = sample rate
    
    
    % run data through filters
    %     A = high_pass_filter(A, sampleRate);
    %     A = low_pass_filter(A, sampleRate);
    % decimate each set of 5000 rows ( 450 times )
%     numRows = reSampleRate*duration;
%     loop = duration*sampleRate;
%     for k = 1:5000:loop
%         for j = 1:dn % decimate each channel
%             dec_data(:,j) = decimate(data_clip(k:(k+4999),j),10);
%             downData(:,j) = decimate(dec_data(:,j),5);
%         end
%         index = ind + floor((k/5000))*100;
%         allData(index:index + 99,:) = downData;
%     end

    % regular code
%         numRows = reSampleRate*duration;
        downSampledData = downsample(A, downSampleRate);
%         index = (t-1)*numRows + 1;
        index = ind;
        allData(index:index + (numRows - 1),:) = downSampledData;
%     numRows = reSampleRate*duration;
%     allData(index:index + (numRows - 1),:) = A;
    
    if(t==numDataWindows)
        allData = allData(1:index + (numRows - 1),:);
        %         allData(index+60000:end,:) = NaN;
        filename = ['./data/patient1/patient1_' num2str(csvTime) '.mat'];
        csvfile = ['./data/patient1/patient1_' num2str(csvTime) '.csv'];
        save(filename, 'allData','csvTime','csvfile');
        %         writeToCSV(allData, csvTime, filename);
        break;
    end
    if(ind == 600001) % 1140001
        if(exist('data/patient1','dir') ~= 7)
            mkdir('data/patient1')
        end
        filename = ['./data/patient1/patient1_' num2str(csvTime) '.mat'];
        csvfile = ['./data/patient1/patient1_' num2str(csvTime) '.csv'];
        save(filename, 'allData','csvTime','csvfile');
        %         writeToCSV(allData, csvTime, filename);
        csvTime = csvTime + maxDataRows; %*10
        ind = 1;
    end
    ind = ind + numRows;
    start_time = start_time + duration;
    
    toc
end

