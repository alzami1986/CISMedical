% load finalYFullSignal11
finalY = strcmp(finalY, 'possible seizure');
m = length(finalY);

Regions = [];
region.start = 0;
region.end = 0;
seen_one = false;

for i = 1:m
    if(not(seen_one) && finalY(i) == 1)
        region.start = i*10*1000;
        seen_one = true;
    end
    if(seen_one && finalY(i) == 0)
        region.end = i*10*1000;
        Regions = [ Regions; region ];
        seen_one = false;
    end
end
savejson('',Regions,'ActualSeizure.json');


% load YPred
finalY = yFit;
% finalY = strcmp(finalY, 'possible seizure');
m = length(finalY);

Regions = [];
region.start = 0;
region.end = 0;
seen_one = false;

for i = 1:m
    if(not(seen_one) && finalY(i) == 1)
        region.start = (i+33578)*10*1000; % put in ms
        seen_one = true;
    end
    if(seen_one && finalY(i) == 0)
        region.end = (i+33578)*10*1000; % put in ms
        Regions = [ Regions; region ];
        seen_one = false;
    end
end
opt.ArrayIndent = 0;
opt.SingletArray = 0;
opt.FileName = 'PredSeizure.json';
savejson('',Regions,opt);