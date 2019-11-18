function aveTable=aveTrials(Table)

% 'Table' is a result table here, e.g., 'slopeTotal_MVC30_fftTable'
% Trial Number=2 only; % assuming there are two trials for each task

rnTotal=size(Table,1);

VarNames=Table.Properties.VariableNames;
RNames=Table.Properties.RowNames;

aveTable=Table(1:rnTotal/2,1:size(Table,2));
row_Ave=zeros(rnTotal/2,size(Table,2));


for rn=1:rnTotal/2 % row number
    
    rName=RNames{2*rn-1};
    rnNamecell=split(rName,'_');
    rNewName=[rnNamecell{1} '_' rnNamecell{2}];
    
    aveTable.Properties.RowNames(rn)={rNewName}; % give each row a new row name
    
    row_Ave(rn,:)=mean(Table{2*rn-1:2*rn,:},1);
    clear  rName rnNamecell rNewName
end

for cn=1:length(VarNames)
    eval(['aveTable.' VarNames{1,cn} '=row_Ave(:,cn);'])   % assign the ave data to each variable
end


end
