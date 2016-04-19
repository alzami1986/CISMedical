%% ADABoost Decision Trees Classifier

load finalXFullSignal3
load finalYFullSignal3

tic
[XX,YY] = getSampleData(finalX, finalY, 0);
toc

part = cvpartition(finalY,'holdout',0.5);
istrain = training(part); % data for fitting
istest = test(part); % data for quality assessment

tic
% t = templateTree('MinLeafSize',5);
cost = [0 1; 10 0];
% cost = [0 10; 1 0];
ens = fitensemble(XX(istrain,:),YY(istrain),'AdaBoostM1',100,'Tree','Cost',cost);
% rusTree = fitensemble(XX,YY,'RUSBoost',1000,t,...
%     'LearnRate',0.1,'nprint',100,'KFold',5,'Cost',cost);
toc

figure;

plot(loss(ens,XX(istest,:),YY(istest),'mode','cumulative'));
% plot(kfoldLoss(rusTree,'Mode','cumulative'));
toc
grid on;
xlabel('Number of trees');
ylabel('Test classification error');

% [yFit,sFit] = kfoldPredict(rusTree);
[pred,scores] = predict(ens, XX(istest,:));
[XTree,YTree,TTree,AUCTree] = perfcurve(YY(istest),scores(:,ens.ClassNames),1, 'xCrit', 'reca', 'yCrit', 'prec');
[cfMat, order] = confusionmat(YY(istest),pred)

figure
plot(XTree,YTree)
xlabel('Recall'); ylabel('Precision')
title(['Precision-recall curve (AUC: ' num2str(AUCTree) ')'])


%{
tic
Yfit = predict(rusTree,finalX(istest,:));
toc
tab = tabulate(finalY(istest));
[cfMat,order] = confusionmat(finalY(istest),Yfit),tab(:,2)
%}

TP = cfMat(1,1);
FP = cfMat(2,1);
TN = cfMat(2,2);
FN = cfMat(1,2);

precision = TP / (TP + FP);
recall = TP / (TP + FN);
F_score = 2 * ((precision * recall) / (precision + recall));
accuracy = (TP + TN) / (TP + FP + TN + FN);

disp(['AdaBoost CVAL Accuracy: ', num2str(accuracy)]);
disp(['AdaBoost Precision: ', num2str(precision)]);
disp(['AdaBoost Recall: ', num2str(recall)]);
disp(['AdaBoost F1 Score: ', num2str(F_score)]);

header_string = 'AdaBoost Classifier Prediction Results'; 
header_string2 = ['Date and Time: ', datestr(datetime('now'))];
header_string3 = ['Number of Training Instances: ', num2str(length(ens.Y))];
header_string4 = ['Number of Testing Instances: ', num2str(length(yFit))];
accuracy_string = ['AdaBoost Accuracy: ', num2str(accuracy)];
precision_string = ['AdaBoost Precision: ', num2str(precision)];
recall_string = ['AdaBoost Recall: ', num2str(recall)];
f_score_string = ['AdaBoost F1 Score: ', num2str(F_score)];
if(length(finalY) == 39660)
    dataset_string = 'Dataset ID: I001_P002_D01';
elseif(length(finalY) == 11385)
    dataset_string = 'Dataset ID: I001_P005_D01';
else
    dataset_string = 'Dataset ID: I001_P010_D01';
end
results = char(header_string, header_string2, header_string3, accuracy_string, precision_string, ...
    recall_string, f_score_string, dataset_string, header_string4);
logResults(results, cfMat, cost);
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