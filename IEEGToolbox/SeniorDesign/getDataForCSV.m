start_time = 0;
duration = 450; % in seconds
session = IEEGSession('I001_P005_D01', 'indaso', 'ind_ieeglogin');
dataset = session.data;

allData = zeros(100*281*450, 34);
tic
seizure_length = dataset.rawChannels(1).get_tsdetails.getDuration / 1e6;
numDataWindows = floor(seizure_length / duration); 
for t = 1:numDataWindows % 72 for half a day, 864 for full day on 1st patient, 280, 7118 3rd patient
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
    data_clip(:,[5, 8]) = [];
    [dm,dn] = size(data_clip);
    dec_data = [];
    A = [];
    loop = duration*5000;
    % decimate each set of 5000 rows ( 450 times )
    for k = 1:5000:loop
        for j = 1:dn % decimate each channel
            dec_data(:,j) = decimate(data_clip(k:(k+4999),j),10);
            A(:,j) = decimate(dec_data(:,j),5);
        end
        index = (t-1)*45000 + 1 + (floor(k/5000)*100);
        allData(index:index + 99,:) = A;
    end
    toc

end
save('allData.mat','allData','-v7.3')