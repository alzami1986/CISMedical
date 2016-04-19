%% SVM Code
load finalXFullSignal
load finalYFullSignal

plotROC = false;
[XX,YY] = getSampleData(finalX, finalY, 4000);
finalYY = logical(strcmp(finalY, 'possible seizure'));
% finalYY = logical(1 - finalYY);
% YY = logical(1 - YY);

costMatrix = [0,1;1,0];
SVMModel = fitcsvm(XX,YY,'Standardize',true,'Cost',costMatrix);
mdlSVM = fitPosterior(SVMModel);
[~,score_svm] = resubPredict(mdlSVM);
if(plotROC)
    [Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(YY,score_svm(:,mdlSVM.ClassNames),1);
else
    [Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(YY,score_svm(:,mdlSVM.ClassNames),1,...
        'xCrit', 'reca', 'yCrit', 'prec');
end



% LOG Regression Code
% mdl = fitglm(XX,YY,'Distribution','binomial','Link','logit');
% score_log = mdl.Fitted.Probability; % Probability estimates
% if(plotROC)
%     [Xlog,Ylog,Tlog,AUClog] = perfcurve(YY,score_log,1);
% else
%     [Xlog,Ylog,Tlog,AUClog] = perfcurve(YY,score_log,1, 'xCrit', 'reca', 'yCrit', 'prec');
% end

% RUSBoost Code
rusTree = fitensemble(XX,YY,'RUSBoost',1000,t,...
    'LearnRate',0.1,'nprint',100,'Cost',cost);
[~,score_tree] = resubPredict(rusTree);
if(plotROC)
    [XTree,YTree,TTree,AUCTree] = perfcurve(YY,score_tree(:,rusTree.ClassNames),1);
else
    [XTree,YTree,TTree,AUCTree] = perfcurve(YY,score_tree(:,rusTree.ClassNames),1, 'xCrit', 'reca', 'yCrit', 'prec');
end

% LDA Code
MdlLinear = fitcdiscr(XX,YY);
[~,score_mdllinear] = resubPredict(MdlLinear);
if(plotROC)
    [Xlin,Ylin,Tlin,AUClin] = perfcurve(YY,score_mdllinear(:,MdlLinear.ClassNames),1);
else
    [Xlin,Ylin,Tlin,AUClin] = perfcurve(YY,score_mdllinear(:,MdlLinear.ClassNames),1, 'xCrit', 'reca', 'yCrit', 'prec');
end
figure
hold all
plot(Xsvm,Ysvm)
% plot(Xlog,Ylog)
plot(XTree,YTree)
plot(Xlin,Ylin)
axis([ 0.0 1.0 0.0 1.0])
% legend('Support Vector Machines','Logistic Regression','RUSBoost','LDA',...
%     'Location','Best')
legend('Support Vector Machines','RUSBoost','LDA',...
    'Location','Best')
if(plotROC)
    xlabel('False positive rate'); ylabel('True positive rate');
    title('ROC Curves for SVM, RUSBoost, LDA')
else
    xlabel('Recall'); ylabel('Precision')
    title('Precision-recall curves for SVM, RUSBoost, LDA')
end
hold off;
prec_rec(Xsvm,Ysvm);
prec_rec(XTree,YTree);
