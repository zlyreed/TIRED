function raw=readcellwTime(fullfilename,headlines,Timeheadlines,TimeColumn,timeformat,timeAdjust)

%% NOTES
% --- get a cell: converting time column into seconds, and removing unnecessary
% headers and empty or Nan lines (check channel 1 and channel 2 data).

% Inputs:
% fullfilename=[pathname filename];
% headlines= number of lines before the "real" data (with the header); e.g., headlines=3;
% Timeheadlines=number of lines before the data (without header); e.g.,Timeheadlines=6;
% TimeColumn=column index of time, e.g., TimeColumn=2;
% timeformat= 12 or 24; e.g., timeformat=12 (with "PM")
% timeAdjust=1*3600 (add 3600 seconds here);  % time ajustment in seconds (day light saving issue/different computer time setting)

% %% test
% clear all
% close all
% clc
% [filename, pathname] = uigetfile('*.csv', 'Pick csv files','MultiSelect', 'on');
% fullfilename=[pathname filename];
% headlines=3;
% Timeheadlines=6;
% TimeColumn=2;
% timeformat=12;
% timeAdjust=0;  %adjust time: one hour (3600 s) for sunlight saving

%% read .csv file using xlsread
[num0,~,raw0]=xlsread(fullfilename);


% Convert testing time into seconds
fid=fopen(fullfilename,'rt');

formatBeforeT='';
for n=1:TimeColumn-1
    if TimeColumn>=2
        formatBeforeT=[formatBeforeT, ' ', '%*s'];
        formatSpec = [formatBeforeT ' ', '%s %*[^\n]']; % only obtain the time column
    else
        formatSpec = [formatBeforeT, '%s %*[^\n]']; % only obtain the time column (Time is the first column)
    end
end

Time = textscan(fid,formatSpec,'HeaderLines',Timeheadlines,'Delimiter',','); % read time column only
fclose(fid);

Time_TotalCell=Time{1,1};

Time_second=cellfun(@(x) [3600 60 1]*sscanf(x,'%d:%d:%d'),Time_TotalCell);  % convert testing time into seconds

Time_second_adjusted=zeros(size(Time_TotalCell));

if timeformat==24
    raw0(Timeheadlines+1:end,TimeColumn)=num2cell(Time_second);
%     num0(:,2)=Time_second+timeAdjust;
    
else
    if timeformat==12
        for tk=1:size(Time_TotalCell,1)
            [~,R]=strtok(Time_TotalCell{tk,1},' ');
            [AmPm,~]=strtok(R,' '); % AmPm='AM' or 'PM'
            
            [A1,~]=strtok(Time_TotalCell{tk,1},':'); % hour =12 or not
            
            if strcmp(AmPm,'PM')==1&& str2double(A1)<12
                Time_second_adjusted(tk,1)=Time_second(tk,1)+12*3600;  % if PM
            else
                if strcmp(AmPm,'AM')==1&& str2double(A1)==12
                    Time_second_adjusted(tk,1)=Time_second(tk,1)+12*3600;  % if 12AM
                else
                    if strcmp(AmPm,'AM')==1&& str2double(A1)<12
                        Time_second_adjusted(tk,1)=Time_second(tk,1); % if AM
                    else
                        if strcmp(AmPm,'PM')==1&& str2double(A1)==12
                            Time_second_adjusted(tk,1)=Time_second(tk,1); % if 12PM
                        end
                    end
                end
            end
        end
        
        raw0(Timeheadlines+1:end,TimeColumn)=num2cell(Time_second_adjusted+timeAdjust);
%         num0(:,2)=Time_second_adjusted+timeAdjust;
        
        %     else
        %         msg='error: input 12 or 24';
        %         error(msg);
    end
end


% %% put into raw cell
% 
% raw_header=raw0(headlines+1:Timeheadlines,:); %get the header lines
% raw_header{size(raw_header,1),TimeColumn}='unit: seconds'; %change header of time to seconds
% raw_data0=raw0(Timeheadlines+1:end,:); % get the data cell
% 
% raw=[raw_header;raw_data0];  %combine header and data to a new cell

%% remove empty and Nan lines
raw_header=raw0(headlines+1:Timeheadlines,:); %get the header lines
raw_header{size(raw_header,1),TimeColumn}='unit: seconds'; %change header of time to seconds
raw_data0=raw0(Timeheadlines+1:end,:); % get the data cell


% num0_selec=num0(:,1:4);
% rowi=~any(isnan(num0_selec),2); %row index without NAN

% obtain channel 1 and 2 data, and remove NAN lines
 OxiChannel1_col0=strcmp(raw_header(1,:),'Channel 1');
 OxiChannel1_col=find(OxiChannel1_col0==1);  % column index of "Channel 1"

 OxiChannel2_col0=strcmp(raw_header(1,:),'Channel 2');
 OxiChannel2_col=find(OxiChannel2_col0==1);  % column index of "Channel 2"
        
 column_select=[OxiChannel1_col: OxiChannel1_col+2,OxiChannel2_col:OxiChannel2_col+2];
 rawdata_selec=raw_data0(:,column_select);
 A=cellfun(@isnumeric,rawdata_selec);  % find numeric cell content 
 rowi=find(sum(A,2)==size(column_select,2)); % each cell in the row has numeric content
%  rowi=~any(isnan(num0_selec),2); %row index without NAN '--'


raw_data=raw_data0(rowi,:); % data cells without rows including Nan
raw=[raw_header;raw_data];  %combine header and data to a new cell



