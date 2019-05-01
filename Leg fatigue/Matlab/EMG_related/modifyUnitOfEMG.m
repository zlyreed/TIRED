% Modify EMG unit (change EMG unit from "V" to "uV"): run this code in each
% subject's  "Vicon_Matlab" folder 

clear all
clc
close all

%% For large EMG data file that has "XXX_EMG_header.mat" and "XXX_EMG_data.mat"
FatigueTrial_names={'MVC30_Fatigue1','MVC30_Fatigue2','MVC60_Fatigue1','MVC60_Fatigue2'};

for fn=1:length(FatigueTrial_names)
    file_header=[FatigueTrial_names{1,fn} '_EMG_header.mat'];
    file_data=[FatigueTrial_names{1,fn} '_EMG_data.mat'];
    
    % for EMG_header and EMG_data
    if exist(file_header,'file')==2 % mat file
        load(file_header);
        load(file_data);
        
        if isempty(strfind(EMG_header{1,2},'-v'))==0 % check if need change            
            for n=2:size(EMG_header,2)
                channelName=EMG_header{1,n};
                ns=strfind(channelName,'-v');
                
                channelName_new=channelName(1:ns-1); % remove the unit in EMG channel name
                EMG_header{1,n}=channelName_new;
                EMG_header{2,n}='uV';
                
                %EMG data
                EMG_data(:,n)=EMG_data(:,n)*10^6; % the unit is changed to "uV"
            end
            % save files
            save(file_header,'EMG_header')
            save(file_data,'EMG_data')           
        end
    end 
    
    clear EMG_header EMG_data channelName channelName_new
end

%% for reference trial files (smaller files)
refer_fileNames={'Resting_1','Resting_2','MVC100_1','MVC100_1a','MVC100_1b','MVC100_2','MVC100_2a','MVC100_2b','MVC100_3','MVC100_3a','MVC100_3b','MVC100_4','MVC100_4a','MVC100_4b','MVC100_5','MVC100_5a','MVC100_5b'};

% For MVC100 and resting (reference) trials
for mn=1:size(refer_fileNames,2)
    ref_file=[refer_fileNames{1,mn} '_EMG.mat'];
    
    if exist(ref_file,'file')==2 % mat file exists
        load(ref_file);
        
        if strmatch(cell_EMG{2,2},'v')==1 % check if need change
            for en=2:size(cell_EMG,2)
                cell_EMG{2,en}='uV';
                EMGOnly_column=cell2mat(cell_EMG(3:end,en))*10^6;  % modify data to 'uV'
                cell_EMG(3:end,en)=num2cell(EMGOnly_column);
            end
            
            % save file
            save(ref_file,'cell_EMG');
            clear EMGOnly_column cell_EMG ref_file ref_file
        end
    end
    
end


