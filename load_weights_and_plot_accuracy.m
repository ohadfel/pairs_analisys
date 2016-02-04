num_of_hyper_folds = 25;
version_num = 9;
load(['/media/ohadfel/New Volume/Copy/Baus/Code/matlab/Pairs_analysis/hyperFoldNum',num2str(1),'/',num2str(version_num),'votes',num2str(1),'.mat']);
% accuracy_results_mean = nan(size(final_votes_flat,1),num_of_hyper_folds);
accuracy_results = nan(size(final_votes_flat,1),num_of_hyper_folds*5);
% accuracy_results_sem = nan(size(final_votes_flat,1),num_of_hyper_folds);
for hyper_fold_num=1:num_of_hyper_folds
    disp(['analyzing hyper fold ',num2str(hyper_fold_num)])
    load(['/media/ohadfel/New Volume/Copy/Baus/Code/matlab/Pairs_analysis/hyperFoldNum',num2str(hyper_fold_num),'/',num2str(version_num),'votes',num2str(hyper_fold_num),'.mat'])
    %% find folds limits 
    starts_of_fold = find([-1,diff(class_vec_flat)]==-1);
    ends_of_fold = [starts_of_fold(2:end)-1,length(class_vec_flat)];

    
    %% sum up the votes
    last_raw_sum = zeros(1,189);
    for num_of_voters = 1:size(final_votes_flat,1)
        voted_class = nan(size(class_vec_flat));
         
%         raw_sums = nansum(final_votes_flat(1:num_of_voters,:),1);
        raw_sums = nansum([final_votes_flat(num_of_voters,:);last_raw_sum]);
%         if sum(raw_sums==raw_sums2)~=189
%             disp('ERROR')
%         end
        last_raw_sum = raw_sums;
        raw_sums(raw_sums==0)=nan;
        
        voted_class = (sign(raw_sums)+1)*(-0.5)+2;

        folds_accuracys = nan(length(starts_of_fold),1);
        number_of_trials = 0;
        for fold_ind=1:length(starts_of_fold)
            cur_range=starts_of_fold(fold_ind):ends_of_fold(fold_ind);
            number_of_trials = number_of_trials + sum(~isnan(voted_class(cur_range)));
            folds_accuracys(fold_ind)=sum(class_vec_flat(cur_range)==voted_class(cur_range))/sum(~isnan(voted_class(cur_range)));
        end
        %accuracy_results_mean(num_of_voters,hyper_fold_num) = nanmean(folds_accuracys);
        %accuracy_results_sem(num_of_voters,hyper_fold_num) = nanstd(folds_accuracys)/sqrt(sum(~isnan(folds_accuracys)));
        %% cache the results in the right place
        accuracy_results(num_of_voters,(hyper_fold_num-1)*5+1:(hyper_fold_num)*5) = folds_accuracys';
    end
end
accuracy_results_mean = nanmean(accuracy_results,2);
accuracy_results_sem = nanstd(accuracy_results')/sqrt(sum(~isnan(accuracy_results')));
addpath('/media/ohadfel/New Volume/matlab_stuff/kakearney-boundedline-pkg-2112a2b/boundedline');
figure
boundedline(1:length(accuracy_results_mean),accuracy_results_mean,accuracy_results_sem);
xlabel('Number of pairs voting')
ylabel('Mean accuracy')
title('Classification results with priors');
set(gca,'XTick',[0:floor(length(accuracy_results_mean)/15):length(accuracy_results_mean)])