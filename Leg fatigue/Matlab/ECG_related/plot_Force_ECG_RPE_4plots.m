%% Align oximeter (semi-mannually), PRE, and Vicon force/event data (use Vicon time)
%-- Plot for each fatiguing trial
%-- save PRE, oximeter data into .mat files

clear all
close all
clc

file_path=pwd;
addpath([file_path '\functions']);

% load MVC force data
load MVC100_cell.mat

%locate subject files
[~,~,RAW_info]=xlsread('LegFatigueTesting_RPE_recording.xlsx','Info');

%%  ************Input the desired testing number (testingNo) to locate directory of the testing data ************
% for testingNo=16:21
    testingNo=21;
    TestData_path=RAW_info{testingNo+2,4};  % testing data diretory
    SubjectNo=RAW_info{testingNo+2,3}; % subject No
    TestingOrder=cell2mat(RAW_info(testingNo+2,5:8));  % the order for four fatiguing trials:'MVC30_Fatigue1','MVC30_Fatigue2','MVC60_Fatigue1','MVC60_Fatigue2'
    
    
    %% ------Fatigue trials----------
    TrialList={'MVC30_Fatigue1','MVC30_Fatigue2','MVC60_Fatigue1','MVC60_Fatigue2'};
    % trial Name
    for tn=1:size(TrialList,2)
        
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
        time_Bio=Data{1,1};
        RR_interval=Data{1,14};
        HR=Data{1,13};
        RespRate=Data{1,12};% Noraxon Desk Receiver.BIO 1 Respiration Rate, bpm
        SkinTemp=Data{1,11}; % 'Noraxon Desk Receiver.BIO 1 Temperature, °C'
        ECG=Data{1,10};  %'Noraxon Desk Receiver.BIO 1 ECG, uV'
        maxECG=max(ECG);
        Respiration=Data{1,9};  %'Noraxon Desk Receiver.BIO 1 Respiration, uV'
        maxResp=max(Respiration);
        %     maxER=max([maxECG maxResp]);
        
        % other information
        skinTemp=Data{1,11};  %'Noraxon Desk Receiver.BIO 1 Temperature, °C'
        
        
        figure(tn)
        subplot(4,1,2)
        plot(time_Bio,RR_interval,'b')
        hold on
        plot([Time_RPE19,Time_RPE19],[0,1000],'--m');
        xlabel ('Time (s)')
        ylabel( 'R-R interval (ms)')
        
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
        plot(time_Bio,ECG,'r');
        hold on
        plot([Time_RPE19,Time_RPE19],[0,maxECG],'--b');
        xlabel ('Time (s)')
        ylabel( 'ECG (uV) ')
        
        figure(tn)
        subplot(4,1,4)
        plot(time_Bio,Respiration,'b');
        hold on
        plot([Time_RPE19,Time_RPE19],[0,maxResp],'--m');
        xlabel ('Time (s)')
        ylabel( 'Respiration (uV) ')
        
        
        %% -----------------style of picture--------------
        timeLim=ceil(max(time_Bio))+0.2*ceil(max(time_Bio));
        
        figure(tn)
        subplot(4,1,1)
        xlim([0,timeLim]);
        ylim([0,100]);
        
        % plot title
        picTitle=['Testing' num2str(testingNo) '-Subject' num2str(SubjectNo)];
        picNamewTrial=[picTitle '_' TrialName];
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
        
        saveas(gcf,picNamewTrial,'jpg')
        
        
        
    end



% saveas(gcf,picTitle,'jpg')



