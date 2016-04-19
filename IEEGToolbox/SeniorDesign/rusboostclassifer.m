%% Bagged Decision Trees Classifier

crossvalidation_on = false;

load finalXFullSignal3
load finalYFullSignal3

tic
% [finalX, finalY] = extractFeatures(dataset, start_time, duration);
[XX,YY] = getSampleData(finalX, finalY, 10);
finalYY = logical(strcmp(finalY, 'possible seizure'));

if(not(crossvalidation_on))
    part = cvpartition(YY,'holdout',0.5);
    istrain = training(part); % data for fitting
    istest = test(part); % data for quality assessment
end

tic
t = templateTree('MinLeafSize',5);
cost = [0 1; 10 0];
if(not(crossvalidation_on))
%     rusTree = fitensemble(XX(istrain,:),YY(istrain),'RUSBoost',1000,t,...
%     'LearnRate',0.1,'nprint',100,'Cost',cost);
    rusTree = fitensemble(XX,YY,'RUSBoost',1000,t,...
    'LearnRate',0.1,'nprint',100,'Cost',cost);
else
    cv = cvpartition(YY,'KFold',10);
    rusTree = fitensemble(XX,YY,'RUSBoost',1000,t,...
    'LearnRate',0.1,'nprint',100,'CVPartition',cv,'Cost',cost);
end
toc

%{
figure;
if(not(crossvalidation_on))
%     plot(loss(rusTree,XX(istest,:),YY(istest),'mode','cumulative'));
    plot(loss(rusTree,XX,YY,'mode','cumulative'));
else
    plot(kfoldLoss(rusTree,'Mode','cumulative'));
end

grid on;
xlabel('Number of trees');
ylabel('Test classification error');
%}

if(not(crossvalidation_on))
%     [yFit, sFit] = predict(rusTree, XX(istest,:));
    [yFit, sFit] = predict(rusTree, finalX);
%     [XTree,YTree,TTree,AUCTree] = perfcurve(YY(istest),sFit(:,rusTree.ClassNames),1, 'xCrit', 'reca', 'yCrit', 'prec');
%     [XTree,YTree,TTree,AUCTree] = perfcurve(finalYY,sFit(:,rusTree.ClassNames),1, 'xCrit', 'reca', 'yCrit', 'prec');
else
    [yFit,sFit] = kfoldPredict(rusTree);
%     [XTree,YTree,TTree,AUCTree] = perfcurve(YY,sFit(:,rusTree.ClassNames),1, 'xCrit', 'reca', 'yCrit', 'prec');
end

if(crossvalidation_on)
    [cfMat, order] = confusionmat(YY,yFit);
else
%     [cfMat, order] = confusionmat(YY(istest),yFit);
    [cfMat, order] = confusionmat(finalYY,yFit);
end
%{
figure
plot(XTree,YTree)
xlabel('Recall'); ylabel('Precision')
title(['Precision-recall curve (AUC: ' num2str(AUCTree) ')'])
%}
TP = cfMat(1,1);
FP = cfMat(2,1);
TN = cfMat(2,2);
FN = cfMat(1,2);

precision = TP / (TP + FP);
recall = TP / (TP + FN);
F_score = 2 * ((precision * recall) / (precision + recall));
accuracy = (TP + TN) / (TP + FP + TN + FN);

if(not(crossvalidation_on))
    header_string = 'RUSBoost Classifier Prediction Results'; 
else
    header_string = 'RUSBoost Classifier Cross-Validation Results'; 
end
header_string2 = ['Date and Time: ', datestr(datetime('now'))];
header_string3 = ['Number of Training Instances: ', num2str(length(rusTree.Y))];
header_string4 = ['Number of Testing Instances: ', num2str(length(yFit))];
accuracy_string = ['RUSBoost Accuracy: ', num2str(accuracy)];
precision_string = ['RUSBoost Precision: ', num2str(precision)];
recall_string = ['RUSBoost Recall: ', num2str(recall)];
f_score_string = ['RUSBoost F1 Score: ', num2str(F_score)];
if(length(finalY) == 39660)
    dataset_string = 'Dataset ID: I001_P002_D01';
elseif(length(finalY) == 11385)
    dataset_string = 'Dataset ID: I001_P005_D01';
else
    dataset_string = 'Dataset ID: I001_P010_D01';
end
results = char(header_string, header_string2, header_string3, accuracy_string, precision_string, ...
    recall_string, f_score_string,dataset_string,header_string4);
logResults(results, cfMat, cost);

%% Reduce Size of Tree
%{
cmpctRus = compact(rusTree);

sz(1) = whos('rusTree');
sz(2) = whos('cmpctRus');
[sz(1).bytes sz(2).bytes]

% cmpctRus = removeLearners(cmpctRus,[300:1000]);

sz(3) = whos('cmpctRus');
sz(3).bytes

L = loss(cmpctRus,finalX(istest,:),finalY(istest))
disp(['rusboost Loss Accuracy: ', num2str(1 - L)]);
%}