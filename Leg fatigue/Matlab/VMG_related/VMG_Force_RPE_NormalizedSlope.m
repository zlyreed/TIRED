%% Obtain the grouped normalized slope results (table in .mat file)

clear all
close all
clc

currentDir=pwd;
addpath([currentDir '\functions']);
addpath([currentDir '\Testing14to21_VMG_results_mat']);


load  T14_to_T21_RPECell.mat


TrialList={'MVC30_Fatigue1','MVC30_Fatigue2','MVC60_Fatigue1','MVC60_Fatigue2'};

order=1;  % fit the order of the fitted function
step=0.1;  %  step in fitted time (e.g., step =0.1 s)

% select Begin and End windows
buff=5; % add 5-second buffer
win_length=30; % the length (in seconds) of the selected begin and end windows

slopeTotal_rmsTable=table();
slopeTotal_fftTable=table();
slopeTotal_MVC30_rmsTable=table();
slopeTotal_MVC60_rmsTable=table();
slopeTotal_MVC30_fftTable=table();
slopeTotal_MVC60_fftTable=table();


for tn=14:21 % testing No
% for tn=14:14
    TestingName=['Testing' num2str(tn)];

    
    for Nn=1:4

        %for Nn=1:1
        TrialName=TrialList{1,Nn};
        [T,R]=strtok(TrialName,'_'); % T='MVC30' or 'MVC60'
        PlotTitleName=[TestingName,'_',TrialName];  % e.g., 'Testing21_MVC60_Fatigue2'
        
          
        %% ******************** Obtain RPE for the trial ********************
        r_row=find(cell2mat(RPE_Cell(3:end,1))==tn)+2; % row of the desired testing No in RPE cell
        r_col=find(strcmp(TrialList{1,Nn},RPE_Cell(2,:))); % column of the desired trial in RPE cell
        RPE_mat=RPE_Cell{r_row,r_col}; % cell data for the trial
        RPE_time=cell2mat(RPE_mat(2:end,1));
        RPE_label=RPE_mat(2:end,2);
        
        %% ******************** load VMG fft and rms results ********************
        load([TestingName '_' TrialName '_VMG_fft.mat']);
        load([TestingName '_' TrialName '_VMG_rms.mat']);
        
        %% ******* obtain Begin, End and total windows
        [t_pull,t_stop,t_19,duration,Win_begin,Win_end,Win_total]=selectedWindows(RPE_mat,buff,win_length);
             
        
        %% slope of fitted Win_total data (normalized time= % of fatigue)
        % ******************** in Magnitude Domain *****************
        obtainFieldNames_rms=fieldnames(VMG_rms);
        
        for rmsK=2:size(obtainFieldNames_rms,1)
            y_rms_total=eval(['VMG_rms.' obtainFieldNames_rms{rmsK,1}]);
             
            % for slope_overall (normalized)
            x_time_normalized=(VMG_rms.time-Win_total(1,1))/(Win_total(1,2)-Win_total(1,1))*100; % ratio to 100% fatigue
            y_rms_struc_TotalWin=fittedWindow(x_time_normalized,y_rms_total,Win_total,step,order);
            eval(['slopeTotal_rmsStru.' obtainFieldNames_rms{rmsK,1} '= y_rms_struc_TotalWin.coefficients_function(1,1);'])
            
        end
        
     % for slope_total
        slopeTotal_rmsTab=struct2table(slopeTotal_rmsStru); % convert the struct to table
        slopeTotal_rmsTab.Properties.RowNames={PlotTitleName};  % add row names
        slopeTotal_rmsTable=[slopeTotal_rmsTable;slopeTotal_rmsTab];
        
        if strcmp(T,'MVC30')==1
            slopeTotal_MVC30_rmsTable=[slopeTotal_MVC30_rmsTable;slopeTotal_rmsTab];
        else
            slopeTotal_MVC60_rmsTable=[slopeTotal_MVC60_rmsTable;slopeTotal_rmsTab];
        end
        
        clear y_rms_total slopeTotal_rmsTab y_rms_struc_TotalWin
        
        % ****************** in Frequency Domain ********************
        obtainFieldNames_fft=fieldnames(VMG_fft);
        obtainVariableNames=VMG_fft.VMG_FatX_fft.Properties.VariableNames;
        
        for locI=1:size(obtainFieldNames_fft,1)
            fieldN=obtainFieldNames_fft{locI,1};
            
            locationN0= split(fieldN,'_');
            locationN=locationN0{2,1}; % get the location name, e.g.,'MuscleX'
            
            for varI=2:size(obtainVariableNames,2)
                variableN=obtainVariableNames{1,varI};
                y_fft_total=eval(['VMG_fft.' fieldN '.' variableN]);
                x_fft_time=eval(['VMG_fft.' fieldN '.time_fft']);
                x_fft_time_normalized=(x_fft_time-Win_total(1,1))/(Win_total(1,2)-Win_total(1,1))*100; % ratio to 100% fatigue
                
                % Slope Total
                y_fft_struc_TotalWin=fittedWindow(x_fft_time_normalized,y_fft_total,Win_total,step,order);
                
                eval(['slopeTotal_fftStru.' locationN '_' variableN '=y_fft_struc_TotalWin.coefficients_function(1,1);'])
                
            end
        end
        
        
        % slope_total
        slopeTotal_fftTab=struct2table(slopeTotal_fftStru);
        slopeTotal_fftTab.Properties.RowNames={PlotTitleName}; % add row name
        slopeTotal_fftTable=[slopeTotal_fftTable;slopeTotal_fftTab];
        
        if strcmp(T,'MVC30')==1
            slopeTotal_MVC30_fftTable=[slopeTotal_MVC30_fftTable;slopeTotal_fftTab];
        else
            slopeTotal_MVC60_fftTable=[slopeTotal_MVC60_fftTable;slopeTotal_fftTab];
        end        
        
        clear y_fft_total slopeTotal_fftTab y_fft_struc_TotalWin      
      
        
  
        
        
    end
end

% % save
save('slopeTotal_rmsTable_normalized.mat','slopeTotal_rmsTable');
save('slopeTotal_MVC30_rmsTable_normalized.mat','slopeTotal_MVC30_rmsTable');
save('slopeTotal_MVC60_rmsTable_normalized.mat','slopeTotal_MVC60_rmsTable');

save('slopeTotal_fftTable_normalized.mat','slopeTotal_fftTable');
save('slopeTotal_MVC30_fftTable_normalized.mat','slopeTotal_MVC30_fftTable');
save('slopeTotal_MVC60_fftTable_normalized.mat','slopeTotal_MVC60_fftTable');



