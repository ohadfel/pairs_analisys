function [ cur_pair,trainSetBool,testSetBool ] = update_pair_data( cur_pair,cond36 ,cond37 ,test_validation_train, test_validation_train_ind )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

trainSetBool=zeros(length(cur_pair.diffs),1);
testSetBool=zeros(length(cur_pair.diffs),1);

trials_in_cond = cur_pair.trial(cur_pair.cond==36);
for mini_ind_check=1:length(trials_in_cond)
    temp_cur_set = cond36(cond36(:,1)==trials_in_cond(mini_ind_check),2);
    if sum(test_validation_train(test_validation_train_ind,:)==temp_cur_set)>0
        trainSetBool(mini_ind_check) = 1;
    else
        testSetBool(mini_ind_check) = 1;
    end
end

trials_in_cond1_len=length(trials_in_cond);

trials_in_cond = cur_pair.trial(cur_pair.cond==37);
for mini_ind_check=1:length(trials_in_cond)
    temp_cur_set = cond37(cond37(:,1)==trials_in_cond(mini_ind_check),2);
    if sum(test_validation_train(test_validation_train_ind,:)==temp_cur_set)>0
        trainSetBool(mini_ind_check+trials_in_cond1_len) = 2;
    else
        testSetBool(mini_ind_check+trials_in_cond1_len) = 2;
    end
end

cur_pair.diffsCond1Train = cur_pair.diffs(trainSetBool==1);
cur_pair.diffsCond2Train = cur_pair.diffs(trainSetBool==2);
cur_pair.partOfTestSet = testSetBool;
end

