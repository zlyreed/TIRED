%% plot VMG results using processed VMG data with fitted slope
% save the grouped slope and begin/end data into a table  (.mat file)

clear all
close all
clc

currentDir=pwd;
addpath([currentDir '\functions']);
addpath([currentDir '\Testing14to21_VMG_results_mat']);

load  T14_to_T21_ForceCell.mat
load  T14_to_T21_RPECell.mat
load MVC100_cell.mat

TrialList={'MVC30_Fatigue1','MVC30_Fatigue2','MVC60_Fatigue1','MVC60_Fatigue2'};

order=1;  % fit the order of the fitted function
step=0.1;  %  step in fitted time (e.g., step =0.1 s)

% select Begin and End windows
buff=5; % add 5-second buffer
win_length=30; % the length (in seconds) of the selected begin and end windows


BeginEnd_rmsTable=table();
BeginEnd_MVC30_rmsTable=table();
BeginEnd_MVC60_rmsTable=table();

BeginEnd_fftTable=table();
BeginEnd_MVC30_fftTable=table();
BeginEnd_MVC60_fftTable=table();

slopeTotal_rmsTable=table();
slopeTotal_fftTable=table();
slopeTotal_MVC30_rmsTable=table();
slopeTotal_MVC60_rmsTable=table();
slopeTotal_MVC30_fftTable=table();
slopeTotal_MVC60_fftTable=table();


