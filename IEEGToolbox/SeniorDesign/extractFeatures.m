function [finalX,finalY] = extractFeatures(dataset, start_time, duration)

finalX = [];
finalY = '';
for t = 1:2154 % 72 for half a day, 864 for full day on 1st patient, 280, 7118 3rd patient
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
    
    
    A = data_clip;
    [M, N] = size(data_clip);
    
    %     numMinutes = (duration/60)*(t+1);
    numMinutes = (duration/60);
    valsPerSec = length(A)/(numMinutes*60); %aka fs = sample rate
    windowSize = 10; %size of window in seconds
    valsPerWindow = round(valsPerSec * windowSize);
    numWindows = numMinutes*60/10;
    
    line_lengths = zeros(numWindows, N);
    energy = zeros(numWindows, N);
    
    % run data through filters
    A = high_pass_filter(A, valsPerSec);
    A = low_pass_filter(A, valsPerSec);
    
    for i = 1:numWindows
        
        startIndex = (i-1)*valsPerWindow + 1;
        %     disp(startIndex);
        endIndex = i*valsPerWindow;
        %     disp([num2str(endIndex / M * 100) '%'] );
        
        line_length = f_line_length(A,startIndex,endIndex,valsPerSec);
        line_lengths(i,:) = line_length;
        
        singleEnergy = f_energy(A, startIndex,endIndex,valsPerSec);
        energy(i,:) = singleEnergy;
        
        %     disp('================');
    end
    
    % training data on avg of channels
    % load linelength1
    % load energy1
    X = [ line_lengths energy ];
    
    % load feature_data
    Y = '';
    
    ann = dataset.annLayer(1).getEvents(1); % might need to use a different annLayer
    ann_start_times = {ann.start};
    ann_stop_times = {ann.stop};
    [cell_rows, cell_cols] = size(ann_start_times);
    
    
    % Get corresponding labels for training instances
    for j=1:numWindows
        region = 'non-seizure'; % non seizure
        for k=1:cell_cols
            seizure_duration = (ann_stop_times{k} - ann_start_times{k}) / 1e6; % put into seconds
            if seizure_duration == 0
                continue;
            end
            if (start_time + j*10 <= (ann_stop_times{k} / 1e6)) && ...
                    (start_time + j*10 >= (ann_start_times{k} / 1e6))
                region = 'possible seizure'; % possible seizure (changed to 0 from -1)
                break;
            end
        end
        Y = char(Y, region);
    end
    Y = Y(2:end,:);
    finalX = [ finalX; X ];
    finalY = char(finalY, Y);
    start_time = start_time + duration;
    save('finalXFullSignal33.mat','finalX')
    save('finalYFullSignal33.mat','finalY')
end
finalY = finalY(2:end,:);
finalY = cellstr(finalY);
% vector = ~any(isnan(finalX),2);
% finalX = finalX(vector,:);
% finalY = finalY(vector);

save('finalXFullSignal3.mat','finalX')
save('finalYFullSignal3.mat','finalY')
end