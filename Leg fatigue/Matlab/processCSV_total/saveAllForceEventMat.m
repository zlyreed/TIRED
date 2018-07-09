function saveAllForceEventMat(Mat_cell,Trial_name,output_path)

%call functions:
% ---- 'ChannelData_select.m'

%% force and event mat file

ChannelData_Fy=ChannelData_select(Mat_cell,'BertecFP_1 - Force','Fy');
ChannelData_Event=ChannelData_select(Mat_cell,'Event - Electric Potential','Event');

ForceEvent_header(1,:)={'Time','Pulling Force','Event'};
ForceEvent_header(2,:)={'s','N','v'};

ForeceEvent_data=[ChannelData_Fy(3:end,1:2),ChannelData_Event(3:end,2)];
cell_ForceEvent=[ForceEvent_header;ForeceEvent_data];

ForceEvent_header=cell_ForceEvent(1:2,:);
ForceEvent_data=cell2mat(cell_ForceEvent(3:end,:));

%save to mat file
save([output_path '\' Trial_name '_ForceEvent_data.mat'],'ForceEvent_data');
save([output_path '\' Trial_name '_ForceEvent_header.mat'],'ForceEvent_header');

%
end

