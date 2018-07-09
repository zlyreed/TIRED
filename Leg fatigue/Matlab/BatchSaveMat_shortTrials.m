
clc;
close all;
clear all;

%%
addpath('C:\Program Files (x86)\Vicon\Nexus2.3\SDK\Matlab') % add the path where command "ViconNexus" and others are
vicon = ViconNexus();

%% Vicon Matlab Command Help
% vicon.DisplayCommandList
% vicon.DisplayCommandHelp('GetDeviceOutputDetails')

%% -----------------** Open a desired trial (make sure to input the correct Testing NO. ("testNo")**------------------------

[num,txt,raw]=xlsread('LegFatigueTesting_subjects info.xlsx'); % on the workstation
%[num,txt,raw]=xlsread('LegFatigueTesting_subjects info_laptop.xlsx'); %on the laptop

% run subjects one by one (make sure Vicon directory in the current subject)
testNo=17;  % the testing No.
subjectI=testNo+2; % the corresponding row in the raw cell

Trial_path=[raw{subjectI,4} '\'];
Output_path=[raw{subjectI,5} '\'];


% Only short trials were listed here (the code might not work for the long
% trials (e.g., 'MVC30_Fatigue1', which might be a 20-min trial with 1000-Hz EMG and 1500-Hz Acceleration data)
Trial_list={'Resting_1','Resting_2','MVC100_1a','MVC100_1b','MVC100_2a','MVC100_2b','MVC100_3a','MVC100_3b','MVC100_4a','MVC100_4b','MVC100_5a','MVC100_5b'};
% Trial_list={'MVC30_Fatigue1','MVC30_Fatigue2','MVC60_Fatigue1','MVC60_Fatigue2','Resting_1','Resting_2','MVC100_1','MVC100_2','MVC100_3','MVC100_4','MVC100_5','MVC100_1a','MVC100_1b','MVC100_2a','MVC100_2b','MVC100_3a','MVC100_3b','MVC100_4a','MVC100_4b','MVC100_5a','MVC100_5b'};


for k=1:size(Trial_list,2)
    
    Trial_name0=Trial_list{1,k};
    if exist([Trial_path Trial_name0 '.system'],'file')==0
        warning([Trial_name0 ' does not exist.']);
    else
        if exist([Trial_path Trial_name0 '.system'],'file')>0
            Trial_name=Trial_name0;
            vicon.OpenTrial([Trial_path Trial_name], 60);  % open a desired trial
            
            %% Obtain device information first
            deviceIDs = vicon.GetDeviceIDs();  % obtain all the device IDs
            if( numel(deviceIDs) > 0 )
                for i=1:numel(deviceIDs)
                    [deviceName, deviceType, deviceRate, ~, ~, ~] = vicon.GetDeviceDetails( deviceIDs(i) );
                    % get device ID for specific device
                    if strcmp(deviceName,'BertecFP_1')==1
                        deviceIDs_Force=deviceIDs(i);
                    else
                        if strncmp(deviceName,'Noraxon',6)==1
                            deviceIDs_EMG=deviceIDs(i);
                        else
                            if strcmp(deviceName,'Event')==1
                                deviceIDs_Event=deviceIDs(i);
                            else
                                if strcmp(deviceName,'Accelerometers')==1
                                    deviceIDs_Acce=deviceIDs(i);
                                end
                            end
                        end
                    end
                    
                    DeviceInfo = ['Device ID = ', num2str(deviceIDs(i)), ' Name: [', deviceName, '] is of type ', deviceType, ' running at a rate of ', num2str(deviceRate), ' Hz.' ];
                    display(DeviceInfo);
                end
            end
            
            %%  ******************** Force and Event data *****************
            %% Obtain force data from 'BertecFP_1' (deviceIDs_Force), one output and three force channels
            [name_FP, type_FP, ~, deviceOutputIDs_FP, forceplate_FP1, ~] = vicon.GetDeviceDetails( deviceIDs_Force )
            
            % force
            [name_F, type_F, unit_F, ~, channelNames_F, channelIDs_F] = vicon.GetDeviceOutputDetails(deviceIDs_Force, deviceOutputIDs_FP(1,1) )
            
            [F1Data, ~, rate_F] = vicon.GetDeviceChannel(deviceIDs_Force, deviceOutputIDs_FP(1,1), channelIDs_F(1,1) ); % Device2 (BertecFP_1),outputID1(Force),channel1(Fx)
            [F2Data, ~, ~] = vicon.GetDeviceChannel(deviceIDs_Force, deviceOutputIDs_FP(1,1), channelIDs_F(1,2) );
            [F3Data, ~, ~] = vicon.GetDeviceChannel(deviceIDs_Force, deviceOutputIDs_FP(1,1), channelIDs_F(1,3) );
            
            WR=reshape(forceplate_FP1.WorldR,3,3);  % rotation transforamtion from local/device CS to lab CS ?
            
            FR=[F1Data;F2Data;F3Data];
            
            F=WR'*FR;  % after applying transformation (from local CS to lab CS)
            
            FyData=F(2,:);  % Fy data
            Time_F=[1:1:length(FyData)]/rate_F;
            Data_Force=[Time_F;FyData]';  % time (second), Fy (Newton)
            
            clear name type rate
            
            %% Obtain event data: deviceIDs_Event; one output and one channel                                                                                                                                                                                                                                                                                                                                               one channel
            
            [DeviceNameEv, DeviceTypeEv, rateEv, deviceOutputIDsEv, forceplateEv, ~] = vicon.GetDeviceDetails( deviceIDs_Event )
            [OutputNameEv, OutputTypeEv, unit_Ev, ~, channelNamesEv, channelIDsEv] = vicon.GetDeviceOutputDetails(deviceIDs_Event, deviceOutputIDsEv(1) )
            
            [EventData0, ~, Evrate] = vicon.GetDeviceChannel(deviceIDs_Event, deviceOutputIDsEv(1), channelIDsEv(1,1) ); % Device9 (event),outputID(1),channels(1:1)
            EventData0(EventData0<4)=0;
            EventData0(EventData0>4)=5;
            
            EventData=EventData0';
            Data_ForceEvent=[Data_Force,EventData]; % combine with event data (time, force, event)
            
            ForceEvent_header(1,:)={'Time','Pulling Force','Event'};
            ForceEvent_header(2,:)={'s','N','v'};
            cell_ForceEvent=[ForceEvent_header;num2cell(Data_ForceEvent)];
            
            % save to mat file
            save([Output_path Trial_name '_ForceEvent.mat'],'cell_ForceEvent');
            
          
            
             %%  ******************** EMG *****************
%             %% Obatain EMG (DeviceIDs(7)=12);outputIDs 2:8--> EMG 1 to EMG7; one channel
%             [DeviceNameEMG, DeviceTypeEMG, rateEMG, deviceOutputIDsEMG, ~, ~] = vicon.GetDeviceDetails( deviceIDs_EMG )
%             
%             % outputIDs 2:8--> EMG 1 to EMG7
%             EMG_header{1,1}='Time';
%             EMG_header{2,1}='s';
%             EData=zeros(1,1);
%             for o_index=2:1:8
%                 [OutputNameE, OutputTypeE, unitE, ~, channelNamesE, channelIDsE] = vicon.GetDeviceOutputDetails(deviceIDs_EMG , deviceOutputIDsEMG(1,o_index) )
%                 EMG_header{1,o_index}=[OutputTypeE '/' OutputNameE];
%                 EMG_header{2,o_index}='v';
%                 
%                 [EData0, ~, Erate] = vicon.GetDeviceChannel(deviceIDs_EMG , deviceOutputIDsEMG(1,o_index), channelIDsE(1,1) );
%                 EData(1:length(EData0),o_index-1)=EData0';
%             end
%             
%             Time_EMG=[1:1:length(EData0)]/Erate;
%             Data_EMG=[Time_EMG',EData];
%             cell_EMG=[EMG_header;num2cell(Data_EMG)];
%             
%             % save to mat file
%             save([Output_path Trial_name '_EMG.mat'],'cell_EMG');
%             
            %%  ******************** Acceleration *****************
            %% Obtain Accelerometer data (deviceIDs_Acce), output ID=Acceleration; channel IDs=1:9
            [DeviceNameA, DeviceTypeA, rateA, deviceOutputIDsA, ~, ~] = vicon.GetDeviceDetails( deviceIDs_Acce )
            
            [OutputNameA, OutputTypeA, unitA, ~, channelNamesA, channelIDsA] = vicon.GetDeviceOutputDetails(deviceIDs_Acce, deviceOutputIDsA(1) )
            
            Acce_header=['Time',channelNamesA];
            Acce_header{2,1}='s';
            
            AcceD=zeros(1,size(channelIDsA,2));
            for i=1:size(channelIDsA,2)
                [AData, ~, Arate] = vicon.GetDeviceChannel(deviceIDs_Acce, deviceOutputIDsA(1), channelIDsA(1,i) ); % Device6 (Accelerometers),outputID1(Acceleration),channels(1:9)
                
                AcceD(1:length(AData),i)=AData';
                Acce_header{2,i+1}='mm/s2';
                
            end
            
            Time_Acc=[1:1:length(AData)]/Arate;
            Data_Acce=[Time_Acc',AcceD]; % [time,acceleration data]
            cell_Acceleration=[Acce_header;num2cell(Data_Acce)];
            
            % save to mat file
            save([Output_path Trial_name '_Acceleration.mat'],'cell_Acceleration');
        end
    end
    
end




