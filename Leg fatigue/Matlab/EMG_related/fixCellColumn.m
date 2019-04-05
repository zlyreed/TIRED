function fixedCell=fixCellColumn(Cell0,lengthInd,selectedCol,TargetCol,ReplaceCol)

%% notes
% lengthInd: (n1:n2) % the index for the selected length/lines
% seclectCol: 7;     % the selected Column
% TargetCol: 2;     % move the selected Column to the TargetCol
% ReplaceCol: 0    %replace the selected Column with "ReplaceCol" (e.g.,
% zeros)

% 4/3/2019
%% new column for the replacement
newColumn=num2cell(ones(size(lengthInd,2),1)*ReplaceCol);  % make it into cell

%% 
Cell_1=Cell0;
Cell_1(lengthInd,TargetCol)=Cell0(lengthInd,selectedCol);
Cell_1(lengthInd,selectedCol)=newColumn;


fixedCell=Cell_1;

end

