%% Decision Trees Classifier
% get data 

% start_time = 353251.55;

session_names = char('I001_P002_D01', 'I001_P005_D01', 'I001_P010_D01');
r = randi([1 3],1,1); % generate random number between 1 and 3
session_name = session_names(r,:);

start_time = 3.356174348000000e+11 / 1e6;
% start_time = 0;
% end_time = 353689.00;
disp([ 'Session Name: ', session_name ]);
% [dataset,data_clip] = analyzeData('I001_P002_D01',start_time,600);

% [dataset,data_clip] = analyzeData(session_name,start_time,600);

A = data_clip;
[M, N] = size(data_clip);

numMinutes = 10;
valsPerSec = length(A)/(numMinutes*60); %aka fs = sample rate
windowSize = 10; %size of window in seconds
valsPerWindow = round(valsPerSec * windowSize); 
numWindows = numMinutes*60/10; 

line_lengths = zeros(numWindows, N);
energy = zeros(numWindows, N);

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
X = [ line_lengths energy ];
Y = zeros(60,1);

ann = dataset.annLayer(1).getEvents(1); % might need to use a different annLayer
ann_start_times = {ann.start};
ann_stop_times = {ann.stop};
[cell_rows, cell_cols] = size(ann_start_times);


% Get corresponding labels for training instances
for j=1:numWindows
    Y(j) = 1; % non seizure
    for k=1:cell_cols
        seizure_duration = (ann_stop_times{k} - ann_start_times{k}) / 1e6; % put into seconds
        if seizure_duration == 0
            continue;
        end
        if (start_time + j*10 <= (ann_stop_times{k} / 1e6)) && ...
                (start_time + j*10 >= (ann_start_times{k} / 1e6))
            Y(j) = 0; % possible seizure (changed to 0 from -1)
            break;
        end
    end    
end

Y = logical(Y);
dtree = fitctree(X,Y,'Cost',[0 1; 5 0]);
crossdtree = crossval(dtree);
misclass1 = kfoldLoss(crossdtree);
disp(['DTree CVal Accuracy: ' num2str(1.0 - misclass1)]);



% create DTree ROC curve

[~,score_tree] = resubPredict(dtree);
[XTree,YTree,TTree,AUCTree] = perfcurve(Y,score_tree(:,dtree.ClassNames),'true');


% plot ROC curve
figure
plot(XTree,YTree)
legend('AdaBoost Tree','Location','Best')
xlabel('False positive rate'); ylabel('True positive rate');
title('ROC Curves for Decision Tree')
hold off



% Test second part of seizure data for new predictions
load linelength
load energy
newX = [ line_lengths energy ];
[label,score] = predict(dtree,X);
start_time = 353251.55;



for j=1:numWindows
    Y(j) = 1; % non seizure
    for k=1:cell_cols
        seizure_duration = (ann_stop_times{k} - ann_start_times{k}) / 1e6; % put into seconds
        if seizure_duration == 0
            continue;
        end
        if (start_time + j*10 <= (ann_stop_times{k} / 1e6)) && ...
                (start_time + j*10 >= (ann_start_times{k} / 1e6))
            Y(j) = 0; % possible seizure
            break;
        end
    end    
end

logic_vector = (label == Y); % get accuracy
accuracy = nnz(logic_vector) / 60;
% [prec, tpr, fpr, thresh] = prec_rec(label, Y);
% prec_rec(label, Y);

[C,order] = confusionmat(Y,label);
TP = (C(1,1) + C(2,2));
FP = C(1,2);
precision = TP / (TP + FP);
disp(['DTree Prediction Accuracy: ', num2str(accuracy)]);
disp(['DTree Precision: ', num2str(precision)]);

