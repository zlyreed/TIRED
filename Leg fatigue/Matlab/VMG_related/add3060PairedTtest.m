function  [Table3060,combinedTable]=add3060PairedTtest(SelectedTable30,SelectedTable60,AlphaVal)

% paired t-test for the same parameters of MVC30 vd. MVC60

% % e.g.,
% SelectedTable30=ave_slopeTotal_MVC30_fftTable;
% SelectedTable60=ave_slopeTotal_MVC60_fftTable;
% AlphaVal=0.05;

VarNames=SelectedTable30.Properties.VariableNames;
for vn=1:size(VarNames,2)   
    
    VarName30=[VarNames{1,vn} '_MVC30'];
    VarName60=[VarNames{1,vn} '_MVC60'];
    
    
    sample30=eval(['SelectedTable30.' VarNames{1,vn}]);
    sample60=eval(['SelectedTable60.' VarNames{1,vn}]);
    
    aveValue_sample30=mean(sample30);
    SD_sample30=std(sample30);
    
    aveValue_sample60=mean(sample60);
    SD_sample60=std(sample60);
    
    [h,p] = ttest(sample30,sample60,'alpha',AlphaVal);  % paried t test
    
    % create a MVC 30-60 data struct   
    eval(['struct3060.' VarName30 '=sample30;'])
    eval(['struct3060.' VarName60 '=sample60;'])
    
    % put in an add-on structure
    eval(['structTtest(1,1).' VarName30 '=aveValue_sample30;'])
    eval(['structTtest(2,1).' VarName30 '=SD_sample30;'])
    eval(['structTtest(3,1).' VarName30 '=SD_sample30/aveValue_sample30*100;'])
    eval(['structTtest(4,1).' VarName30 '=h;'])
    eval(['structTtest(5,1).' VarName30 '=p;'])

    
    eval(['structTtest(1,1).' VarName60 '=aveValue_sample60;'])
    eval(['structTtest(2,1).' VarName60 '=SD_sample60;'])
    eval(['structTtest(3,1).' VarName60 '=SD_sample60/aveValue_sample60*100;'])
    eval(['structTtest(4,1).' VarName60 '=h;'])
    eval(['structTtest(5,1).' VarName60 '=p;'])
    
    clear sample30 sample60 VarName30 VarName60
    
end

%% TABLE OF MVC30 and MVC 60 data
Table3060=struct2table(struct3060);
Row_testingN=cell(size(Table3060,1),1);
for rnn=1:size(Table3060,1)
    Row_testingN{rnn,1}=['Testing' num2str(13+rnn)];
end
Table3060.Properties.RowNames=Row_testingN;

%% add-on result table
addOnTable=struct2table(structTtest); % convert to a table
% add row names
rowN={'Average Value';'Standard Deviation';'coefficient of variation (%)';'h_MVC30MVC60_pairedTtest';'p'};
addOnTable.Properties.RowNames=rowN;

% combined table
combinedTable=[Table3060;addOnTable];