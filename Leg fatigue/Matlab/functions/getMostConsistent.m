function [timerange_cF,ConsistentF,minSD_F,timerange_aF,Max_AveF,minSD_maxF]=getMostConsistent(time,force,window)

%  window --> frame number: e.g., window=2000 (2 second @1000 Hz)


order=1:window/2:length(time)-window;
cell_F=cell(length(order),3);

i=0;
for k=1:window/2:length(time)-window
    i=i+1;
    selectedT=time(k:k+window-1,1);
    selectedF=force(k:k+window-1,1);
    
    Ave_F=mean(selectedF);
    SD_F=std(selectedF);
    Range_T=[min(selectedT),max(selectedT)];
    
    cell_F{i,1}=Range_T;
    cell_F{i,2}=Ave_F;
    cell_F{i,3}=SD_F;
end

% find the most consistent F for the "time" range
SDF_all=cell2mat(cell_F(:,3)); % SD for force
k=find(SDF_all==min(SDF_all));

timerange_cF=cell_F{k,1};
ConsistentF=cell_F{k,2};
minSD_F=cell_F{k,3};


% find the largest ave F for the "time" range
AveF_all=cell2mat(cell_F(:,2)); % average force
kv=find(abs(AveF_all)==max(abs(AveF_all)));

timerange_aF=cell_F{kv,1};
Max_AveF=cell_F{kv,2};
minSD_maxF=cell_F{kv,3};

