function [] = plotBAMBAT(bat,bam,x,y,FO,edges,axisLims,batT,area,session,plotDir,imtag,alignment)

figure('Position',[2156 34 1070 935]); hold on
subplot(2,2,1); hold on
plotBAO_matt(x,y,bat.times,bat.x,bat.y,bat.R2,bat.timeLims);
title([area session ' BAT r2 = ' num2str(bat.R2,2) ' , p = ' num2str(bat.R2p,3)]);
subplot(2,2,2); hold on
myHist(edges,bat.times,axisLims);
ylabel('nChannels'); xlabel(['ms from' alignment '(@' num2str(FO) ')']);
title(['bat threshold @' num2str(batT)])

subplot(2,2,3); hold on
plotBAO_matt(x,y,bam.times,bam.x,bam.y,bam.R2,bam.timeLims);
title([area session ' BAM r2 = ' num2str(bam.R2,2) ' , p = ' num2str(bam.R2p,3)]);
subplot(2,2,4); hold on
myHist(edges,bam.times,axisLims);
ylabel('nChannels'); xlabel(['ms from ' alignment '(@' num2str(FO) ')']);
title(['bat threshold @' num2str(batT)])

suptitle([alignment '-' imtag]);

saveas(gcf,[plotDir area session '_bat_bam_' 'batT' num2str(100*batT) '_' alignment '_' imtag '.png']);
end%function