function [t_pull,t_stop,t_19,duration,Win_begin,Win_end,Win_total]=selectedWindows(RPE_mat,buff,win_length)

% RPE_mat: information on event time stamps (time, label)
% buff: in seconds (the extra time added after pulling or exhausting), e.g., 5 seconds
% winLength: in seconds (the window length); e.g., 30 seconds or 1 min
% duration=t_19-t_pull


%% get the time stamp from RPE data
ind_pull=strcmp(RPE_mat(:,2),'pull');
t_pull=RPE_mat{ind_pull,1}; % time when subjects starts pulling

ind_stop=strcmp(RPE_mat(:,2),'stop');
t_stop=RPE_mat{ind_stop,1}; % time when subjects stop pulling


time_RPE=cell2mat(RPE_mat(3:end-1,:));
ind_19=time_RPE(:,2)==19;
t_19=time_RPE(ind_19,1); % time when subjects are fatigue (RPE=19; exhausting)

duration=t_19-t_pull;


%% pick the windows: beginning (add "buff" time after pulling) and ending (add "buff" after fatiguing)
% win_length=min([duration*0.2,maxWinLength]); % in second (long trial)

% if duration>2*60  %the duration is longer than 2 mins
    
    % -----------------select the beginning window-------------------
    Win_begin=[t_pull+buff,t_pull+buff+win_length];
    
    % ------------------ select the ending window-----------------
    if t_stop-t_19-buff>=win_length % if the fatigue state is long enough
        Win_end=[t_19,t_19+win_length];
    else
        Win_end=[t_stop-buff-win_length,t_stop-buff];  % if not long enough
    end
    
    
 Win_total=[Win_begin(1,1),Win_end(1,2)];   
    
% end
end