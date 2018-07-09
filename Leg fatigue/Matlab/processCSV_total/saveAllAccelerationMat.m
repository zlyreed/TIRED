function saveAllAccelerationMat(Mat_cell,Trial_name,output_path)

%call functions:
% ---- 'Channel_select.m'


%% Acceleration
ChannelName_Acce='Accelerometers - Acceleration';
Acce_direction={'Ax1','Ay1','Az1','Ax2','Ay2','Az2','Ax3','Ay3','Az3'};

ChannelData_Acc1=ChannelData_select(Mat_cell,ChannelName_Acce,Acce_direction{1,1});

cell_Acceleration=cell(size(ChannelData_Acc1,1),size(Acce_direction,2)+1);
cell_Acceleration(:,1:2)=ChannelData_Acc1;
cell_Acceleration{1,2}=Acce_direction{1,1};
cell_Acceleration{2,2}='mm/s2';

for cn=2:size(Acce_direction,2)
    ChannelData_Acc0=ChannelData_select(Mat_cell,ChannelName_Acce,Acce_direction{1,cn});
    cell_Acceleration(:,cn+1)=ChannelData_Acc0(:,2);
    cell_Acceleration{1,cn+1}=Acce_direction{1,cn};
    cell_Acceleration{2,cn+1}='mm/s2';
end

Acceleration_header=cell_Acceleration(1:2,:);
Acceleration_data=cell2mat(cell_Acceleration(3:end,:));

%save to mat file
save([output_path '\' Trial_name '_Acceleration_data.mat'],'Acceleration_data');
save([output_path '\' Trial_name '_Acceleration_header.mat'],'Acceleration_header');

end