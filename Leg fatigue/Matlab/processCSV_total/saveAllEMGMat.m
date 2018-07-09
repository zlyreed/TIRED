function saveAllEMGMat(Mat_cell,Trial_name,output_path)

%call functions:
% ---- 'ChannelData_select.m'

%% EMG data
ChannelName_EMG0='Noraxon Desk Receiver - EMG';
ChannelData_EMG1=ChannelData_select(Mat_cell,'Noraxon Desk Receiver - EMG1','v');

n_EMG=7; % obtain 7 EMG data
cell_EMG=cell(length(ChannelData_EMG1),n_EMG+1);
cell_EMG(:,1:2)=ChannelData_EMG1;

for en=2:n_EMG % get EMG2 to EMG7
    ChannelName_EMG=[ChannelName_EMG0 num2str(en)];
    ChannelData_EMG=ChannelData_select(Mat_cell,ChannelName_EMG,'v');
    cell_EMG(:,en+1)=ChannelData_EMG(:,2);
end

EMG_header=cell_EMG(1:2,:);
EMG_data=cell2mat(cell_EMG(3:end,:));

%save to mat file
save([output_path '\',Trial_name '_EMG_data.mat'],'EMG_data');
save([output_path '\' Trial_name '_EMG_header.mat'],'EMG_header');

end




