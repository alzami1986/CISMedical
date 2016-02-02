%% SVM Classifier
% get data 

% fileID = fopen('009586124_1_143873_[2015 6 13]_[5 0 43].bin'); 
% A = fread(fileID, [18,inf]); 
% A = A'; 
% fclose(fileID); 

start_time = 353251.55;
end_time = 353689.00;
[dataset,data_clip] = analyzeData('I001_P002_D01',start_time,600);

A = data_clip;
[M, N] = size(data_clip);

numMinutes = 10;
valsPerSec = length(A)/(numMinutes*60); %aka fs = sample rate
windowSize = 10; %size of window in seconds
valsPerWindow = round(valsPerSec * windowSize); 
numWindows = numMinutes*60/10; 

results = zeros(numWindows, N);
energy = zeros(numWindows, N);

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

