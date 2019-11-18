% Plot VMG (from SX) , force (% of MVC) and RPE data together
% ***** Generage individual rms and fft result .mat file for each trial ***


clear all
close all
clc

currentDir=pwd;
addpath([currentDir '\functions']);

%% load VMG, Force and RPE data; Load MVC100 force data for normalization
load T14_to_T21_VMGCell_FatiguingOnly.mat
load  T14_to_T21_ForceCell.mat
load  T14_to_T21_RPECell.mat
load MVC100_cell.mat

TrialList={'MVC30_Fatigue1','MVC30_Fatigue2','MVC60_Fatigue1','MVC60_Fatigue2'};
SamplingFq=8192;  % VMG sampling frequency

VMG_channels={'FatX','FatY','FatZ','MuscleX','MuscleY','MuscleZ','BoneX','BoneY','BoneZ'};
nChannel=size(VMG_channels,2);


%% for each test No/subject
for tn=14:21 % testing No
    % for tn=14:14 % testing No
    TestingName=['Testing' num2str(tn)];
    %% Obtain MVC100 force data
    MVC100_force=mean(cell2mat(MVC100_cell(tn+1,3:end)));
    
    %% for each fatiguing trial
    for Nn=1:4
        TrialName=TrialList{1,Nn};
        %%Obtain force for the trial
        f_row=find(cell2mat(Force_Cell(3:end,1))==tn)+2; % row of the desired testing No in Force Cell
        f_col=find(strcmp(TrialList{1,Nn},Force_Cell(2,:)));  % column of the desired trial in Force cell
        Force_mat=Force_Cell{f_row,f_col};
        Force_time=Force_mat(:,1);
        Force=Force_mat(:,2);
        Force_per=Force/MVC100_force*100; % force in percentage of the MVC value
        
        %% Obtain RPE for the trial
        r_row=find(cell2mat(RPE_Cell(3:end,1))==tn)+2; % row of the desired testing No in RPE cell
        r_col=find(strcmp(TrialList{1,Nn},RPE_Cell(2,:))); % column of the desired trial in RPE cell
        RPE_mat=RPE_Cell{r_row,r_col}; % cell data for the trial
        RPE_time=cell2mat(RPE_mat(2:end,1));
        RPE_label=RPE_mat(2:end,2);
        
        
        %% Obtain VMG for the trial
        v_row=find(cell2mat(VMG_Cell(3:end,1))==tn)+2; % row of the desired testing No in RPE cell
        v_col=find(strcmp(TrialList{1,Nn},VMG_Cell(2,:))); % column of the desired trial in RPE cell
        VMG_mat=VMG_Cell{v_row,v_col};  % 9 columns data: 3 locations (X,Y and Z)
        VMG_mat=detrend(VMG_mat);  % Remove polynomial trend
        
        filtVMG=VMG_filter(VMG_mat,SamplingFq); % filter VMG data
        VMG_time=1/SamplingFq:1/SamplingFq:length(filtVMG)/SamplingFq; % time (s)
        
        
        for nC=1:nChannel  % channel
            %% Time-domain (Magnitude)
            % Rectify and RMS VMG: look at Y and total (From SX)
            windowlength=SamplingFq*0.5; % 0.1second
            overlap=windowlength-1;
            zeropad=1;
            
            signalC=filtVMG(:,nC);
            VMG_rms.time=VMG_time';
            eval(['VMG_rms.' VMG_channels{1,nC} '=VMG_RecRms(signalC, windowlength, overlap, zeropad);']);
            
            
            %% Frequency-domain
            % % FFT with moving windows and steps (time-frequency)
            window=1; % 1 seconds
            step=0.1; % incremental step = 0.1 s
            t=VMG_time';
            
            totalStep=1:round(step*SamplingFq):length(t)-window*SamplingFq;
            NN=length(totalStep);
            
            
            % allocate space for results
            time_fft=zeros(NN,1);
            MedianFrequency=zeros(NN,1);
            MeanFrequency=zeros(NN,1);
            H2LRatio=zeros(NN,1);
            H2MRatio=zeros(NN,1);
            M2LRatio=zeros(NN,1);
            powerLow=zeros(NN,1);
            powerMed=zeros(NN,1);
            powerHigh=zeros(NN,1);
            i=0;
            for iw=1:round(step*SamplingFq):length(t)-window*SamplingFq  %index in "t"
                i=i+1;
                signalS=filtVMG(iw:iw+window*SamplingFq,nC);  % selected time and selected channel
                
                %median and mean frequency
                MedianFr=medfreq(signalS, SamplingFq);
                MeanFr=meanfreq(signalS, SamplingFq);
                
                % ratios of power
                powerL = bandpower(signalS, SamplingFq,[2 20]);
                powerM = bandpower(signalS, SamplingFq,[20 40]);
                powerH = bandpower(signalS, SamplingFq,[40 100]);
                H2Lratio=powerH/powerL;
                H2Mratio=powerH/powerM;
                M2Lratio=powerM/powerL;
                
                
                time_fft(i)=t(iw+window*SamplingFq/2,1);
                MedianFrequency(i)=MedianFr;
                MeanFrequency(i)=MeanFr;
                H2LRatio(i)=H2Lratio;
                H2MRatio(i)=H2Mratio;
                M2LRatio(i)=M2Lratio;
                powerLow(i)=powerL;
                powerMed(i)=powerM;
                powerHigh(i)=powerH;
               
                clear signalS
            end
            powerTotal=powerLow+powerMed+powerHigh;
            eval(['VMG_' VMG_channels{1,nC}, '_fft=table(time_fft,MedianFrequency,MeanFrequency,H2LRatio,H2MRatio,M2LRatio,powerLow,powerMed,powerHigh,powerTotal);']);
            clear time_fft MedianFrequency MeanFrequency H2LRatio H2MRatio M2LRatio powerLow powerMed powerHigh  powerTotal
            
        end
        
        
        
        %% plot
        PlotTitleName=[TestingName,'_',TrialName];
        
        %         %################
        %         figure(1) % RMS plots
        %         hold on
        %         % plot force
        %         pt(1)=plot(Force_time,Force_per/100,'k');
        %         %plot VMG total
        %         MuscleTotal=sqrt((VMG_rms.MuscleX).^2+(VMG_rms.MuscleY).^2+(VMG_rms.MuscleZ).^2);
        %         BoneTotal=sqrt((VMG_rms.BoneX).^2+(VMG_rms.BoneY).^2+(VMG_rms.BoneZ).^2);
        %         FatTotal=sqrt((VMG_rms.FatX).^2+(VMG_rms.FatY).^2+(VMG_rms.FatZ).^2);
        %         VMG_rms.MuscleTotal=MuscleTotal;
        %         VMG_rms.BoneTotal=BoneTotal;
        %         VMG_rms.FatTotal=FatTotal;
        %
        %         pt(2)=plot(VMG_rms.time,MuscleTotal,'r','linewidth',2);
        %         pt(3)=plot(VMG_rms.time,BoneTotal,'b','linewidth',2);
        %         pt(4)=plot(VMG_rms.time,FatTotal,'c','linewidth',2);
        %         % plot REP
        %         Ymax1=1;
        %         figureNo1=1;
        %         figPRE1=plotRPE(figureNo1, RPE_mat,Ymax1);
        %         % add legend
        %         legend(pt,{'Force (ratio to the MVC)','MuscleTotal_rms','BoneTotal_rms','FatTotal_rms'},'interpreter','none');
        %
        %        % save the plot
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
        %         pf(2)=plot(VMG_MuscleY_fft.time_fft,VMG_MuscleY_fft.MedianFrequency,'r','linewidth',2);
        %         pf(3)=plot(VMG_BoneY_fft.time_fft,VMG_BoneY_fft.MedianFrequency,'b','linewidth',2);
        %         pf(4)=plot(VMG_FatY_fft.time_fft,VMG_FatY_fft.MedianFrequency,'c','linewidth',2);
        %         % plot RPE
        %         Ymax2=100;
        %         figureNo2=2;
        %         figPRE2=plotRPE(figureNo2, RPE_mat,Ymax2); % plot RPE values
        %         legend(pf,{'Force (% of the MVC)','MuscleY_medianFr','BoneY_medianFr','FatY_medianFr'},'interpreter','none');
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
        %         pf(2)=plot(VMG_MuscleY_fft.time_fft,VMG_MuscleY_fft.H2LRatio,'r','linewidth',2);
        %         pf(3)=plot(VMG_BoneY_fft.time_fft,VMG_BoneY_fft.H2LRatio,'b','linewidth',2);
        %         pf(4)=plot(VMG_FatY_fft.time_fft,VMG_FatY_fft.H2LRatio,'c','linewidth',2);
        %         % plot RPE
        %         figPRE2=plotRPE(22, RPE_mat,1); % plot RPE values
        %         legend(pf,{'Force (ratio to the MVC)','MuscleY_H2LRatio','BoneY_H2LRatio','FatY_H2LRatio'},'interpreter','none');
        %         % save the plot
        %         title([PlotTitleName,'_H2LRatio_Y'],'interpreter','none')  %title
        %         set(gcf,'units','normalized','outerposition',[0 0 1 1])
        %         saveas(gcf,[PlotTitleName '_Y_H2LRatio.jpg'])
        %         clear pf
        %         close all
        %
        
        %% save results in mat file
        
        % add rms_total
        MuscleTotal=sqrt((VMG_rms.MuscleX).^2+(VMG_rms.MuscleY).^2+(VMG_rms.MuscleZ).^2);
        BoneTotal=sqrt((VMG_rms.BoneX).^2+(VMG_rms.BoneY).^2+(VMG_rms.BoneZ).^2);
        FatTotal=sqrt((VMG_rms.FatX).^2+(VMG_rms.FatY).^2+(VMG_rms.FatZ).^2);
        VMG_rms.MuscleTotal=MuscleTotal;
        VMG_rms.BoneTotal=BoneTotal;
        VMG_rms.FatTotal=FatTotal;
        
        % put fft data together
        VMG_fft=struct('VMG_FatX_fft',VMG_FatX_fft,'VMG_FatY_fft',VMG_FatY_fft,'VMG_FatZ_fft',VMG_FatZ_fft,'VMG_MuscleX_fft',VMG_MuscleX_fft,'VMG_MuscleY_fft',VMG_MuscleY_fft,'VMG_MuscleZ_fft',VMG_MuscleZ_fft,'VMG_BoneX_fft',VMG_BoneX_fft,'VMG_BoneY_fft',VMG_BoneY_fft,'VMG_BoneZ_fft',VMG_BoneZ_fft);
        
        save([PlotTitleName '_VMG_fft.mat'],'VMG_fft')
        save([PlotTitleName '_VMG_rms.mat'],'VMG_rms')
        clear VMG_fft VMG_rms
        
        
    end
    
end
