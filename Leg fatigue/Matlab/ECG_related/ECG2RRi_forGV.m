%% Recalculate RRi:  ECG --> detect QRS --> get R-R interval --> filter



clear all; close all; clc
currentPath=pwd;

%%Initializing mhrv toolbox
mhrv_init [-f/--force]

%% directory of the ECG data on network
%locate subject files
[~,~,RAW_info]=xlsread('LegFatigueTesting_RPE_recording.xlsx','Info');

%% Directory of the testing data (only looking at testing 12 to 21 with ECG data)
TrialList={'MVC30_Fatigue1','MVC30_Fatigue2','MVC60_Fatigue1','MVC60_Fatigue2'};

for testN=12:21
    testingNo=testN;
    TestData_path=RAW_info{testingNo+2,4};  % testing data diretory
    SubjectNo=RAW_info{testingNo+2,3}; % subject No
        
    % trial Name
    for tn=1:size(TrialList,2)
        TrialName=TrialList{1,tn};  % trial Name        
        
        load([TestData_path 'Noraxon_mat\'  TrialName '.mat']);
%         EMG_data=cell2mat(Data(1,1:8));  %[time, EMG1 to EMG7]
        
        time=Data{1,1}; % time (second)
        Fs=round(1/(time(2)-time(1))); % frequency
        RRi=Data{1,14}; %Noraxon Desk Receiver.BIO 1 R-R Interval, ms
        ECG=Data{1,10}; %Noraxon Desk Receiver.BIO 1 ECG, uV;
        
        %% use "\mhrv\ecg\jqrs.m" fucntion to calculate RR interval         
        % R peak location (indice)
        qrs_pos= jqrs(ECG,Fs,0.5,0.250,0);

        %R peak time and values
        peak_time=time(qrs_pos);
        peak_ecg=ECG(qrs_pos);
        
%         %  Method 1: RR interval time and values(trr and rri)
%         rri0=diff(peak_time);
%         trr0=peak_time(2:end);

        % RR interval time and values(trr and rri)
        trr=time(qrs_pos(2:end));  %time of rri starts from the second R peak location (use it due to the same way that the Biomonitor processed)
        rri=diff(qrs_pos)/Fs;

        % filter the calculated RRi
        [nni,tnn,~]=filtrr(rri,trr); %filter outlier
        
        
        %% plot to compare with RRi output from Biomonitor
        figure (2) % plot R peak detection results
        subplot(2,1,1)
        plot(time, ECG)
        xlabel('time (s)')
        ylabel('ECG (uV)')
        xlim([0,round(max(time))+5]);
        hold on
        plot(peak_time, peak_ecg,'rx');

        %compare with Biomonitor RRi output
        subplot(2,1,2)
        hold on
        p(1,1)=plot(time, RRi/1000,'k');
        xlabel('time (s)')
        ylabel('RRi(s)')

        %RRi_mhrv-calculated (jqrs)
        p(1,2)=plot(trr,rri,'bo');
        plot(trr,rri,'b')

        %'NNi: RRi_mhrv-calculated-filtered
        plot(tnn,nni,'m')
        p(1,3)=plot(tnn,nni,'mx');
        xlim([0,round(max(time))+5]);

        legend(p,{'RRi-Biomonitor','RRi-mhrv-calculated','NNi-mhrv-filtered'})
        
        % save to picture files
        picNamewTrial=['Subject' num2str(SubjectNo) '_' TrialName];
        
%         % save figure
%         figure(2)
%         set(gcf,'Color',[1,1,1])        
%         saveas(gcf,[currentPath '\db_GV\' picNamewTrial '.fig'])
        
       % save to mat file
        RRi_cell(1,1:3)={'Time (second)','NN interval (second): filtered RR intervals to get Normal-Normal (NN) intervals ','unfiltered RR interval (second)',};
        RRi_cell{2,1}=tnn;
        RRi_cell{2,2}=nni';
        RRi_cell{2,3}=rri';
        save([currentPath '\db_GV\' picNamewTrial '.mat'],'RRi_cell');              
        
               
        close all
        clear time Fs ECG RRi qrs_pos peak_time peak_ecg trr rri tnn nni
                
        
    end
    
    
end

        
               
%         sig=-ECG; %Noraxon Desk Receiver.BIO 1 ECG, uV;
%         adu='uV';
%         sg_name={'ECG'};
%         
%         TrialFullName=['S' num2str(SubjectNo),'_',TrialName]; % e.g., 'S13_MVC30_Fatigue1'
%         
%         cd('db_GV') % put all the wfdb format files in one folder 'db_GV'
%         mat2wfdb(sig,TrialFullName,Fs,[],adu,TrialName,[],sg_name)
%         cd(currentPath)
        
%         %% ####### correct the Biomonitor RRi output! (the RRi output doesnt seem rigt even after removing the interpolated step)
%         [time_BioCorrect,rri_BioCorrect]=rmvStep(time, RRi);
%         deltaBio=time_BioCorrect(2:end,1)-time_BioCorrect(1:end-1,1);
%         check_deltaBio=deltaBio-rri_BioCorrect(1:end-1,1)/1000;  %% make sure this value is equal to 0 ! (5/15/2019)
%         
%         % check correction
%         figure (4)
%         plot(time,RRi,'k')
%         hold on
%         plot(time_BioCorrect,rri_BioCorrect,'rx')
%         
        
  
        


