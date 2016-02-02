%% SVM Classifier
% get data 

% fileID = fopen('009586124_1_143873_[2015 6 13]_[5 0 43].bin'); 
% A = fread(fileID, [18,inf]); 
% A = A'; 
% fclose(fileID); 

% start_time = 353251.55;
start_time = 3.356174348000000e+11 / 1e6;
end_time = 353689.00;
[dataset,data_clip] = analyzeData('I001_P002_D01',start_time,600);

A = data_clip;
[M, N] = size(data_clip);

numMinutes = 10;
valsPerSec = length(A)/(numMinutes*60); %aka fs = sample rate
windowSize = 10; %size of window in seconds
valsPerWindow = round(valsPerSec * windowSize); 
numWindows = numMinutes*60/10; 

% line_lengths = zeros(numWindows, N);
% energy = zeros(numWindows, N);
% 
% for i = 1:numWindows
%     
%     startIndex = (i-1)*valsPerWindow + 1;
% %     disp(startIndex);
%     endIndex = i*valsPerWindow; 
%     disp([num2str(endIndex / M * 100) '%'] ); 
%     
%     line_length = f_line_length(A,startIndex,endIndex,valsPerSec); 
%     line_lengths(i,:) = line_length; 
%     
%     singleEnergy = f_energy(A, startIndex,endIndex,valsPerSec);
%     energy(i,:) = singleEnergy; 
% 
%     disp('================'); 
% end

% training data on avg of channels
load linelength1
load energy1
X = [ mean(line_lengths,2) mean(energy,2) ];
Y = zeros(60,1);

ann = dataset.annLayer(1).getEvents(1); % might need to use a different annLayer
ann_start_times = {ann.start};
ann_stop_times = {ann.stop};
[cell_rows, cell_cols] = size(ann_start_times);
for j=1:numWindows
    Y(j) = 1; % non seizure
    for k=1:cell_cols
        seizure_duration = (ann_stop_times{k} - ann_start_times{k}) / 1e6; % put into seconds
        if seizure_duration == 0
            continue;
        end
        if (start_time + j*10 <= (ann_stop_times{k} / 1e6)) && ...
                (start_time + j*10 >= (ann_start_times{k} / 1e6))
            Y(j) = -1; % possible seizure
            break;
        end
    end    
end

SVMModel = fitcsvm(X,Y);

sv = SVMModel.SupportVectors;
figure
gscatter(X(:,1),X(:,2),Y)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
xlabel('Line Length')
ylabel('Energy')
legend('possible seizure','non-seizure','Support Vector')
hold off

CVSVMModel = crossval(SVMModel);
misclass1 = kfoldLoss(CVSVMModel);
misclass1

%% Test second part of seizure for new predictions
% load linelength
% load energy
% newX = [ mean(line_lengths,2) mean(energy,2) ];
% [label,score] = predict(SVMModel,newX);
% start_time = 353251.55;
% 
% for j=1:numWindows
%     Y(j) = 1; % non seizure
%     for k=1:cell_cols
%         seizure_duration = (ann_stop_times{k} - ann_start_times{k}) / 1e6; % put into seconds
%         if seizure_duration == 0
%             continue;
%         end
%         if (start_time + j*10 <= (ann_stop_times{k} / 1e6)) && ...
%                 (start_time + j*10 >= (ann_start_times{k} / 1e6))
%             Y(j) = -1; % possible seizure
%             break;
%         end
%     end    
% end
% 
% JASON = label == Y; % get accuracy
% accuracy = nnz(JASON) / 60;



% test data on first channel


