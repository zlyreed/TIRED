%% Align oximeter (semi-mannually), PRE, and Vicon force/event data (use Vicon time)
 %-- Plot for each fatiguing trial
 %-- save PRE, oximeter data into .mat files

clear all
close all
clc

file_path=pwd;
addpath([file_path '\functions']);

addpath('C:\Users\lwf5\Desktop\mhrv-master')

% load MVC force data
load MVC100_cell.mat

%locate subject files
[~,~,RAW_info]=xlsread('LegFatigueTesting_RPE_recording.xlsx','Info');

%%  ************Input the desired testing number (testingNo) to locate directory of the testing data ************
testingNo=20; 
TestData_path=RAW_info{testingNo+2,4};  % testing data diretory
SubjectNo=RAW_info{testingNo+2,3}; % subject No
TestingOrder=cell2mat(RAW_info(testingNo+2,5:8));  % the order for four fatiguing trials:'MVC30_Fatigue1','MVC30_Fatigue2','MVC60_Fatigue1','MVC60_Fatigue2' 


%% ------Fatigue trials----------
TrialList={'MVC30_Fatigue1','MVC30_Fatigue2','MVC60_Fatigue1','MVC60_Fatigue2'};
% trial Name
for tn=1:size(TrialList,2)
%for tn=1:2

    TrialOrder=TestingOrder(1,tn);
    TrialName=TrialList{1,tn};  % trial Name
    
    % open the corresponding trials
    [~,~,RAW_RPE]=xlsread('LegFatigueTesting_RPE_recording.xlsx',TrialName);  % open the corresponding trials in the excel file  
       
    %% -------------- Force and events ( Vicon ) -----------------------
    % get the number of the events and the correponding RPE or commands
    EventNo_a=eval(RAW_RPE{testingNo+2,6});
    EventNo=EventNo_a{1,1}:EventNo_a{2,1};
    RPE=eval(RAW_RPE{testingNo+2,7});
    
    MVC100_force=mean(cell2mat(MVC100_cell(testingNo+1,3:end)));
    
    % load force and event data (Vicon recorded)
    load([TestData_path 'Vicon_Matlab\' TrialName '_ForceEvent_header.mat']);
    load([TestData_path 'Vicon_Matlab\'  TrialName '_ForceEvent_data.mat']);
    
    ForceEvent_data=rmmissing(ForceEvent_data);
    time=ForceEvent_data(:,1);
    Force=ForceEvent_data(:,2);
    Event=ForceEvent_data(:,3);
    
    Force_per=Force/MVC100_force*100;  % percentage of Force wrt MVC100_Force (average MVC100 force)
    
    
    %%
    % get the time stamp (one point not a short period) for each event
    [time1,Event1,Time_events]=getTimeStampsofEvents(time,Event);
    % only time points with RPE values/numbers were selected
    RPE_selected=cell2mat(RPE(1,2:size(Time_events,1)-1));
    Time_events_selected=Time_events(2:end-1,1)';
    
   
    % figure (1)
    figure(tn)
    subplot(4,1,1)
    %plot(time,Force,'r')
    plot(time,Force_per,'r')
    hold on
    %     plot(time,Event,'b') %event pulse signal (max y=5)
    ylabel('Force-NIRS-RPE');
    xlabel('Time (s)');
    
    figure(tn)
    subplot(4,1,1)
    hold on
    plot(Time_events_selected,RPE_selected,'g') % plot RPE
    
    
    %label RPE value
    RPE_cell=cell(size(Time_events,1),2);
    RPE_cell{1,1}='time (s)';
    RPE_cell{1,2}='Rated Perceived Exertion ';
    for nt=1:length(Time_events)
        if RPE{1,nt}==19
            Time_RPE19=Time_events(nt,1);
            figure(tn)
            subplot(4,1,1)
             hold on
            plot([Time_events(nt,1),Time_events(nt,1)],[0,50],'--m');
        else
            figure(tn)
            subplot(4,1,1)
             hold on
            plot([Time_events(nt,1),Time_events(nt,1)],[0,8],'m');  %one-time stamp (lines) for each event
        end
        
        if isstring(RPE{1,nt})==1 %it is string
            text(Time_events(nt,1),10,RPE{1,nt});
        else
            text(Time_events(nt,1),10,num2str(RPE{1,nt})); % label the recorded RPE
        end
        
        RPE_cell{nt+1,1}=Time_events(nt,1);
        RPE_cell{nt+1,2}=RPE{1,nt};
        
    end
    
    
    % save RPE data to the mat file (in Vicon_Matlab folder)
    RPEfilename=[TestData_path 'Vicon_Matlab\' TrialName '_RPEData.mat'];
    save(RPEfilename,'RPE_cell');
    
    
    %% -------------- NIRS data ( oximeter) -----------------------
    % get oximeter file if available
    OxiName=RAW_RPE{testingNo+2,5};
    if isnan(OxiName)==1  % no oximeter data file
    else
        OxiFullName=[TestData_path 'OximeterData\' OxiName '.csv'];
        headlines=3;
        Timeheadlines=6;
        TimeColumn=2;
        timeformat=12;
        timeAdjust=0;
        Oxi_raw=readcellwTime(OxiFullName,headlines,Timeheadlines,TimeColumn,timeformat,timeAdjust);
        
        % get data from selected channels
        OxiEvent_col0=strcmp(Oxi_raw(2,:),'Events');
        OxiEvent_col=find(OxiEvent_col0==1);  % column index of "Events"
        
        OxiChannel1_col0=strcmp(Oxi_raw(1,:),'Channel 1');
        OxiChannel1_col=find(OxiChannel1_col0==1)+1;  % column index of "Channel 1"
        
        OxiChannel2_col0=strcmp(Oxi_raw(1,:),'Channel 2');
        OxiChannel2_col=find(OxiChannel2_col0==1)+1;  % column index of "Channel 2"
        
        headerNo_cell=Timeheadlines-headlines;
        OxiTime=cell2mat(Oxi_raw(headerNo_cell+1:end,TimeColumn));
        OxiChannel_1=cell2mat(Oxi_raw(headerNo_cell+1:end,OxiChannel1_col));
        OxiChannel_2=cell2mat(Oxi_raw(headerNo_cell+1:end,OxiChannel2_col));
        OxiChannel_1_ref=cell2mat(Oxi_raw(headerNo_cell+1:end,OxiChannel1_col-1));
        OxiChannel_2_ref=cell2mat(Oxi_raw(headerNo_cell+1:end,OxiChannel2_col-1));
        
        
        % Align the time in Oximeter to that in Vicon: Match "stop" (vicon event) label with the letter label in oximeter file
        event_vicon=eval(RAW_RPE{testingNo+2,8});
        event_Oxi=eval(RAW_RPE{testingNo+2,9});
        
        ViconLabel_selected='stop'; % the label selected for aligning data
        k_label0=strcmp(event_vicon,ViconLabel_selected);
        k_label=find(k_label0==1);
        OxiLabel_selected=event_Oxi{1,k_label};  % the selected label index in oximeter
        
        Oxi_selecetedrow0=strcmp(Oxi_raw(:,OxiEvent_col),OxiLabel_selected); %located the row of the selected label
        Oxi_selecetedrow=find(Oxi_selecetedrow0==1);
        Oxi_selectedTime=Oxi_raw{Oxi_selecetedrow,TimeColumn};
        
        v_label0=strcmp(RPE,ViconLabel_selected);
        v_label=find(v_label0==1);
        Vicon_selected=Time_events(v_label,1);
        
        offset_time=Oxi_selectedTime-Vicon_selected;
        OxiTime_aligned=OxiTime-offset_time; % get aligned/adjusted time in oximeter
        
        
        %get "pull" label in oximeter (double check the alignment)
        ViconLabel_selectedP='pull'; 
        p_label0=strcmp(event_vicon,ViconLabel_selectedP);
        p_label=find(p_label0==1);
        OxiLabel_selectedP=event_Oxi{1,p_label};  % the selected letter/label index in oximeter ("start pulling")
        
        Oxi_selecetedrowP0=strcmp(Oxi_raw(:,OxiEvent_col),OxiLabel_selectedP); %located the row of the selected label
        Oxi_selecetedrowP=find(Oxi_selecetedrowP0==1);
        if isempty(Oxi_selecetedrowP)==0
            Oxi_selectedTimeP=Oxi_raw{Oxi_selecetedrowP,TimeColumn}-offset_time;
            figure (tn)
            subplot(4,1,1)
            text(Oxi_selectedTimeP,15,ViconLabel_selectedP,'Color','red') %pull label in Oximeter
        end
        
        figure(tn)
        subplot(4,1,1)
        hold on
        plot(OxiTime_aligned,(OxiChannel_1-OxiChannel_1_ref)/OxiChannel_1_ref*100,'b') % cerebral oxygenation
        plot(OxiTime_aligned,(OxiChannel_2-OxiChannel_2_ref)/OxiChannel_2_ref*100,'k')  % muscle (rectus femoris) oxygenation
        
        %     plot(OxiTime_aligned,OxiChannel_1,'b--')
        %     plot(OxiTime_aligned,OxiChannel_2,'k--')
        
        % save oxymeter data in mat and save in Vicon_Matlab folder
        Oxifilename=[TestData_path 'Vicon_Matlab\' TrialName '_OximeterData.mat'];
        
        Oxi_cell(1,:)={'time(s)-aligned_with_Vicon','Channel1-Cerebral_reference','Channel1','Channel2-muscle_reference','Channel2'};
        Oxi_data=[OxiTime_aligned,OxiChannel_1_ref,OxiChannel_1,OxiChannel_2_ref,OxiChannel_2];
        Oxi_cell(2:size(Oxi_data,1)+1,1:size(Oxi_data,2))=num2cell(Oxi_data);
        save(Oxifilename,'Oxi_cell')
        
        
        %         %%print all other labels in oximeter  (when oximeter data dont seem align with Vicon data correctly)
        %         Label_oxi=Oxi_raw(headerNo_cell+1:end,OxiEvent_col);
        %         for lan=1:length(Label_oxi)
        %             if isnan(Label_oxi{lan,1})==0
        %                 plot([OxiTime_aligned(lan,1),OxiTime_aligned(lan,1)],[0,15],'c--');
        %                 text(OxiTime_aligned(lan,1),10,Label_oxi{lan,1},'Color','blue');
        %             end
        %         end
          
    end
    
    %% ---------------------- Biomonitor ----------------

    load([TestData_path 'Noraxon_mat\' TrialName '.mat']);
    
    %test hrv function
    window_seconds=10; %windon in seconds
    Freq_resample=50; %resampling rate (Hz)
    [HRV_total, tnn, nni]=hrv_table_fcn(Data,window_seconds,Freq_resample);
    
    %obtain numeric array for hrv parameters (e.g., hrv_AVNN)
    for hn=1:size(HRV_total.Properties.VariableNames,2)
        variableN=HRV_total.Properties.VariableNames{1,hn};
        eval(['hrv_' variableN '=HRV_total.' variableN ';']);
        
%         %% create figures
%         if hn>1  %no figure for Time
%            plot_var=figure('NumberTitle','off','Name',variableN);
%            eval(['plot_' num2str(hn-1) '=plot_var'])
%         
%         end
        
    end
   
        
    time_Bio=Data{1,1};
    RR_interval=Data{1,14};
    HR=Data{1,13};
    RespRate=Data{1,12};% Noraxon Desk Receiver.BIO 1 Respiration Rate, bpm
    SkinTemp=Data{1,11}; % 'Noraxon Desk Receiver.BIO 1 Temperature, °C'
    ECG=Data{1,10};  %'Noraxon Desk Receiver.BIO 1 ECG, uV'
    maxECG=max(ECG);
    Respiration=Data{1,9};  %'Noraxon Desk Receiver.BIO 1 Respiration, uV'
    maxResp=max(Respiration);
    skinTemp=Data{1,11};  %'Noraxon Desk Receiver.BIO 1 Temperature, °C'
   
     
    figure(tn)
    subplot(4,1,2)
%     plot(time_Bio,RR_interval/1000,'b')
    hold on 
    np(1,1)=plot(tnn,nni,'c');
    np(1,2)=plot( hrv_Time,hrv_AVNN/1000,'r');
    np(1,3)=plot(hrv_Time,hrv_SD1,'g--');
    np(1,4)=plot( hrv_Time,hrv_LF_POWER_LOMB,'k');
    np(1,5)=plot( hrv_Time,hrv_HF_POWER_LOMB,'b');
    
    plot([Time_RPE19,Time_RPE19],[0,max(nni)],'--m');
    legend(np,{'NNI_filtered and resampled','Aeraged NNI','SD1','LF_POWER_LOMB','HF_POWER_LOMB'},'interpreter','none')

    xlabel ('Time (s)')
    ylabel( 'R-R interval (s)')
    
%     figure(tn)
%     subplot(5,1,3)
%     p(1)=plot(time_Bio,HR,'r');
%     hold on 
%     p(2)=plot(time_Bio,RespRate,'g');
%     p(3)=plot(time_Bio,SkinTemp,'m');
%         
%     plot([Time_RPE19,Time_RPE19],[0,100],'--m');
%     xlabel ('Time (s)')
% %     ylabel( 'Hear Rate (bpm)')
%     legend(p,{'Heart Rate (bpm)','Respiration Rate (bpm)','Skin Temperature (°C)'});
    
     figure(tn)
     subplot(4,1,3)
     hold on  
     plot([Time_RPE19,Time_RPE19],[0,max(hrv_TOTAL_POWER_LOMB)],'--m'); 
     

     L1(1,1)=plot( hrv_Time,hrv_VLF_POWER_LOMB,'r');
     L1(1,2)=plot( hrv_Time,hrv_TOTAL_POWER_LOMB,'c');
     
     
     legend(L1,{'VLF_POWER_LOMB','TOTAL_POWER_LOMB'},'interpreter','none')
     xlabel ('Time (s)')
     ylabel( 'Frequency Domain')
    
%     plot(time_Bio,ECG,'r');     
%     hold on  
%     plot([Time_RPE19,Time_RPE19],[0,maxECG],'--b');
%     xlabel ('Time (s)')
%     ylabel( 'ECG (uV) ')
    
    figure(tn)
    subplot(4,1,4)
%     plot(time_Bio,Respiration,'b'); 
    hold on
    p(1,1)=plot( hrv_Time,hrv_SDNN,'r');
    p(1,2)=plot( hrv_Time,hrv_RMSSD,'k');     
    p(1,3)=plot(hrv_Time,hrv_SD2,'--b');
    p(1,4)=plot(hrv_Time,hrv_SEM,'g');
    p(1,5)=plot(hrv_Time,hrv_LF_TO_HF_LOMB, 'm');
    p(1,6)=plot(hrv_Time,hrv_SampEn,'c');

    
    plot([Time_RPE19,Time_RPE19],[0,max(hrv_SDNN)],'--m');
    
    legend(p,{'SDNN','RMSSD','SD2','SEM','LF_TO_HF_LOMB','SampEn'},'interpreter','none');
    xlabel ('Time (s)')
    ylabel( 'Time Domain and Nonlinear')
    
    
    %% -----------------style of picture--------------
    timeLim=ceil(max(time_Bio))+0.2*ceil(max(time_Bio));
    
    figure(tn)
    subplot(4,1,1)
    xlim([0,timeLim]);
    ylim([0,100]);
    
    % plot title
    picTitle=['Testing' num2str(testingNo) '-Subject' num2str(SubjectNo)];
    figure (tn)
    title([picTitle '_' TrialName '_TestingOrder=' num2str(TrialOrder)],'Interpreter','none');
    
    
    figure(tn)
    subplot(4,1,2)
    xlim([0,timeLim]);    
    set(gcf,'Color',[1,1,1])
    
    
    figure(tn)
    subplot(4,1,3)
    xlim([0,timeLim]);    
    set(gcf,'Color',[1,1,1])
    
    figure(tn)
    subplot(4,1,4)
    xlim([0,timeLim]);    
    set(gcf,'Color',[1,1,1])
    

    %% ------------------plot four trials in one figure-------------------------------
   
    for hp=1:size(HRV_total.Properties.VariableNames,2)-1 % not including Time 
        varName=HRV_total.Properties.VariableNames{1,hp+1};
        varValue=eval(['hrv_' varName]);
        MaxValue=max(varValue);
        
        figure(20+hp)
        hold on
        subplot(2,2,tn) 
        hold on
        plot( hrv_Time,varValue,'k');
        
        % label time
        plot([Time_RPE19,Time_RPE19],[0,1.1*MaxValue],'--m');   
        text(Time_RPE19,MaxValue/2,'19','Color','magenta'); % label "RPE=19"    
        text(Time_events(1,1),MaxValue/2,RPE{1,1},'Color','red'); % label "pull"  
        plot([Time_events(1,1),Time_events(1,1)],[0,1.1*MaxValue],'--r');   
        
        %format
        xlim([0,timeLim]); 
        if MaxValue>0
        ylim([0,MaxValue]);
        else
            if MaxValue<0
                 ylim([MaxValue,0]);
            end
        end
        
        ylabel(varName,'Interpreter','none');
        xlabel(['S' num2str(SubjectNo) '_' TrialList{1,tn} '_Test' num2str(TrialOrder)],'Interpreter','none')
        set(gcf,'Color',[1,1,1])
        hold on
        
%         clear  plot_var varName varValue
    end 
        
        
    
% %     figure('NumberTitle','off','Name','LF')
%     figure(22)
%     hold on
%     subplot(2,2,tn) 
%     hold on
%     plot( hrv_Time,hrv_LF_POWER_LOMB,'k');
%     
%     % label time
%     plot([Time_RPE19,Time_RPE19],[0,max(hrv_LF_POWER_LOMB)],'--m');   
%     text(Time_RPE19,max(hrv_LF_POWER_LOMB)/2,'19','Color','magenta'); % label "RPE=19"
%     
%     text(Time_events(1,1),max(hrv_LF_POWER_LOMB)/2,RPE{1,1},'Color','red'); % label "pull"  
%     plot([Time_events(1,1),Time_events(1,1)],[0,max(hrv_LF_POWER_LOMB)],'--r');   
%     
%     
%     xlim([0,timeLim]); 
%     ylim([0,2]);
%     ylabel('LF_POWER_LOMB','Interpreter','none');
%     xlabel([TrialList{1,tn} '_TestingOrder=' num2str(TrialOrder)],'Interpreter','none')
%     set(gcf,'Color',[1,1,1])
    
    
end

% figure(22)
% title(picTitle);

% saveas(gcf,picTitle,'jpg')



