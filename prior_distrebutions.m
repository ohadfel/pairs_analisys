%% create prior distrebutions
addpath('/media/ohadfel/New Volume/Copy/Baus/Code/matlab/Pairs_analysis/new_organized_code')
cd('/media/ohadfel/New Volume/Copy/Baus/Code/matlab/Pairs_analysis')
% load('pairsDataN.mat');
% prior_delays = zeros(2,length(-40:40));
% for ii=1:300000
%     disp(ii)
%     pairs_inds = [pairsData(ii).cond-35,pairsData(ii).diffs+41];
%     for jj=1:size(pairs_inds,1)
%         prior_delays(pairs_inds(jj,1),pairs_inds(jj,2))=prior_delays(pairs_inds(jj,1),pairs_inds(jj,2))+1;
%     end
% end
% prior_delays(1,:)=prior_delays(1,:)/sum(prior_delays(1,:));
% prior_delays(2,:)=prior_delays(2,:)/sum(prior_delays(2,:));
% save('prior_delays.mat','prior_delays');

load('pairsDataN.mat');
prior_delays = zeros(100,length(-40:40),2);
for ii=1:length(pairsData)
    disp(ii)
    pairs_inds = [pairsData(ii).trial,pairsData(ii).diffs+41,pairsData(ii).cond-35];
    for jj=1:size(pairs_inds,1)
        prior_delays(pairs_inds(jj,1),pairs_inds(jj,2),pairs_inds(jj,3))=prior_delays(pairs_inds(jj,1),pairs_inds(jj,2),pairs_inds(jj,3))+1;
    end
end

save('prior_delays2.mat','prior_delays');