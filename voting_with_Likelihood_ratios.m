addpath('/media/ohadfel/New Volume/Copy/Baus/Code/matlab/Pairs_analysis/new_organized_code')
cd('/media/ohadfel/New Volume/Copy/Baus/Code/matlab/Pairs_analysis')
load('pairsDataN.mat');

%%
fold_num=1;
num_of_folds = 1;
pre_str_save_name = '3hyperFoldsRun';
hyper_split_arr = 1:25;
to_plot=0;
super_to_plot = 1;

%%
minNumOfRepetions=5;


num_of_pairs_to_use_for_voting_arr = 1:20:2500;

accuracies_scores = nan(length(num_of_pairs_to_use_for_voting_arr),length(hyper_split_arr)*5);

all_folds = 1:5;
test_validation_train=nchoosek(1:5,4);
last_ind_accuracys = 1;
for hyper_split_ind = 1:size(hyper_split_arr,2)
    if mod(hyper_split_ind,num_of_folds)+1~=fold_num
        continue
    end
    disp(['hyper_split_ind = ',num2str(hyper_split_ind)]);
    four_folds_data = nan(length(pairsData),4);
    cd(['hyperFoldNum',num2str(hyper_split_ind)])
    addpath('..')
    load('folds_splits.mat');
    %%
    for test_validation_train_ind = 1:length(test_validation_train)
        
        four_folds_data = load_folds( test_validation_train,test_validation_train_ind,pairsData );
        [sorted_sums,IX] = sort_pairs_for_voting( four_folds_data );
        
        for votes_num=1:length(num_of_pairs_to_use_for_voting_arr)
            disp(['checking vote group size of ',num2str(num_of_pairs_to_use_for_voting_arr(votes_num))])
            %for test_validation_train_ind = 1:length(test_validation_train)
            disp(['~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TESTING FOLD ',num2str(length(test_validation_train)+1-test_validation_train_ind),' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'])
            votes=zeros(100,2,2);
            
            
            for ii=1:num_of_pairs_to_use_for_voting_arr(votes_num) %num_of_pairs_to_use_for_voting_arr(7)
                %         disp(['checking the ',num2str(ii),' pair.']);
                
                cur_pair = pairsData(IX(ii));
                [cur_pair,trainSetBool,testSetBool] = update_pair_data( cur_pair,cond36 ,cond37 ,test_validation_train, test_validation_train_ind);
                
                if length(cur_pair.diffsCond1Train)<minNumOfRepetions ||length(cur_pair.diffsCond2Train)<minNumOfRepetions
                    continue
                end
                %%
                test_inds = find(cur_pair.partOfTestSet>0);
                
                y1 = fit_continues_dist_for_delays(cur_pair.diffsCond1Train);
                y2 = fit_continues_dist_for_delays(cur_pair.diffsCond2Train);
                
                if to_plot
                    plot_pair_distrebutions(cur_pair,y1,y2,trainSetBool);
                end
                
                for test_ind =1:length(test_inds)
                    
                    real_cond = cur_pair.cond(test_inds(test_ind))-35;
                    cur_diff = cur_pair.diffs(test_inds(test_ind));
                    cur_trial = cur_pair.trial(test_inds(test_ind));
                    
                    %% decide by non parametric method
                    log_likelihood_ratio = calculate_score_for_test_example(cur_diff,  y1, y2);
                    
                    if max(y1(cur_diff+41),y2(cur_diff+41))<eps % ###
                        %                         disp('Uncertainty')
                        continue
                    end
                    
                    if to_plot
                        plot_decission_on_test_delay(log_likelihood_ratio,cur_diff, cur_trial, real_cond);
                    end
                    
                    
                    if log_likelihood_ratio > 0
                        votes(cur_pair.trial(test_inds(test_ind)),1,real_cond) = votes(cur_pair.trial(test_inds(test_ind)),1,real_cond)+log_likelihood_ratio;
                        %                 votes_weigthed(cur_pair.trial(test_inds(test_ind)),1,real_cond) = votes_weigthed(cur_pair.trial(test_inds(test_ind)),1,real_cond)+confidence;
                    else
                        votes(cur_pair.trial(test_inds(test_ind)),2,real_cond) = votes(cur_pair.trial(test_inds(test_ind)),2,real_cond)+log_likelihood_ratio;
                        %                 votes_weigthed(cur_pair.trial(test_inds(test_ind)),2,real_cond) = votes_weigthed(cur_pair.trial(test_inds(test_ind)),2,real_cond)-confidence;
                    end
                end
                if to_plot
                    close all
                end
                %%
            end
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
            stats.accuracy(1);
            accuracies_scores(votes_num,last_ind_accuracys) = stats.accuracy(1);
            
            if to_plot
                plotconfusion(ground_truth',estimation')
                close all
            end
            
            
            %%
        end
        if to_plot
            plot(num_of_pairs_to_use_for_voting_arr,accuracies_scores(:,last_ind_accuracys))
            drawnow;
            hold on
        end
        last_ind_accuracys=last_ind_accuracys+1;
    end
    
    cd('..');
end

save([pre_str_save_name,num2str(fold_num),'.mat'],'accuracies_scores','-v7.3');
if super_to_plot
    q=nanmean(accuracies_scores');
    SEM = nanstd(accuracies_scores')/sqrt(size(accuracies_scores',2));
    addpath('/media/ohadfel/New Volume/matlab_stuff/kakearney-boundedline-pkg-2112a2b/boundedline');
    figure
    boundedline(num_of_pairs_to_use_for_voting_arr,q,SEM);
    xlabel('Number of pairs voting')
    ylabel('Mean accuracy')
    title('Classification results with weighted voting (log(P1/P2))');
    [maxAccuracy,numOfVoters] = max(q);
    maxAccuracy = maxAccuracy
    numOfVoters = num_of_pairs_to_use_for_voting_arr(numOfVoters)
end

