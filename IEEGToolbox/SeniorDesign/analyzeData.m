    
function [dataset,data_clip] = analyzeData(dataID, start, duration) 
    % session names to use are I001_P002_D01, I001_P005_D01, I001_P010_D01
    
    %open session, request one dataset
    %to open additional sets, use 
    %    session.openDataSet('I001_P002_D01')
    session_name = dataID; 
    session = IEEGSession(session_name, 'indaso', 'ind_ieeglogin');
    dataset = session.data;
    
    %pull 'duration' worth of data from given start in s
    data_clip = dataset.getvalues(start*1e6,duration*1e6, ':');
    
    layerNames = {dataset.annLayer.name};
%     ind=find(ismember(layerNames,'Seizure_CCS'));


    % use dataset.methods to see options
end

    
function dataset = pullDataSet(dataID) 
    % session names to use are I001_P002_D01, I001_P005_D01, I001_P010_D01
    
    %open session, request one dataset
    %to open additional sets, use 
    %    session.openDataSet('I001_P002_D01')
    session_name = dataID; 
    session = IEEGSession(session_name, 'indaso', 'ind_ieeglogin');
    dataset = session.data;
end

function data_clip = getDataClip(dataset,start,duration) 
        data_clip = dataset.getvalues(start*1e6,duration*1e6, ':');
end

