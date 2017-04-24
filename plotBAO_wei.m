function [] = plotBAO_wei(x,y,bat,bx,by,r2,figTitle)

plotDir = 'D:\vp hatlab\beta\results\';

ox = x; oy = y; mSize = 175;

bat = bat-2000;
x(isnan(bat)) = []; y(isnan(bat)) = [];
bat(isnan(bat)) = [];


nChannels = numel(bat);
c = hot(nChannels); %c = jet(nChannels);
side = sqrt(nChannels);

figure; hold on

subplot(1,3,1); hold on
scatter(ox,oy,mSize,'k');
scatter(x,y,mSize,c,'filled'); %plot color as before: each bat has a bin
plotArrow(side,bx,by,r2);
axis([0 side+1 0 side+1]); axis off; 
title('uniform color');

%'correct' color: close bats have close color
bq =  bat-min(bat); bq =  1+round((nChannels-1)*bq./max(bq));
subplot(1,3,2); hold on
scatter(ox,oy,mSize,'k');
scatter(x,y,mSize,c(bq,:),'filled');
plotArrow(side,bx,by,r2);
axis([0 side+1 0 side+1]); axis off; 
title('real color');

%add color bar
subplot(1,9,7);
colormap(hot);
labels = cell(1,nChannels); labels{1} = num2str(bat(1)); labels{end} = num2str(bat(end));
h = lcolorbar(labels,'fontweight','bold', 'Location', 'vertical');
set(h, 'OuterPosition', [0. 0.4 0.1 0.3]); axis off

%hist bats
subplot(1,3,3);
histogram(bat);
title('BAT after GOcue'); xlabel('ms'); ylabel('nChannels');

% get(gcf, 'Position')
set(gcf,'Position',[ 2019         448        1249         433]);

suptitle(figTitle);
saveas(gcf,[plotDir figTitle '-BAT.png']);
end

function [] = plotArrow(nChannels,bx,by,r2)

cntr=[0.5+nChannels/2 0.5+nChannels/2]; 
direction=[bx,by];

vector_up=(direction./norm(direction)).*r2*10;

q = quiver(cntr(1,1),cntr(1,2),vector_up(1,1),vector_up(1,2),'-k');
set(q,'LineWidth',2,'MaxHeadSize',1e2,'AutoScaleFactor',0.8);

end

