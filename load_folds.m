function [ four_folds_data ] = load_folds( test_validation_train,test_validation_train_ind,pairsData )
%loadFolds( test_validation_train,test_validation_train_ind )
%   the function loads the files of the folds that were created with
%   /media/ohadfel/New Volume/Copy/Baus/Code/matlab/Pairs_analysis/new_mann_whitney_test.m
%   and return the pvalues per pair per fold
four_folds_data = nan(length(pairsData),4);

inner_counter = 0;
for validation_ind = 1:4
    inner_counter = inner_counter + 1;
    validation_group = test_validation_train(test_validation_train_ind,validation_ind);
    train_group = setdiff(test_validation_train(test_validation_train_ind,:),validation_group);
    str_name = [num2str(train_group(1)),'_',num2str(train_group(2)),'_',num2str(train_group(3))];
    file_to_load_str = ['uTestAllFolds',str_name,'.mat'];
    load(file_to_load_str);
    four_folds_data(:,inner_counter)=pairsNPs(:,3);
end


end

