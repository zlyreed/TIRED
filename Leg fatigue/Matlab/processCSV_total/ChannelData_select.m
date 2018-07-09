function ChannelData_Selected=ChannelData_select(bigCell,Channel_Name,Frameline_Name)
% Notes: obtain the header and channel data for the selected channel (data
% was in numeric and saved in cell)

% ** this is specifically for csv file output from Vicon (normally
% there are 5 lines of header)

% Prerequisite: The big csv file (output from Vicon) has been processed and
% stored into a cell (i.e., 'bigMatfile' in Matlab space).

% ---bigMatfile: a cell with csv raw data
% -- Channel_Name (e.g., Channel_Name= 'BertecFP1-Force')
% -- Frameline_Name  (e.g.,Frameline_Name= 'Fy')

% % To test
% bigCell=Mat_cell;
% Channel_Name='Accelerometers - Acceleration';
% Frameline_Name='Ax1';

Frame_k=strcmp(bigCell(:,1),'Frame');
FrameRow=find(Frame_k==1);

for n=1:length(FrameRow) % there might be two options (max(n)=2)
    Frameline=FrameRow(n,1);    
    Channelline= Frameline-1;
    
    channel_sel_r=strcmp(bigCell(Channelline,:),Channel_Name);
    channel_sel_k=find(channel_sel_r==1); % make sure the channel name is unique (only one index here)
    
    if isempty(channel_sel_k)==0  % when the channel can be located first
        Unitline=Frameline+1;
        Dataline=Frameline+2;
        DataFr=str2double(bigCell{Frameline-2,1}); % data frequency
        
        Frameline_sel_r0=strcmp(bigCell(Frameline,channel_sel_k:size(bigCell,2)),Frameline_Name);  % could be several columns with the same Frameline_Name
        Frameline_sel_r=find(Frameline_sel_r0==1);
        Frameline_sel_k=channel_sel_k-1+Frameline_sel_r(1,1); % only pick the first existing one
        unit=bigCell{Unitline,Frameline_sel_k}; % unit
        Header={'Time',[Channel_Name,'-',Frameline_Name];'s',unit};
        
        if Frameline==max(FrameRow)  % the selected channel at the lower section of the mat file
            % data
            channelData_sel=bigCell(Dataline:end,Frameline_sel_k);
            Data_time=1/DataFr:1/DataFr:size(channelData_sel,1)/DataFr;
            
        else
            if Frameline<max(FrameRow) % the selected channel at the upper section of the mat file
                DataEndline=max(FrameRow)-5;
                % data
                channelData_sel=bigCell(Dataline:DataEndline,Frameline_sel_k);
                Data_time=1/DataFr:1/DataFr:size(channelData_sel,1)/DataFr;
            end
        end
        
        % Convert to numeric array
        % (try this later: channelData_sel=cellfun(@str2double,bigCell(Dataline:end,Frameline_sel_k));
        channelData_sel_num=zeros(size(channelData_sel));
        for ck=1:size(channelData_sel,1)
            channelData_sel_num(ck,1)=str2double(channelData_sel{ck,1});
        end
        
        % re-define event value
        if strcmp(Frameline_Name,'Event')==1
            Event0_num=channelData_sel_num; % event original values
            Event_num=Event0_num;
            Event_num(Event_num<4)=0;
            Event_num(Event_num>4)=5;
            
            channelData_sel_num=Event_num;
        end
        
        time_cell=num2cell(Data_time');
        TimeData_cell=[time_cell,num2cell(channelData_sel_num)];
        ChannelData_Selected=[Header;TimeData_cell];
    end
end




