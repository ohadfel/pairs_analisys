function [ sorted_sums,IX ] = sort_pairs_for_voting( four_folds_data )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% log_four_folds_data = -log(four_folds_data);
% q=nansum(log_four_folds_data,2);

four_folds_data = 1-four_folds_data;
q=nansum(four_folds_data,2);


[sorted_sums,IX] = sort(q,'descend');
IX(isnan(sorted_sums))='';
sorted_sums(isnan(sorted_sums))='';
% IX(sorted_sums==0)='';
% sorted_sums(sorted_sums==0)='';

end

