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
dec_data = zeros(500,numChannels);
dec_data2 = zeros(50,numChannels);
A = zeros(5,numChannels);
tic
seizure_length = dataset.rawChannels(1).get_tsdetails.getDuration / 1e6;
numDataWindows = floor(seizure_length / duration); 

beginWindows = 0:193:772;

for i = 1:4;
    allData = NaN((numDataWindows*duration*reSampleRate)/4, numChannels);
    
    for t = beginWindows(i)+1:beginWindows(i+1)
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
        
        start_time = start_time + duration;
        % only for 05 patient
        %     data_clip(:,[5, 8]) = [];
        A = data_clip;
        [dm,dn] = size(data_clip);
        sampleRate = length(A)/(numMinutes*60); %aka fs = sample rate
        
        
        % run data through filters
        A = high_pass_filter(A, sampleRate);
        A = low_pass_filter(A, sampleRate);
        
        numRows = reSampleRate*duration;
        %     loop = duration*5000;
        ans2 = downsample(A, downSampleRate);
        index = (t-1)*numRows + 1;
        allData(index:index + (numRows - 1),:) = ans2;
        % decimate each set of 5000 rows ( 450 times )
        %     for k = 1:5000:loop
        %         for j = 1:dn % decimate each channel
        %             dec_data(:,j) = decimate(data_clip(k:(k+4999),j),10);
        %             dec_data2(:,j) = decimate(dec_data(:,j),10);
        %             A(:,j) = decimate(dec_data2(:,j),10);
        %         end
        %         index = (t-1)*numRows + 1 + (floor(k/5000)*5);
        %         allData(index:index + 4,:) = A;
        %     end
        toc
        
    end
    patient_num = i;
    filename = ['patient1_hundredrate' num2str(patient_num) '.mat'];
    save(filename,'allData','-v7.3')
end