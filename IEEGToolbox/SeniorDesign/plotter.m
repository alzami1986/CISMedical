function f = plotter(results, data)
    [M, N] = size(data); %M - rows, N - cols
    dataAvg = mean(data,2); 
    plot(dataAvg);
    hold on; 
    
    featureMean = mean(results,2); h
    plot(repelem(featureMean,M)); 
%     for i=1:N
%         plot(data(:,i));
%         hold on; 
%     end


% AA = results;
%     AB = results(:,2);
%     AC = results(:,3); 
%     AD = results(:,4);
%     AE = results(:,5);
%     AF = results(:,6); 
%     AG = results(:,7);
%     AH = results(:,8);
%     AI = results(:,9); 
%     AJ = results(:,10);
%     AK = results(:,11);
%     AL = results(:,12);
%     AM = results(:,13);
%     AN = results(:,14);
%     AO = results(:,15); 
%     AP = results(:,16);
%     AQ = results(:,17);
%     AR = results(:,18); 

 %   plot(AA);
%     hold on;
%     plot(AB); 
%     hold on ;
%     plot(AC); 
%     hold on;
%     plot(AD);
%     hold on;
%     plot(AE); 
%     hold on;
%     plot(AF); 
%     hold on ;
%     plot(AG);
%     hold on;
%     plot(AH); 
%     hold on;
%     plot(AI);
%     hold on;
%     plot(AJ); 
%     hold on;
%     plot(AK); 
%     hold on;
%     plot(AL);
%     hold on;
%     plot(AM); 
%     hold on;
%     plot(AN); 
%     hold on;
%     plot(AO);
%     hold on;
%     plot(AP); 
%     hold on;
%     plot(AQ); 
%     hold on;
%     plot(AR); 
end 

