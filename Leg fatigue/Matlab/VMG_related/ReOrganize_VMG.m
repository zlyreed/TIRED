clear all
clc
close all

%% To create one cell to include all the VMG recording from SX
%  NOTE: The Subject number in her recording is actually Testing number,
%  which has been CORRECTED here (double check on the testing date.


%% Testing No is from 14 to 21 (subject No. is from 15 to 22)
currentDir=pwd();
[ndata, text, rawData_cell] = xlsread('SubjectInfo_VMG.xlsx');

VMG_Cell{1,1}='LegFatiguing_VMG';
VMG_Cell(2,1:size(rawData_cell,2))=rawData_cell(2,1:size(rawData_cell,2));
VMG_Cell(3:size(rawData_cell,1),1:3)=rawData_cell(3:size(rawData_cell,1),1:3);


% TestingNo=14:21;
% SubjectNo=TestingNo+1;
% FatiguingTrial_list={'MVC30_Fatigue1','MVC30_Fatigue2','MVC60_Fatigue1','MVC60_Fatigue2','MVC30_Fatigue1_1','MVC30_Fatigue1_2','MVC30_Fatigue2_1','MVC30_Fatigue2_2','MVC60_Fatigue1_1','MVC60_Fatigue1_2','MVC60_Fatigue2_1','MVC60_Fatigue2_2'};
% RefTrial_list={'Resting_1','Resting_2','MVC100_1a','MVC100_1b','MVC100_2a','MVC100_2b','MVC100_3a','MVC100_3b','MVC100_4a','MVC100_4b','MVC100_5a','MVC100_5b'};


for nt=3:size(rawData_cell,1) % locate to testing No level
    
    % for nt=1:1
    TestingNo=rawData_cell{nt,1};  % testing No.
    
    folder=[currentDir '\LegFatigueSubj' num2str(TestingNo)];
    
    for trn=4:size(rawData_cell,2) %locate to trial level
        %     for trn=1:1
        subTrial=eval(rawData_cell{nt,trn});
        VMGData0=cell(length(subTrial),1);
        for subtn=1:length(subTrial)  % VMG device only records less than 10-min, so there might be two VMG files for one trial
            trialFolder=subTrial{subtn,1};
            FatiguingTrialFolder=[folder '\' subTrial{subtn,1}];  %locate to trial level
            
            if exist(FatiguingTrialFolder,'dir')>0
                if exist([FatiguingTrialFolder '\VMGrawdata.mat'],'file')>0
                    load([FatiguingTrialFolder '\VMGrawdata.mat']);
                    VMGData0{subtn,1}=rawdata;
                else
                    % missing "VMGrawdata.mat" file
                    warning(['Missing VMGrawdata.mat file at ' FatiguingTrialFolder]);                    
                    VMGData0{subtn,1}=nan;
                end
                
            end
            
        end
        %         VMGData=cell2mat(VMGData0);
        VMG_Cell{nt,trn}=VMGData0;
        clear VMGData0
    end
    
end

for t1=3:size(rawData_cell,1)
    for t2= 4:7
        VMG_Cell{t1,t2}=cell2mat(VMG_Cell{t1,t2});
    end
end

% VMG_FatiguingTrials_Cell=VMG_Cell(1:end,1:7);


%% 
save('VMG_Cell_T14_to_T21.mat','VMG_Cell','-v7.3')
% save('VMG_FatiguingTrials_Cell.mat','VMG_FatiguingTrials_Cell')

