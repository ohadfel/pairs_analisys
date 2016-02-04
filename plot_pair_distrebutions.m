function [  ] = plot_pair_distrebutions( cur_pair,y1,y2,trainSetBool )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

k=nan(max(length(cur_pair.diffsCond1Train),length(cur_pair.diffsCond2Train)),2);
k(1:length(cur_pair.diffsCond1Train),1)=cur_pair.diffsCond1Train;
k(1:length(cur_pair.diffsCond2Train),2)=cur_pair.diffsCond2Train;

figure;
subplot(3,1,1)
scatter(cur_pair.diffs(trainSetBool==1),cur_pair.trial(trainSetBool==1),120,'filled','bp');
ylabel('Trial index')
hold on;
scatter(cur_pair.diffs(trainSetBool==2),cur_pair.trial(trainSetBool==2),120,'filled','rp');
set(gca,'xlim',[-40 40])

subplot(3,1,3)
plot(-40:40,y2,'r');
hold on
plot(-40:40,y1,'b');
xlabel('Delay in ms')
ylabel('Probability')


subplot(3,1,2)
hist(k,81);
hold on;
ylabel('Count')

figure(gcf);
set(get(gca,'child'),'LineWidth',0.01);
set(gca,'xlim',[-40 40])
hold on

end