for tn=14:21 % testing No
    % for tn=14:14
    TestingName=['Testing' num2str(tn)];
    
    MVC100_force=mean(cell2mat(MVC100_cell(tn+1,3:end))); %Obtain MVC100 force data
    
    for Nn=1:4

        %for Nn=1:1
        TrialName=TrialList{1,Nn};
        [T,R]=strtok(TrialName,'_'); % T='MVC30' or 'MVC60'
        PlotTitleName=[TestingName,'_',TrialName];  % e.g., 'Testing21_MVC60_Fatigue2'
        
        %% ******************** Obtain force for the trial ********************
        f_row=find(cell2mat(Force_Cell(3:end,1))==tn)+2; % row of the desired testing No in Force Cell
        f_col=find(strcmp(TrialList{1,Nn},Force_Cell(2,:)));  % column of the desired trial in Force cell
        Force_mat=Force_Cell{f_row,f_col};
        Force_time=Force_mat(:,1);
        Force=Force_mat(:,2);
        Force_per=Force/MVC100_force*100; % force in percentage of the MVC value
        
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
     
        
        %% Begin vs. End Window && slope of fitted Win_total data
        % ******************** in Magnitude Domain *****************
        obtainFieldNames_rms=fieldnames(VMG_rms);
        
        for rmsK=2:size(obtainFieldNames_rms,1)
            y_rms_total=eval(['VMG_rms.' obtainFieldNames_rms{rmsK,1}]);
            y_rms_struc_BeginWin=fittedWindow(VMG_rms.time,y_rms_total,Win_begin,step,order); % in the begin window
            y_rms_struc_EndWin=fittedWindow(VMG_rms.time,y_rms_total,Win_end,step,order);  % in the end window
            win_end_mean=y_rms_struc_EndWin.window_mean;
            win_begin_mean=y_rms_struc_BeginWin.window_mean;
            
            % put into a struct
            eval(['BeginEnd_rmsStru.' obtainFieldNames_rms{rmsK,1} '_Begin = y_rms_struc_BeginWin.window_mean;'])
            eval(['BeginEnd_rmsStru.' obtainFieldNames_rms{rmsK,1} '_End = y_rms_struc_EndWin.window_mean;'])           
            
            %% for slope_overall
            y_rms_struc_TotalWin=fittedWindow(VMG_rms.time,y_rms_total,Win_total,step,order);
            eval(['slopeTotal_rmsStru.' obtainFieldNames_rms{rmsK,1} '= y_rms_struc_TotalWin.coefficients_function(1,1);'])
            
        end
        
        % add duration values
        slopeTotal_rmsStru.Duration_Pullto19=duration;
        slopeTotal_rmsStru.Duration_BegintoEndWindow=Win_total(1,2)-Win_total(1,1);
        
        % for Begin vs End window
        BeginEnd_rmsTab=struct2table(BeginEnd_rmsStru);   % convert the struct to table
        BeginEnd_rmsTab.Properties.RowNames={PlotTitleName};  % add row names
        BeginEnd_rmsTable=[BeginEnd_rmsTable;BeginEnd_rmsTab];
        
        if strcmp(T,'MVC30')==1
            BeginEnd_MVC30_rmsTable=[BeginEnd_MVC30_rmsTable;BeginEnd_rmsTab];
        else
            BeginEnd_MVC60_rmsTable=[BeginEnd_MVC60_rmsTable;BeginEnd_rmsTab];
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
        
        clear BeginEnd_rmsTab y_rms_total slopeTotal_rmsTab y_rms_struc_TotalWin
        
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
                
                % Begin vs. End
                y_fft_struc_BeginWin=fittedWindow(x_fft_time,y_fft_total,Win_begin,step,order);
                y_fft_struc_EndWin=fittedWindow(x_fft_time,y_fft_total,Win_end,step,order);
                
                eval(['BeginEnd_fft_Stru.' locationN '_' variableN '_Begin=y_fft_struc_BeginWin.window_mean;'])
                eval(['BeginEnd_fft_Stru.' locationN '_' variableN '_End=y_fft_struc_EndWin.window_mean;'])
                
                % Slope Total
                y_fft_struc_TotalWin=fittedWindow(x_fft_time,y_fft_total,Win_total,step,order);
                
                eval(['slopeTotal_fftStru.' locationN '_' variableN '=y_fft_struc_TotalWin.coefficients_function(1,1);'])
                
            end
        end
        
        % Begin vs. End
        BeginEnd_fft_Tab=struct2table(BeginEnd_fft_Stru);
        BeginEnd_fft_Tab.Properties.RowNames={PlotTitleName}; % add row name
        BeginEnd_fftTable=[BeginEnd_fftTable;BeginEnd_fft_Tab];
        
        if strcmp(T,'MVC30')==1
            BeginEnd_MVC30_fftTable=[BeginEnd_MVC30_fftTable;BeginEnd_fft_Tab];
        else
            BeginEnd_MVC60_fftTable=[BeginEnd_MVC60_fftTable;BeginEnd_fft_Tab];
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
        
        clear BeginEnd_fft_Tab y_fft_total slopeTotal_fftTab y_fft_struc_TotalWin      
      
        
        %% plot
        %         %################
        %         figure(1) % RMS plots
        %         hold on
        %         % plot force
        %         pt(1)=plot(Force_time,Force_per/100,'k');
        %         %plot VMG total
        %
        %         pt(2)=plot(VMG_rms.time,VMG_rms.MuscleTotal,'r','linewidth',2);
        %         pt(3)=plot(VMG_rms.time,VMG_rms.BoneTotal,'b','linewidth',2);
        %         pt(4)=plot(VMG_rms.time,VMG_rms.FatTotal,'c','linewidth',2);
        %         % plot REP
        %         Ymax1=1;
        %         figureNo1=1;
        %         figPRE1=plotRPE(figureNo1, RPE_mat,Ymax1);
        %
        %         % ***************** add fitted lines *************
        %         plot(rms_MuscleTotal_struc_TotalWin.time_fitted,rms_MuscleTotal_struc_TotalWin.signal_fitted,'k','linewidth',2);
        %         plot(rms_BoneTotal_struc_TotalWin.time_fitted,rms_BoneTotal_struc_TotalWin.signal_fitted,'k:','linewidth',2);
        %         plot(rms_FatTotal_struc_TotalWin.time_fitted,rms_FatTotal_struc_TotalWin.signal_fitted,'k--','linewidth',2);
        %
        %         % add legend
        %         legend(pt,{'Force (ratio to the MVC)','MuscleTotal_rms','BoneTotal_rms','FatTotal_rms'},'interpreter','none');
        %
        %
        %         % save the plot
        %         title([PlotTitleName,'_RMS_Total'],'interpreter','none')  %title
        %         set(gcf,'units','normalized','outerposition',[0 0 1 1])
        %         saveas(gcf,[PlotTitleName '_RMS_Total.jpg'])
        %         clear pt
        %
        %
        %         %################
        %         figure(11) % only plot Y direction RMS
        %         % plot force
        %         pt(1)=plot(Force_time,Force_per/100,'k');
        %         hold on
        %         % plot Y_rms
        %         pt(2)=plot(VMG_rms.time,VMG_rms.MuscleY,'r','linewidth',2);
        %         pt(3)=plot(VMG_rms.time,VMG_rms.BoneY,'b','linewidth',2);
        %         pt(4)=plot(VMG_rms.time,VMG_rms.FatY,'c','linewidth',2);
        %
        %         % plot REP
        %         figPRE11=plotRPE(11, RPE_mat,1);
        %         legend(pt,{'Force (ratio to the MVC)','MuscleY_rms','BoneY_rms','FatY_rms'},'interpreter','none');
        %
        %         % save the plot
        %         title([PlotTitleName,'_RMS_Y'],'interpreter','none')  %title
        %         set(gcf,'units','normalized','outerposition',[0 0 1 1])
        %         saveas(gcf,[PlotTitleName '_RMS_Y.jpg'])
        %
        %
        %         %################
        %         figure(2)% frequency-related plots
        %         % plot force
        %         pf(1)=plot(Force_time,Force_per,'k');
        %         hold on
        %         % plot median frequency
        %         pf(2)=plot(VMG_fft.VMG_MuscleY_fft.time_fft,VMG_fft.VMG_MuscleY_fft.MedianFrequency,'r','linewidth',2);
        %         pf(3)=plot(VMG_fft.VMG_BoneY_fft.time_fft,VMG_fft.VMG_BoneY_fft.MedianFrequency,'b','linewidth',2);
        %         pf(4)=plot(VMG_fft.VMG_FatY_fft.time_fft,VMG_fft.VMG_FatY_fft.MedianFrequency,'c','linewidth',2);
        %         % plot RPE
        %         Ymax2=100;
        %         figureNo2=2;
        %         figPRE2=plotRPE(figureNo2, RPE_mat,Ymax2); % plot RPE values
        %
        %         % ******** add fitted lines *******        %
        %         plot(fft_MuscleMedFr_struc_TotalWin.time_fitted,fft_MuscleMedFr_struc_TotalWin.signal_fitted,'k','linewidth',2);
        %         plot(fft_BoneMedFr_struc_TotalWin.time_fitted,fft_BoneMedFr_struc_TotalWin.signal_fitted,'k:','linewidth',2);
        %         plot(fft_FatMedFr_struc_TotalWin.time_fitted,fft_FatMedFr_struc_TotalWin.signal_fitted,'k--','linewidth',2);
        %
        %         legend(pf,{'Force (% of the MVC)','MuscleY_medianFr','BoneY_medianFr','FatY_medianFr'},'interpreter','none');
        %
        %         % save the plot
        %         title([PlotTitleName,'_medianFr_Y'],'interpreter','none')  %title
        %         set(gcf,'units','normalized','outerposition',[0 0 1 1])
        %         saveas(gcf,[PlotTitleName '_Y_medianFr.jpg'])
        %         clear pf
        %
        %         figure(22)
        %         % plot force
        %         pf(1)=plot(Force_time,Force_per/100,'k');
        %         hold on
        %         % plot median frequency
        %         pf(2)=plot(VMG_fft.VMG_MuscleY_fft.time_fft,VMG_fft.VMG_MuscleY_fft.H2LRatio,'r','linewidth',2);
        %         pf(3)=plot(VMG_fft.VMG_BoneY_fft.time_fft,VMG_fft.VMG_BoneY_fft.H2LRatio,'b','linewidth',2);
        %         pf(4)=plot(VMG_fft.VMG_FatY_fft.time_fft,VMG_fft.VMG_FatY_fft.H2LRatio,'c','linewidth',2);
        %         % plot RPE
        %         figPRE2=plotRPE(22, RPE_mat,1); % plot RPE values
        %         legend(pf,{'Force (ratio to the MVC)','MuscleY_H2LRatio','BoneY_H2LRatio','FatY_H2LRatio'},'interpreter','none');
        %
        %         % save the plot
        %         title([PlotTitleName,'_H2LRatio_Y'],'interpreter','none')  %title
        %         set(gcf,'units','normalized','outerposition',[0 0 1 1])
        %         saveas(gcf,[PlotTitleName '_Y_H2LRatio.jpg'])
        %         clear pf
        %         close all
        %
        
        
        
    end
end

%%  save the table to .mat files
save('BeginEnd_rmsTable.mat','BeginEnd_rmsTable');
save('BeginEnd_MVC30_rmsTable.mat','BeginEnd_MVC30_rmsTable');
save('BeginEnd_MVC60_rmsTable.mat','BeginEnd_MVC60_rmsTable');

save('BeginEnd_fftTable.mat','BeginEnd_fftTable');
save('BeginEnd_MVC30_fftTable.mat','BeginEnd_MVC30_fftTable');
save('BeginEnd_MVC60_fftTable.mat','BeginEnd_MVC60_fftTable');

save('slopeTotal_rmsTable.mat','slopeTotal_rmsTable');
save('slopeTotal_MVC30_rmsTable.mat','slopeTotal_MVC30_rmsTable');
save('slopeTotal_MVC60_rmsTable.mat','slopeTotal_MVC60_rmsTable');

save('slopeTotal_fftTable.mat','slopeTotal_fftTable');
save('slopeTotal_MVC30_fftTable.mat','slopeTotal_MVC30_fftTable');
save('slopeTotal_MVC60_fftTable.mat','slopeTotal_MVC60_fftTable');





