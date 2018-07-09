clear all
close all
clc

file_path=pwd;
addpath([file_path '\functions']);


%locate subject files
[~,~,RAW_info]=xlsread('LegFatigueTesting_RPE_recording.xlsx','Info');

MVCList={'MVC100_before','MVC100_afterMVC30_Fatigue1','MVC100_afterMVC30_Fatigue2','MVC100_afterMVC60_Fatigue1','MVC100_afterMVC60_Fatigue2'};

totalTest=17;  % total testing number
MVC100_cell=cell(totalTest+1,length(MVCList)+2);
MVC100_cell{1,1}='Testing No.';
MVC100_cell{1,2}='Subject No.';
MVC100_cell(1,3:end)=MVCList; % put trial names

MVC100_cell2=MVC100_cell;

for testingNo=1:totalTest   
    
    TestData_path=RAW_info{testingNo+2,4};
    MVC100_cell{testingNo+1,1}=RAW_info{testingNo+2,1};  % testing No
    MVC100_cell{testingNo+1,2}=RAW_info{testingNo+2,3};  % subject No
    
    MVC100_cell2{testingNo+1,1}=MVC100_cell{testingNo+1,1};
    MVC100_cell2{testingNo+1,2}= MVC100_cell{testingNo+1,2};
     
    %% ---------- MVC trials ------------    
    for Mn=1:length(MVCList)
       
        MVC_sheetname=MVCList{1,Mn};
        % open the corresponding trials
        [~,~,RAW_MVCs]=xlsread('LegFatigueTesting_RPE_recording.xlsx',MVC_sheetname);
        MVC_trials=eval(RAW_MVCs{testingNo+2,6});  % MVC 100 trial name list
        
        MVC=zeros(1,length( MVC_trials));
        MVC2=zeros(1,length( MVC_trials));
        for MVCn=1:length( MVC_trials) % 1 or 2 trials
            %         for MVCn=1:1
            MVC_name0=MVC_trials{MVCn,1};
            load([TestData_path 'Vicon_Matlab\' MVC_name0 '_ForceEvent.mat']); % a mat file with header and data
            time0=cell2mat(cell_ForceEvent(3:end,1));
            force0=cell2mat(cell_ForceEvent(3:end,2));
            event0=cell2mat(cell_ForceEvent(3:end,3));
            
            if max(event0)>2  % there are two events input
                [time,event,timestamps,index_timestamps]=getTimeStampsofEvents(time0,event0);
                
                % assuming there are only two timestamps for the MVC trials (start
                % and stop activating muscles as hard as possbile)
                index_range=min(index_timestamps):max(index_timestamps);
                
            else
                if max(event0)==0  % when there no event input for MVC trial
                index_range=find(force0<mean(force0));
                end
            end
            
            window=1000; % 1 second if frequency=1000Hz
            
            [timerange_cF,ConsistentF,minSD_F,timerange_aF,Max_AveF,minSD_maxF]=getMostConsistent(time0(index_range,1),force0(index_range,1),window);
            
            MVC(1,MVCn)=Max_AveF; % use the max average F in a moving 1-second window
            
            MVC2(1,MVCn)=max(abs(force0));
        end
        
        MVC_ave=mean(MVC); % if there are two trials, MVC value is the averaged value.
        
        MVC_ave2=mean(MVC2);  % pick the absolute max value
        
        
        % write into the cell
        MVC100_cell{testingNo+1,Mn+2}=MVC_ave;
        
        MVC100_cell2{testingNo+1,Mn+2}=MVC_ave2;
    end
    
    
end

save('MVC100_cell.mat','MVC100_cell')

save('MVC100_cell_absoluteMax.mat','MVC100_cell2')
