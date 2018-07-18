function [RPE_SectionedTable,RPE_ClassTable]=extractRPEclass(RPEcell,window_length ,window_overlap, fs)

% RPEcell=RPE_cell;
% window_length =5; % 5 second
% window_overlap=0; % in percentage; 0=no overlap, overlap=poisitive number (e.g., 50=50% of the window overlap);gap=negative number
% fs=1; % resampling frequency =1 

% class_rating=[0,10;10,16;16,25];
% class_setting={'light','hard','tired'};

class_rating=[0,12;16,25];
class_setting={'light','tired'};

time=cell2mat(RPEcell(2:end,1));

% Replace "pull" and "stop" instruction with the RPE values (5 and 21)
pk=find(strcmp(RPEcell(2:end,2),'pull')==1);
RPEcell{pk+1,2}=5;

sk=find(strcmp(RPEcell(2:end,2),'stop')==1);
RPEcell{sk+1,2}=21;

RPE_values=cell2mat(RPEcell(2:end,2));

% % linear fitting the RPE values and resample the data (time/RPE) 
samplePoints=floor(max(time)-min(time))*fs;  % total sample points for the data (integer)
pt = interparc(samplePoints,time,RPE_values,'linear'); % resampled
time_resampled=pt(:,1);
RPE_resampled=pt(:,2);

% figure(2)
% plot(time,RPE_values,'r*','MarkerSize',8)
% hold on
% plot(pt(:,1),pt(:,2),'b')
% plot(pt(:,1),pt(:,2),'gs')

% divide time into sections using window
overlap_length = window_length * window_overlap / 100;
step_length = window_length - overlap_length;
number_of_windows = floor( (size(pt,1) - overlap_length*fs) / (fs * step_length));

RPE_SectionedCell=cell(number_of_windows-1,2);
for iwin = 2:number_of_windows % starting from the second window
    current_start_sample = (iwin - 1) * fs * step_length + 1;
    current_end_sample = current_start_sample + window_length * fs - 1;
    current_signal = RPE_resampled(current_start_sample:current_end_sample)';
    current_time=time_resampled(current_start_sample:current_end_sample)';
    
    RPE_SectionedCell{iwin-1,1}=current_time;
    RPE_SectionedCell{iwin-1,2}=current_signal;
    
%     figure(2)
%     plot([current_time(1,1),current_time(1,1)],[0,5],'b--')
%     plot([current_time(end,1),current_time(end,1)],[0,5],'r')
    
    clear current_signal current_time    
end


RPE_ClassCell=cell(size(RPE_SectionedCell,1),3);
i=0;
for kn=1:size(RPE_SectionedCell,1)
%      average_time(kn,1)=mean(RPE_SectionedCell{kn,1});
    average_RPE=mean(RPE_SectionedCell{kn,2});
    
    for rk=1:size(class_rating,1)
        if average_RPE>=class_rating(rk,1)&& average_RPE<class_rating(rk,2)
            i=i+1;
            RPE_ClassCell{i,1}=min(RPE_SectionedCell{kn,1});
            RPE_ClassCell{i,2}=max(RPE_SectionedCell{kn,1});
            RPE_ClassCell{i,3}=class_setting{1,rk};       
            
        end
    end
    
end

RPE_ClassCell_new=RPE_ClassCell(1:i,:);  % only keep the rows with data


% convert cells to tables
RPE_SectionedTable=cell2table(RPE_SectionedCell,'VariableNames',{'TimePointsInSeconds_within_a_window','Interpolated_RPE'});

RPE_ClassTable=cell2table(RPE_ClassCell_new,'VariableNames',{'startingTime_second','endingTime_second','FatigueLevel'});
% RPE_ClassTable2=rmmissing(RPE_ClassTable);






