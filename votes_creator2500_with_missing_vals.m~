addpath('/media/ohadfel/New Volume/Copy/Baus/Code/matlab/Pairs_analysis/new_organized_code')
cd('/media/ohadfel/New Volume/Copy/Baus/Code/matlab/Pairs_analysis')
load('pairsDataN.mat');
load('prior_delays.mat');
prior_delays=prior_delays/190;
%%
fold_num=1;
num_of_folds = 1;
pre_str_save_name = '11votes';
hyper_split_arr = 1:25;
to_plot=0;
super_to_plot = 1;

%%
minNumOfRepetions=5;
croosValAccuracyInd = 0;

num_of_pairs_to_use_for_voting_arr = [15000];

final_votes = nan(num_of_pairs_to_use_for_voting_arr(1),200,5);
final_votes_counter = zeros(size(final_votes));
final_votes_ind_counter=1;
class_vec = nan(size(final_votes,3),size(final_votes,2));
band_width_conds = nan(num_of_pairs_to_use_for_voting_arr(1),2);

all_folds = 1:5;
test_validation_train=nchoosek(1:5,4);
last_ind_accuracys = 1;
load('prior_delays2.mat');
prior_delays_orig = prior_delays;
for hyper_split_ind = 1:size(hyper_split_arr,2)
%     if mod(hyper_split_ind,num_of_folds)+1~=fold_num
%         continue
%     end
    disp(['hyper_split_ind = ',num2str(hyper_split_ind)]);
    
    final_votes = nan(num_of_pairs_to_use_for_voting_arr(1),200,5);
    final_votes_counter = zeros(size(final_votes));
    final_votes_ind_counter=1;
    class_vec = nan(size(final_votes,3),size(final_votes,2));
    
    four_folds_data = nan(length(pairsData),4);
    cd(['hyperFoldNum',num2str(hyper_split_ind)])
    addpath('..')
    load('folds_splits.mat');
    %%
    for test_validation_train_ind = 1:length(test_validation_train)
        cur_fold_in_testset = length(test_validation_train)+1-test_validation_train_ind;
        trials_36_in_fold = cond36(cond36(:,2)==cur_fold_in_testset,1);
        trials_37_in_fold = cond37(cond37(:,2)==cur_fold_in_testset,1);
        trials_37_in_fold_modified = trials_37_in_fold+100;
        class_vec(test_validation_train_ind,[trials_36_in_fold;trials_37_in_fold_modified])=0;
        %         class_vec(test_validation_train_ind,)
        
        four_folds_data = load_folds( test_validation_train,test_validation_train_ind,pairsData );
        [sorted_sums,IX] = sort_pairs_for_voting( four_folds_data );
        save(['pairs_order',num2str(test_validation_train_ind),'.mat'],'sorted_sums','IX');
        prior_delays = prior_delays_orig;
        prior_delays(trials_36_in_fold,:,1)=nan;
        prior_delays(trials_37_in_fold,:,2)=nan;
        prior_delays = squeeze(nansum(prior_delays))';
        prior_delays(1,:)=prior_delays(1,:)/sum(prior_delays(1,:));
        prior_delays(2,:)=prior_delays(2,:)/sum(prior_delays(2,:));
        prior_delays = prior_delays/190;
        
        train36 = setdiff(cond36(:,1),trials_36_in_fold);
        train37 = setdiff(cond37(:,1),trials_37_in_fold);
        
        for votes_num=1:length(num_of_pairs_to_use_for_voting_arr)
            disp(['checking vote group size of ',num2str(num_of_pairs_to_use_for_voting_arr(votes_num))])
            %for test_validation_train_ind = 1:length(test_validation_train)
            disp(['~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TESTING FOLD ',num2str(length(test_validation_train)+1-test_validation_train_ind),' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'])
            votes=zeros(100,2,2);

            for ii=1:num_of_pairs_to_use_for_voting_arr(votes_num) %num_of_pairs_to_use_for_voting_arr(7)
                %         disp(['checking the ',num2str(ii),' pair.']);
                cur_pair = pairsData(IX(ii));
                [cur_pair,trainSetBool,testSetBool] = update_pair_data( cur_pair,cond36 ,cond37 ,test_validation_train, test_validation_train_ind);
                
                %% super safe check
                train_of_pair = nan(sum(trainSetBool>0),2);
                train_of_pair(:,1) = cur_pair.trial(trainSetBool>0);
                train_of_pair(:,2) = cur_pair.cond(trainSetBool>0);
                
                check36 = ~isempty(intersect(train_of_pair(train_of_pair(:,2)==36,1),trials_36_in_fold));
                check37 = ~isempty(intersect(train_of_pair(train_of_pair(:,2)==37,1),trials_37_in_fold));
                if check36 + check37 >0
                    disp('###############################  MEGA PROBLEM  #######################################')
                end
                
                
                missing_vals_36 = setdiff(train36,train_of_pair(train_of_pair(:,2)==36,1));
                missing_vals_37 = setdiff(train37,train_of_pair(train_of_pair(:,2)==37,1));
                
                missing_vals_36_p = length(missing_vals_36)/length(train36);
                missing_vals_37_p = length(missing_vals_37)/length(train37);
                
                %%
                if length(cur_pair.diffsCond1Train)<minNumOfRepetions ||length(cur_pair.diffsCond2Train)<minNumOfRepetions
                    continue
                end
                %%
                test_inds = find(cur_pair.partOfTestSet>0);
                
                [y1,cur_bandwidth_cond1] = fit_continues_dist_for_delays(cur_pair.diffsCond1Train,1,30, 20,prior_delays);
                [y2,cur_bandwidth_cond2] = fit_continues_dist_for_delays(cur_pair.diffsCond2Train,2,30, 20,prior_delays);
                band_width_conds(ii,:)=[cur_bandwidth_cond1,cur_bandwidth_cond2];
                
                if to_plot
                    plot_pair_distrebutions(cur_pair,y1,y2,trainSetBool);
                end
                
                for test_ind =1:length(test_inds)
                    
                    real_cond = cur_pair.cond(test_inds(test_ind))-35;
                    cur_diff = cur_pair.diffs(test_inds(test_ind));
                    cur_trial = cur_pair.trial(test_inds(test_ind));
                    
                    %% decide by non parametric method


                    log_likelihood_ratio = calculate_score_for_test_example(cur_diff,  y1, y2);
                    
