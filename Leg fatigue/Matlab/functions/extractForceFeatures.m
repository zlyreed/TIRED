function forceFeatureTable=extractForceFeatures(forceData,RPETable)

% forceData=ForceEvent_data;
% RPETable=RPE_ClassTable;

Time_force=forceData(:,1);  % time recorded in force data
nWindows=size(RPETable,1);

for k=1:nWindows
    startingTime=RPETable{k,1};
    endingTime=RPETable{k,2};
    
    kt=find(Time_force>=startingTime &Time_force<=endingTime);
    if isempty(kt)==0
        time_selected=forceData(kt,1);
        timeOffset=max(time_selected)-min(time_selected)-(endingTime-startingTime);
        
        force_selected=forceData(kt,2);
        
        force.forceMean(k,1)=mean(force_selected);
        force.forceSTD(k,1)=std(force_selected);
        force.forceCV(k,1)=force.forceSTD(k,1)/force.forceMean(k,1)*100; % Coefficient of variation (CV) in percentage
        force.timeOffset(k,1)=timeOffset;
    
    else
        force.forceMean(k,1)=[];
        force.forceSTD(k,1)=[];
        force.forceCV(k,1)=[];
        force.timeOffset(k,1)=endingTime-startingTime;
    end
end

forceFeatureTable=struct2table(force);
