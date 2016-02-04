function [ ] = plot_decission_on_test_delay( log_likelihood_ratio,cur_diff, cur_trial, real_cond )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
color_str=['b','r'];
prediction_color = 'k';

if log_likelihood_ratio < 0
    if log_likelihood_ratio < -1
        prediction_color = 'r';
    else
        prediction_color = 'm';
    end
else
    if log_likelihood_ratio > 1
        prediction_color = 'b';
    else
        prediction_color = 'c';
    end
end

subplot(3,1,1);
scatter(cur_diff,cur_trial,180,'filled',['s',color_str(real_cond)]);
scatter(cur_diff,cur_trial,85,'filled',['s',prediction_color]);

subplot(3,1,2);
scatter(cur_diff,2,180,'filled',['s',color_str(real_cond)]);
scatter(cur_diff,2,85,'filled',['s',prediction_color]);
end

