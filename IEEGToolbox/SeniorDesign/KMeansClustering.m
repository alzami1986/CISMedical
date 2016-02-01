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
    endIndex = i*valsPerWindow;
    result = f_line_length(A,startIndex,endIndex,valsPerSec); 
    results(i,:) = result; 
    singleEnergy = f_energy(A, startIndex,endIndex,valsPerSec);
    energy(i,:) = singleEnergy; 

end

% training data on first channel
energy1 = energy(:,1);
result1 = results(:,1);
X = [ result1 energy1 ];

% original data plot

figure
plot(X(:,1),X(:,2),'k*','MarkerSize',5)
title 'Seizure Data';
xlabel('Line Length')
ylabel('Energy')

% k-means algorithm and plot
rng(1); % For reproducibility
[idx,C] = kmeans(X,3);

x1 = min(X(:,1)):100:max(X(:,1));
x2 = min(X(:,2)):100:max(X(:,2));
[x1G,x2G] = meshgrid(x1,x2);
XGrid = [x1G(:),x2G(:)]; % Defines a fine grid on the plot

idx2Region = kmeans(XGrid,3,'MaxIter',1000,'Start',C);...
    % Assigns each node in the grid to the closest centroid

figure;
gscatter(XGrid(:,1),XGrid(:,2),idx2Region,...
    [0,0.75,0.75;0.75,0,0.75;0.75,0.75,0],'..');
hold on;
plot(X(:,1),X(:,2),'k*','MarkerSize',5);
title 'K-Means Seizure Data';
xlabel 'Line Length';
ylabel 'Energy';
legend('Region 1','Region 2','Region 3','Data','Location','Best');
hold off;