%                     if max(y1(cur_diff+41),y2(cur_diff+41))<eps % ###
%                         %                         disp('Uncertainty')
%                         continue
%                     end
                    
                    if to_plot
                        plot_decission_on_test_delay(log_likelihood_ratio,cur_diff, cur_trial, real_cond);
                    end
                    
                    current_ind_for_cache = cur_pair.trial(test_inds(test_ind)) + 100*(real_cond-1);
                    final_votes(ii,current_ind_for_cache,test_validation_train_ind)=log_likelihood_ratio;
                    final_votes_counter(ii,current_ind_for_cache,test_validation_train_ind)=final_votes_counter(ii,current_ind_for_cache,test_validation_train_ind)+1;
                    class_vec(test_validation_train_ind, current_ind_for_cache)=real_cond;
                    
                    
                    if log_likelihood_ratio > 0
                        votes(cur_pair.trial(test_inds(test_ind)),1,real_cond) = votes(cur_pair.trial(test_inds(test_ind)),1,real_cond)+log_likelihood_ratio;
                    else
                        votes(cur_pair.trial(test_inds(test_ind)),2,real_cond) = votes(cur_pair.trial(test_inds(test_ind)),2,real_cond)+log_likelihood_ratio;
                    end
                    
                end
                if to_plot
                    close all
                end
                %%
            end

            save(['band_width_conds',num2str(test_validation_train_ind),'.mat'],'band_width_conds');
            
            
            votes=sum(votes,2);
            %             votes=sum(votes,2);
            cond1=votes(:,:,1);
            cond2=votes(:,:,2);
            cond1(cond1==0)='';
            cond2(cond2==0)='';
            ground_truth = zeros(length(cond1)+length(cond2),2);
            ground_truth(1:length(cond1),1)=1;
            ground_truth(length(cond1)+1:end,2)=1;
            estimation = zeros(length(cond1)+length(cond2),2);
            estimation(sign(cond1)==1,1)=1;
            estimation(sign(cond1)==-1,2)=1;
            cond2_pos_inds = find(sign(cond2)==1);
            cond2_neg_inds = find(sign(cond2)==-1);
            
            estimation(length(cond1)+cond2_pos_inds,1)=1;
            estimation(length(cond1)+cond2_neg_inds,2)=1;
            
            stats = confusionmatStats(ground_truth(:,1),estimation(:,1));
            %         stats.confusionMat
            if isempty(stats.confusionMat)
                continue
            end
            stats.accuracy(1)
            %             final_votes(votes_num,last_ind_accuracys) = stats.accuracy(1);
            
            if to_plot
                plotconfusion(ground_truth',estimation')
                close all
            end
            
            
            %%
        end
        if to_plot
            plot(num_of_pairs_to_use_for_voting_arr,final_votes(:,last_ind_accuracys))
            drawnow;
            hold on
        end
        last_ind_accuracys=last_ind_accuracys+1;
    end
    
    
    final_votes_counter_flat = reshape(final_votes_counter,size(final_votes_counter,1),[],1);
    final_votes_flat = reshape(final_votes,size(final_votes,1),[],1);
    class_vec_flat = reshape(class_vec',1,[]);
    
    sum_final_votes_counter_flat = sum(final_votes_counter_flat);
    final_votes_counter_flat(:,sum_final_votes_counter_flat==0)='';
    final_votes_flat(:,sum_final_votes_counter_flat==0)='';
    class_vec_flat(sum_final_votes_counter_flat==0)='';
    save([pre_str_save_name,num2str(hyper_split_ind),'.mat'],'sorted_sums','final_votes_counter_flat','final_votes_flat','class_vec_flat','-v7.3');
    
    cd('..');
end


