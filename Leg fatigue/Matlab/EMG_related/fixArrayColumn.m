function fixedArray=fixArrayColumn(Array,selectedCol,TargetCol,ReplaceCol)

%% notes
% seclectCol: 7;     % the selected Column
% TargetCol: 2;     % move the selected Column to the TargetCol
% ReplaceCol: 0    %replace the selected Column with "ReplaceCol" (e.g.,
% zeros)


%% new column for the replacement
newColumn=ones(size(Array,1),1)*ReplaceCol;

%% 
Array_1=Array;
Array_1(:,TargetCol)=Array(:,selectedCol);
Array_1(:,selectedCol)=newColumn;


fixedArray=Array_1;

end

