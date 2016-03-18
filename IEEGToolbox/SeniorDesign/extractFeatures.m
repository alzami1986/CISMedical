function [finalX,finalY] = extractFeatures(start_time, duration) 

    finalX = [];
    finalY = [];
    for t = 1:72
        disp([ 'Iteration: ', num2str(t) ]);
        try
            [dataset,data_clip] = analyzeData('I001_P002_D01',start_time,duration);
        catch
            try
                [dataset,data_clip] = analyzeData('I001_P002_D01',start_time,duration);
            catch
                [dataset,data_clip] = analyzeData('I001_P002_D01',start_time,duration);
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
        Y = zeros(60,1);

        ann = dataset.annLayer(1).getEvents(1); % might need to use a different annLayer
        ann_start_times = {ann.start};
        ann_stop_times = {ann.stop};
        [cell_rows, cell_cols] = size(ann_start_times);


        % Get corresponding labels for training instances
        for j=1:numWindows
            Y(j) = 0; % non seizure
            for k=1:cell_cols
                seizure_duration = (ann_stop_times{k} - ann_start_times{k}) / 1e6; % put into seconds
                if seizure_duration == 0
                    continue;
                end
                if (start_time + j*10 <= (ann_stop_times{k} / 1e6)) && ...
                        (start_time + j*10 >= (ann_start_times{k} / 1e6))
                    Y(j) = 1; % possible seizure (changed to 0 from -1)
                    break;
                end
            end
        end
        finalX = [ finalX; X ];
        finalY = [ finalY; Y ];
        start_time = start_time + duration;
    end
    
    save('finalXHalf.mat','finalX')
    save('finalYHalf.mat','finalY')
end