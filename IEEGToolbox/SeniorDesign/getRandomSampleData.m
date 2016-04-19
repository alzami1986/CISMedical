function [X, Y] = getRandomSampleData(finalX, finalY, NumSamples) 
if (NumSamples == 0) 
    X = finalX;
    Y = logical(strcmp(finalY, 'possible seizure'));
    return;
end
finalYY = strcmp(finalY, 'possible seizure');
finalYY = logical(finalYY);
non_seizure_indices = not(finalYY);
seizure_indices = finalYY;
seizure_region_data = datasample(finalX(seizure_indices,:),NumSamples);
non_seizure_region_data = datasample(finalX(non_seizure_indices,:),NumSamples);
Y = [];
Y(1:NumSamples) = 1;
Y(NumSamples + 1:(NumSamples*2)) = 0;
Y = Y';
Y = logical(Y);
X = [seizure_region_data;non_seizure_region_data];
shuffle_indices = randperm(size(X,1));
Y = Y(shuffle_indices);
X = X(shuffle_indices,:);
end
