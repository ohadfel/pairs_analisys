function [ log_likelihood_ratio ] = calculate_score_for_test_example(cur_diff, y1,y2 )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

%% decide by non parametric method

log_likelihood_ratio = log(y1(cur_diff+41)/y2(cur_diff+41));

% if log_likelihood_ratio==inf
%     % disp(y1(cur_diff+41))
%     log_likelihood_ratio = 2000000*y1(cur_diff+41); % ###
% end
end