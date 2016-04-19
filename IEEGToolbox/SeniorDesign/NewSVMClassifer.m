%% SVM Classifier
% % get data
% % start_time = 353251.55;
% 
% % session_names = char('I001_P002_D01', 'I001_P005_D01', 'I001_P010_D01');
% % r = randi([1 3],1,1); % generate random number between 1 and 3
% % session_name = session_names(r,:);
% 
% % start_time = 335617.4348; % time in seconds
% start_time = 0;
% duration = 600; % in seconds
% % end_time = 353689.00;
% % disp([ 'Session Name: ', session_name ]);
% % finalX = [];
% % finalY = [];
% 
% % session = IEEGSession('I001_P002_D01', 'indaso', 'ind_ieeglogin');
% % dataset = session.data;
% 
% tic
% % [finalX, finalY] = extractFeatures(dataset, start_time, duration);
% 
% load finalXFullSignal
% load finalYFullSignal
% %{
% order = unique(finalY); % Order of the group labels
% cp = cvpartition(finalY,'k',10); % Stratified cross-validation
% 
% f = @(xtr,ytr,xte,yte)confusionmat(yte,...
% classify(xte,xtr,ytr),'order',order);
% 
% % finalY = logical(finalY);
% cfMat = crossval(f,finalX,finalY,'partition',cp);
% cfMat = reshape(sum(cfMat),2,2)
% 
% TP = cfMat(1,1);
% FP = cfMat(1,2);
% TN = cfMat(2,2);
% FN = cfMat(2,1);
% 
% precision = TP / (TP + FP);
% recall = TP / (TP + FN);
% F_score = 2 * ((precision * recall) / (precision + recall));
% accuracy = (TP + TN) / (TP + FP + TN + FN);
% disp(['LDA CVAL Accuracy: ', num2str(accuracy)]);
% disp(['LDA Precision: ', num2str(precision)]);
% disp(['LDA Recall: ', num2str(recall)]);
% disp(['LDA F1 Score: ', num2str(F_score)]);
% %}
% [XX,YY] = getSampleData(finalX, finalY, 8000);
% costMatrix = [0,1;10,0];
% cv = cvpartition(YY,'KFold',10);
% 
% CVSVMModel = fitcsvm(XX,YY,'Standardize',true,'Cost',costMatrix,'CVPartition',cv);
% 
% % create SVM ROC curve
% 
% % Note: Cannot generate curve when only 1 class appears in training data set
% %{
% mdlSVM = fitPosterior(SVMModel);
% [~,score_svm] = resubPredict(mdlSVM);
% [Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(YY,score_svm(:,mdlSVM.ClassNames),'true');
% %}
% 
% % plotting support vectors and datapoints
% %{
% sv = SVMModel.SupportVectors;
% figure
% gscatter(finalX(:,1),finalX(:,2),finalYY)
% hold on
% plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
% xlabel('Line Length')
% ylabel('Energy')
% legend('possible seizure','non-seizure','Support Vector')
% hold off
% %}
% 
% % plot Precision Recall curve
% %{
% figure
% [Xpr,Ypr,Tpr,AUCpr] = perfcurve(YY, score_svm(:,mdlSVM.ClassNames), 1, 'xCrit', 'reca', 'yCrit', 'prec');
% plot(Xpr,Ypr)
% xlabel('Recall'); ylabel('Precision')
% title(['Precision-recall curve (AUC: ' num2str(AUCpr) ')'])
% 
% % plot ROC curve
% figure
% plot(Xsvm,Ysvm)
% % hold on
% % plot(Xlog,Ylog)
% legend('Support Vector Machines','Location','Best')
% xlabel('False positive rate'); ylabel('True positive rate');
% title('ROC Curves for SVM')
% % hold off
% %}
% 
% [yFit,sFit] = kfoldPredict(CVSVMModel);
% [cfMat, order] = confusionmat(YY,yFit);
% 
% misclass1 = kfoldLoss(CVSVMModel);
% 
% TP = cfMat(1,1);
% FP = cfMat(2,1);
% TN = cfMat(2,2);
% FN = cfMat(1,2);
% 
% precision = TP / (TP + FP);
% recall = TP / (TP + FN);
% accuracy = (TP + TN) / (TP + FP + TN + FN);
% F_score = 2 * ((precision * recall) / (precision + recall));
% 
% header_string = 'SVM Classifier Cross-Validation Results'; 
% header_string2 = ['Date and Time: ', datestr(datetime('now'))];
% header_string3 = ['Number of Training Instances: ', num2str(length(CVSVMModel.Y))];
% header_string4 = ['Number of Testing Instances: ', num2str(length(yFit))];
% accuracy_string = ['SVM Accuracy: ', num2str(accuracy)];
% precision_string = ['SVM Precision: ', num2str(precision)];
% recall_string = ['SVM Recall: ', num2str(recall)];
% f_score_string = ['SVM F1 Score: ', num2str(F_score)];
% if(length(finalY) == 39660)
%     dataset_string = 'Dataset ID: I001_P002_D01';
% elseif(length(finalY) == 11385)
%     dataset_string = 'Dataset ID: I001_P005_D01';
% else
%     dataset_string = 'Dataset ID: I001_P010_D01';
% end
% results = char(header_string, header_string2, header_string3, accuracy_string, precision_string, ...
%     recall_string, f_score_string, dataset_string, header_string4);
% logResults(results, cfMat, costMatrix);
% toc
%% predict on all of EEG data
tic
[XTrain, YTrain, XTest, YTest] = getSampleData(finalX, finalY, percent);
costMatrix = [0,1;10,0];

SVMModel = fitcsvm(XTrain,YTrain,'Standardize',true,'Cost',costMatrix);
[yFit,sFit] = predict(SVMModel, XTest);
% finalYY = strcmp(finalY,'possible seizure');
[cfMat, order] = confusionmat(YTest,yFit);

TP = cfMat(1,1);
FP = cfMat(2,1);
TN = cfMat(2,2);
FN = cfMat(1,2);

precision = TP / (TP + FP);
recall = TP / (TP + FN);
accuracy = (TP + TN) / (TP + FP + TN + FN);
F_score = 2 * ((precision * recall) / (precision + recall));
% disp(['SVM CVAL Accuracy: ', num2str(accuracy)]); disp(['SVM Precision:
% ', num2str(precision)]); disp(['SVM Recall: ', num2str(recall)]);
% disp(['SVM F1 Score: ', num2str(F_score)]);

header_string = 'SVM Classifier Prediction Results'; 
header_string2 = ['Date and Time: ', datestr(datetime('now'))];
header_string3 = ['Number of Training Instances: ', num2str(length(SVMModel.Y))];
header_string4 = ['Number of Testing Instances: ', num2str(length(yFit))];
accuracy_string = ['SVM Accuracy: ', num2str(accuracy)];
precision_string = ['SVM Precision: ', num2str(precision)];
recall_string = ['SVM Recall: ', num2str(recall)];
f_score_string = ['SVM F1 Score: ', num2str(F_score)];
if(length(finalY) == 39660)
    dataset_string = 'Dataset ID: I001_P002_D01';
elseif(length(finalY) == 11385)
    dataset_string = 'Dataset ID: I001_P005_D01';
else
    dataset_string = 'Dataset ID: I001_P010_D01';
end
results = char(header_string, header_string2, header_string3, accuracy_string, precision_string, ...
    recall_string, f_score_string, dataset_string, header_string4);
logResults(results, cfMat, costMatrix);

toc