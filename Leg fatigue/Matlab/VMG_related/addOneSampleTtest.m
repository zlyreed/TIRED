function  [addOnTable,combinedTable]=addOneSampleTtest(SelectedTable,MeanAve)

% add one-sample test result to the table
% normally "mean"=0
% the null hypothesis that the data comes from a normal distribution with
% mean equal to zero (or "mean') and unknown variance.
% The result h is 1 if the test rejects the null hypothesis at the 5% significance level, and 0 otherwise.

% SelectedTable=ave_slopeTotal_MVC30_fftTable;
% MeanAve=0;


VarNames=SelectedTable.Properties.VariableNames;

for vn=1:size(VarNames,2)
    
    SampleColumn=eval(['SelectedTable.' VarNames{1,vn}]);
    
    aveValue=mean(SampleColumn);
    SD=std(SampleColumn);
    
    [h,p] = ttest(SampleColumn,MeanAve);  % one-sampe t test    
    
    % put in a structure
    eval(['structTtest(1,1).' VarNames{1,vn} '=aveValue;'])
    eval(['structTtest(2,1).' VarNames{1,vn} '=SD;'])
    eval(['structTtest(3,1).' VarNames{1,vn} '=SD/aveValue*100;'])
    eval(['structTtest(4,1).' VarNames{1,vn} '=h;'])
    eval(['structTtest(5,1).' VarNames{1,vn} '=p;'])
    
end

addOnTable=struct2table(structTtest); % convert to a table

% add row names
rowN={'Average Value';'Standard Deviation';'coefficient of variation (%)';'h_OneSample_Ttest';'p'};
addOnTable.Properties.RowNames=rowN;

% addOnTable.Properties.RowNames(1)={'Average Value'};
% addOnTable.Properties.RowNames(2)={'Standard Deviation'};
% addOnTable.Properties.RowNames(3)={'coefficient of variation (%)'};
% addOnTable.Properties.RowNames(4)={'h'};
% addOnTable.Properties.RowNames(5)={'p'};

combinedTable=[SelectedTable;addOnTable];

