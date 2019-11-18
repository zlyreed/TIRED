function  [addOnTable,combinedTable]=addPairedTtest(SelectedTable,AlphaVal)

% Compare the begin vs. end of the parameter at the same location

% Use ttest(x,y,'alpha',0.5): paried t-test

% H=0; the null hypothesis that the data in x – y comes from a normal distribution with mean equal to zero and unknown variance, using the paired-sample t-test.
% The result h is 1 if the test rejects the null hypothesis at the 5% significance level, and 0 otherwise.


% Example inputs:
% SelectedTable=ave_BeginEnd_MVC30_fftTable;
% AlphaVal=0.05;


VarNames0=SelectedTable.Properties.VariableNames;
VarNames=VarNames0(1,1:2:length(VarNames0));

for vn=1:size(VarNames,2)
    
    SS=split(VarNames{1,vn},'_');
    
    if size(SS,1)==3
        
        LocPara_name=[SS{1,1} '_' SS{2,1}];  % name only with location and parameter
    else
        if size(SS,1)==2
            LocPara_name=SS{1,1};
        end
    end
    
    LocPara_name_B=[LocPara_name '_Begin'];
    LocPara_name_E=[LocPara_name '_End'];
    
    
    SampleColumn_B=eval(['SelectedTable.' LocPara_name_B ]);
    SampleColumn_E=eval(['SelectedTable.' LocPara_name_E ]);
    
    aveValue_B=mean(SampleColumn_B);
    SD_B=std(SampleColumn_B);
    
    aveValue_E=mean(SampleColumn_E);
    SD_E=std(SampleColumn_E);
    
    [h,p] = ttest(SampleColumn_B,SampleColumn_E,'alpha',AlphaVal);  % paired t test
    
    % put in a structure
    eval(['structTtest(1,1).' LocPara_name_B '=aveValue_B;'])
    eval(['structTtest(2,1).' LocPara_name_B '=SD_B;'])
    eval(['structTtest(3,1).' LocPara_name_B '=SD_B/aveValue_B*100;'])
    eval(['structTtest(4,1).' LocPara_name_B '=h;'])
    eval(['structTtest(5,1).' LocPara_name_B '=p;'])
    
    
    eval(['structTtest(1,1).' LocPara_name_E '=aveValue_E;'])
    eval(['structTtest(2,1).' LocPara_name_E '=SD_E;'])
    eval(['structTtest(3,1).' LocPara_name_E '=SD_E/aveValue_E*100;'])
    eval(['structTtest(4,1).' LocPara_name_E '=h;'])
    eval(['structTtest(5,1).' LocPara_name_E '=p;'])
    
end

addOnTable=struct2table(structTtest); % convert to a table

% add row names
rowN={'Average Value';'Standard Deviation';'coefficient of variation (%)';'h_pairedTtest';'p'};
addOnTable.Properties.RowNames=rowN;


combinedTable=[SelectedTable;addOnTable];

