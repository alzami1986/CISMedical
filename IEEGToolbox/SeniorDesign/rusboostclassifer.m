%% Bagged Decision Trees Classifier
% get data 

% start_time = 353251.55;

% session_names = char('I001_P002_D01', 'I001_P005_D01', 'I001_P010_D01');
% r = randi([1 3],1,1); % generate random number between 1 and 3
% session_name = session_names(r,:);

% start_time = 3.356174348000000e+11 / 1e6;
start_time = 0;
% end_time = 353689.00;
session = IEEGSession('I001_P010_D01', 'indaso', 'ind_ieeglogin');
dataset = session.data;
% duration = 600; 1st patient dataset
duration = 150; % 2nd patient dataset

tic
% [finalX, finalY] = extractFeatures(dataset, start_time, duration);
toc

load finalXFullSignal3
load finalYFullSignal3

part = cvpartition(finalY,'holdout',0.5);
istrain = training(part); % data for fitting
istest = test(part); % data for quality assessment

tic
t = templateTree('MinLeafSize',5);
rusTree = fitensemble(finalX(istrain,:),finalY(istrain),'RUSBoost',1000,t,...
    'LearnRate',0.1,'nprint',100);
toc

figure;
tic
plot(loss(rusTree,finalX(istest,:),finalY(istest),'mode','cumulative'));
toc
grid on;
xlabel('Number of trees');
ylabel('Test classification error');

tic
Yfit = predict(rusTree,finalX(istest,:));
toc
tab = tabulate(finalY(istest));
[cfMat,order] = confusionmat(finalY(istest),Yfit),tab(:,2)
%{
finalYYY = [];
finalYfit = [];
LL = finalY(istest);
NN = length(LL);

parfor i = 1:NN
    if(strcmp(LL(i),'non-seizure'))
        finalYYY = [finalYYY; 1];
    else
        finalYYY = [finalYYY; 0];
    end
end
parfor i = 1:NN
    if(strcmp(Yfit(i),'non-seizure'))
        finalYfit = [finalYfit; 1];
    else
        finalYfit = [finalYfit; 0];
    end
end
plotconfusion(finalYYY,finalYfit);
%}
TP = cfMat(1,1);
FP = cfMat(1,2);
TN = cfMat(2,2);
FN = cfMat(2,1);

precision = TP / (TP + FP);
recall = TP / (TP + FN);
F_score = 2 * ((precision * recall) / (precision + recall));
accuracy = (TP + TN) / (TP + FP + TN + FN);

disp(['rusboost CVAL Accuracy: ', num2str(accuracy)]);
disp(['rusboost Precision: ', num2str(precision)]);
disp(['rusboost Recall: ', num2str(recall)]);
disp(['rusboost F1 Score: ', num2str(F_score)]);

cmpctRus = compact(rusTree);

sz(1) = whos('rusTree');
sz(2) = whos('cmpctRus');
[sz(1).bytes sz(2).bytes]

% cmpctRus = removeLearners(cmpctRus,[300:1000]);

sz(3) = whos('cmpctRus');
sz(3).bytes

L = loss(cmpctRus,finalX(istest,:),finalY(istest))
disp(['rusboost Loss Accuracy: ', num2str(1 - L)]);
