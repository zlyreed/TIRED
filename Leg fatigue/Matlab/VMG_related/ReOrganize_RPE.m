clear all
clc
close all

%% To create one cell to include all the VMG recording from SX
%  NOTE: The Subject number in her recording is actually Testing number,
%  which has been CORRECTED here (double check on the testing date.


%% Testing No is from 14 to 21 (subject No. is from 15 to 22)
currentDir=pwd();
[ndata, text, rawData_cell] = xlsread('SubjectInfo_ForceRPE.xlsx');


RPE_Cell{1,1}='LegFatiguing_RPE';
selectCols2=[1:3,5:8];
RPE_Cell(2,1:length(selectCols2))=rawData_cell(2,selectCols2);
RPE_Cell(3:size(rawData_cell,1),1:3)=rawData_cell(3:size(rawData_cell,1),1:3);


for nt=3:size(rawData_cell,1) % locate to testing No level
    
    folder=[rawData_cell{nt,4} 'Vicon_Matlab']; % located to Vicon folder
    
    for trn=5:8 %locate to trial level
        
        subTrial=eval(rawData_cell{nt,trn});
       
        for subtn=1:length(subTrial)  % RPE device only records less than 10-min, so there might be two RPE files for one trial
            trialN=subTrial{subtn,1};           
            
            TrialFullName=[folder '\' trialN '_RPEData.mat'];  %locate to trial level          
            
            
            if exist(TrialFullName,'file')>0
                load(TrialFullName);
                
            else
                % missing file
                warning(['Missing the .mat file: ' TrialFullName]);
                RPE_cell=nan;
            end
            
            
        end
        %         RPEData=cell2mat(RPEData0);
        RPE_Cell{nt,trn-1}=RPE_cell;
        clear RPE_cell
    end
    
end

save('T14_to_T21_RPECell.mat','RPE_Cell')
