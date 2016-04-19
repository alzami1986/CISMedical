function [XTrain, YTrain, XTest, YTest] = getSampleData(finalX, finalY, SeizurePercentage) 
if (SeizurePercentage == 0) 
    X = finalX;
    Y = logical(strcmp(finalY, 'possible seizure'));
    return;
end
finalYY = strcmp(finalY, 'possible seizure');
finalYY = logical(finalYY);
totalNumSeizures = nnz(finalYY);
nSeizuresToKeep = round(totalNumSeizures*(SeizurePercentage/100));
seizure_indices = find(finalYY,nSeizuresToKeep);
len = length(seizure_indices);
index = seizure_indices(len);
XTrain = finalX(1:index,:);
YTrain = finalYY(1:index);
XTest = finalX(index + 1:end,:);
YTest = finalYY(index + 1:end);
end
