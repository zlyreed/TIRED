clear all
close all
clc

% add function folder
file_path=pwd;
addpath([file_path '\functions']);
addpath([file_path '\functions\mi_0.912']);

%% Classification models
    load FeatureTable_all.mat
    
    % use 25% of the data for testing
    split_training_testing=cvpartition(FeatureTable_all.FatigueLevel,'Holdout',0.20);
    training_set=FeatureTable_all(split_training_testing.training,:);
    testing_set=FeatureTable_all(split_training_testing.test,:);
    
     grpstats_training=grpstats( training_set,'FatigueLevel','mean');
     
%      %% try mrmr feature selection
%      d=table2array(training_set(:,1:end-1));
%      f=table2array(training_set(:,end));
%      K=10;
%      [fea] = mrmr_miq_d(d, f, K)
% %       [fea] = mrmr_mid_d(d, f)
%      
    
    % Neighborhood component analysis (NCA)to pick "good" features
    n=size(training_set,1);    
    lambdavalues  = linspace(0,2,20)/size(training_set,1);

   % fatigue_mdl=fscnca(table2array(training_set(:,2:67)),table2array(training_set(:,68)),'FitMethod','exact','Lambda',0.001,'Verbose',0);
   fatigue_mdl=fscnca(table2array(FeatureTable_all(:,1:67)),table2array(FeatureTable_all(:,68)),'Lambda',0.005,'Verbose',0);

    selected_feature_indx=find(fatigue_mdl.FeatureWeights>0.2);
    
    %plot
    stem(fatigue_mdl.FeatureWeights,'bo');
    
    GoodFeatures=FeatureTable_all.Properties.VariableNames(selected_feature_indx);
    GoodFeatures_weights=fatigue_mdl.FeatureWeights(selected_feature_indx)';
    GoodFeatures_cell(2,:)=num2cell(GoodFeatures_weights);
    GoodFeatures_cell(1,:)=GoodFeatures;
    
    disp(FeatureTable_all.Properties.VariableNames(selected_feature_indx));
    
    %% with selected single or combined feature training set
%     
%     % with all selected feature
%     FeatureTable_FeatSel=[FeatureTable_all(:,selected_feature_indx),FeatureTable_all(:,end)];
%     
%     % only has EMG-related features
%     EMG_k=strncmp(GoodFeatures,'EMG',3);
%     EMG_FeatSel=GoodFeatures(1,EMG_k);    
%     EMG_FeatSel_Table=[FeatureTable_FeatSel(:,EMG_FeatSel),FeatureTable_all(:,end)]; 
%     
% %     save('EMG_FeatSel_Table.mat','EMG_FeatSel_Table');
%     
%     
%     % only has Acceleration-related features
%     Acceleration_k=strncmp(GoodFeatures,'Acceleration',12);
%     Acceleration_FeatSel=GoodFeatures(1,Acceleration_k);    
%     Acceleration_FeatSel_Table=[FeatureTable_FeatSel(:,Acceleration_FeatSel),FeatureTable_all(:,end)]; 
%     
% %     save('Acceleration_FeatSel_Table.mat','Acceleration_FeatSel_Table');
%     
%    
%     % only has Oxi-related features
%     Oxi_k=strncmp(GoodFeatures,'Oxi',3);
%     Oxi_FeatSel=GoodFeatures(1,Oxi_k);    
%     Oxi_FeatSel_Table=[FeatureTable_FeatSel(:,Oxi_FeatSel),FeatureTable_all(:,end)]; 
%     
% %     save('Oxi_FeatSel_Table.mat','Oxi_FeatSel_Table')
    


%%
    
%     %% After save the trained model ('trainedModel_fatigue') into the workspace!! and test it on testing dataset
%     yfit = trainedModel_fatigue.predictFcn(testingSet_features);
%     
%     comparison_class=[testing_set(:,end),yfit];
%     conf_mat_featsel=confusionmat(testing_set.FatigueLevel,yfit)
