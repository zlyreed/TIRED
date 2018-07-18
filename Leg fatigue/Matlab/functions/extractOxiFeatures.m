function oxiFeatureTable=extractOxiFeatures(OxiCell,RPETable,fs)

% OxiCell=Oxi_cell;
% RPETable=RPE_ClassTable;
% fs=10;

Time_Oxi=cell2mat(OxiCell(2:end,1));  % time recorded in oximeter data
OxiData=cell2mat(OxiCell(2:end,2:5)); % in the order of refCerebral,Cerebral,refMuscle,Muscle
nWindows=size(RPETable,1); % the number of widowns selected in RPE data

% resample (with frenquency=fs)
samplePoints=floor(max(Time_Oxi)-min(Time_Oxi))*fs;   % total sample points for the data (integer)
resampledData=cell(1,size(OxiData,2));
OxiData_resampled=zeros(samplePoints,size(OxiData,2));
for rk=1:size(OxiData,2)
resampledData{1,rk} = interparc(samplePoints,Time_Oxi,OxiData(:,rk),'linear'); % resampled
OxiData_resampled(:,rk)=resampledData{1,rk}(:,2);
end
time_resampled=resampledData{1,1}(:,1);


for k=1:nWindows
    startingTime=RPETable{k,1};
    endingTime=RPETable{k,2};
    
    kt=find(time_resampled>=startingTime &time_resampled<=endingTime);
    if isempty(kt)==0
        time_selected=time_resampled(kt,1);
        timeOffset=max(time_selected)-min(time_selected)-(endingTime-startingTime);
        
        OxiData_selected=OxiData_resampled(kt,:);
        
%         Oxi.refOxiCerebral(k,1)=mean(OxiData_selected(:,1));
        Oxi.OxiCerebral_abs(k,1)=mean(OxiData_selected(:,2));
        Oxi.OxiCerebral_wrtRef_Pct(k,1)=mean(OxiData_selected(:,2)./OxiData_selected(:,1)*100);
        
%         Oxi.refOxiMuscle(k,1)=mean(OxiData_selected(:,3));
        Oxi.OxiMuscle_abs(k,1)=mean(OxiData_selected(:,4));
        Oxi.OxiMuscle_wrtRef_Pct(k,1)=mean(OxiData_selected(:,4)./OxiData_selected(:,3)*100);
        
        Oxi.timeOffset(k,1)=timeOffset;
    
    else  % no matched period was found               
        Oxi.timeOffset(k,1)=endingTime-startingTime;
    end
end

oxiFeatureTable=struct2table(Oxi);
end

% figure (1)
% plot(Time_Oxi,OxiData(:,1),'b--')
% hold on
% plot(Time_Oxi,OxiData(:,2),'b')
% plot(Time_Oxi,OxiData(:,3),'m--')
% plot(Time_Oxi,OxiData(:,4),'m')
% plot(time_resampled,OxiData_resampled(:,4),'c')
% ylim([0,200])


