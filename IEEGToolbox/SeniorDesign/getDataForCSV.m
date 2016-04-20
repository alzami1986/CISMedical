start_time = 0;
duration = 600; % in seconds
session = IEEGSession('I001_P002_D01', 'indaso', 'ind_ieeglogin');
dataset = session.data;

numChannels = length(dataset.rawChannels);
numMinutes = (duration/60);
numWindows = duration/10;
numRows = duration*100;
downSampleRate = 50;
reSampleRate = 100;
csvTime = 0;
seizure_length = dataset.rawChannels(1).get_tsdetails.getDuration / 1e6;
numDataWindows = floor(seizure_length / duration);
allData = NaN(1200000, numChannels);
ind = 1;

for t = 1:numDataWindows
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
    A = high_pass_filter(A, sampleRate);
    A = low_pass_filter(A, sampleRate);
    
    numRows = reSampleRate*duration;
    downSampledData = downsample(A, downSampleRate);
%     index = (t-1)*numRows + 1;
    index = ind;
    allData(index:index + (numRows - 1),:) = downSampledData;
    if(t==numDataWindows)
        allData(index+60000:end,:) = NaN;
        filename = ['./data/patient1/patient1_' num2str(csvTime) '.csv'];
        writeToCSV(allData, csvTime, filename);
        break;
    end
    if(ind == 1140001)
        if(exist('data/patient1','dir') ~= 7)            
            mkdir('data/patient1')
        end
        filename = ['./data/patient1/patient1_' num2str(csvTime) '.csv'];
        writeToCSV(allData, csvTime, filename);
        csvTime = csvTime + 1200000*10;
        ind = 1;
    end
    ind = ind + 60000;
    start_time = start_time + duration;

    toc
end

