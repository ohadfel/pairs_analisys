function [ y,cur_band_width ] = fit_continues_dist_for_delays( delays,cond ,sigma, cur_size, prior_delays)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
pd = fitdist(delays,'Kernel','Kernel','normal');
y = pdf(pd,-40:40);

y = y+prior_delays(cond,:);
% plot(-40:40,y,'r');
y=y./sum(y);
cur_band_width = pd.BandWidth;


% [n,xout] =hist(delays,-40:40);
% % sigma = 10;
% % size = 10;
% x = linspace(-cur_size / 2, cur_size / 2, cur_size);
% gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
% gaussFilter = gaussFilter / sum (gaussFilter); % normalize
% yfilt = conv (n, gaussFilter, 'same');
% yfilt = fliplr(conv (fliplr(yfilt), gaussFilter, 'same'));
% % figure
% % plot(-40:40,n/sum(n),'k');
% % hold on
% % plot(-40:40,y,'r');
% % hold on
% % plot(-40:40,yfilt/sum(yfilt),'b');
% % hold off
% % close all
end



