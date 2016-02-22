function f = plotter(energy,line_length, data)
    dataAvg = mean(data,2); 
    figure;
    plot(dataAvg);
    
    energyMean = mean(energy,2); 
    line_lengthMean = mean(line_length,2); 
    
    figure; 
    plot(line_lengthMean);
    
    figure;
    plot(energyMean);
    
end 

