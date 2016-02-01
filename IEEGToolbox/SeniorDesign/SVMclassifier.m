%% SVM Classifier
% get data 

fileID = fopen('009586124_1_143873_[2015 6 13]_[5 0 43].bin'); 
A = fread(fileID, [18,inf]); 
A = A'; 
fclose(fileID); 

valsPerSec = length(A)/(5*60); %aka fs = sample rate
windowSize = 10; %size of window in seconds
valsPerWindow = round(valsPerSec * windowSize); 
numWindows = 5*60/10; 

results = zeros(numWindows,18);
energy = zeros(numWindows, 18);

for i = 1:numWindows
    
    startIndex = (i-1)*valsPerWindow + 1;
    disp(startIndex);
    endIndex = i*valsPerWindow; 
    disp(endIndex); 
    
    result = f_line_length(A,startIndex,endIndex,valsPerSec); 
    results(i,:) = result; 
    
    singleEnergy = f_energy(A, startIndex,endIndex,valsPerSec);
    energy(i,:) = singleEnergy; 

    disp('================'); 
end

% training data on first channel
energy1 = energy(1:15,1);
result1 = results(1:15,1);
X = [ result1 energy1 ];
Y = zeros(15,1); % TBD
%Y2 = ones(15,1);
%Y = [ Y ; Y2];
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

% test data on first channel

