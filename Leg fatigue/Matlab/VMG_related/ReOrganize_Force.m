clear all
clc
close all

%% To create one cell to include all the VMG recording from SX
%  NOTE: The Subject number in her recording is actually Testing number,
%  which has been CORRECTED here (double check on the testing date.


%% Testing No is from 14 to 21 (subject No. is from 15 to 22)
currentDir=pwd();
[ndata, text, rawData_cell] = xlsread('SubjectInfo_ForceRPE.xlsx');

Force_Cell{1,1}='LegFatiguing_Force';
selectCols=[1:3,5:size(rawData_cell,2)];
Force_Cell(2,1:length(selectCols))=rawData_cell(2,selectCols);
Force_Cell(3:size(rawData_cell,1),1:3)=rawData_cell(3:size(rawData_cell,1),1:3);




for nt=3:size(rawData_cell,1) % locate to testing No level
    
    TestingNo=rawData_cell{nt,1};  % testing No.
    
    folder=[rawData_cell{nt,4} 'Vicon_Matlab']; % located to Vicon folder
    
    for trn=5:size(rawData_cell,2) %locate to trial level
        
        subTrial=eval(rawData_cell{nt,trn});
        ForceData0=cell(length(subTrial),1);
        for subtn=1:length(subTrial)  
            trialN=subTrial{subtn,1};
            
            if trn<9
                TrialFullName=[folder '\' trialN '_ForceEvent_data.mat'];  %locate to trial level
            else
                if trn>8
                    TrialFullName=[folder '\' trialN '_ForceEvent.mat'];
                end
            end
            
            
            if exist(TrialFullName,'file')>0
                load(TrialFullName);
                ForceData0{subtn,1}=ForceEvent_data;
            else
                % missing file
                warning(['Missing the .mat file: ' TrialFullName]);
                ForceData0{subtn,1}=nan;
            end         
            
            
        end
        %         ForceData=cell2mat(ForceData0);
        Force_Cell{nt,trn-1}=ForceData0;
        clear ForceData0
    end
    
end




for t1=3:size(rawData_cell,1)
    for t2= 4:7
        Force_Cell{t1,t2}=cell2mat(Force_Cell{t1,t2});
    end
end


save('T14_to_T21_ForceCell.mat','Force_Cell')
% % Force_FatiguingTrials_Cell=Force_Cell(1:end,1:7);
%
%
% %%
% save('Force_Cell_T14_to_T21.mat','Force_Cell','-v7.3')
% % save('Force_FatiguingTrials_Cell.mat','Force_FatiguingTrials_Cell')
%
