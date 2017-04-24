function plotBAO_matt(x,y,b,bx,by,r2,timeLims)

nSide = sqrt(numel(b));
drawCbar = true;

plotMethod = 'matt';% 'karth';% 'matt';% 'adil';%

%matt: linear interpolation, patch colorbar
%adil: just moves color axis to lims. can saturate edges. nice colorbar

if ~isempty(timeLims)
    if timeLims(1)>min(b)
        disp(['minB(' num2str(min(b),3) ') < min color (' num2str(timeLims(1)) ').'])
        if strcmp(plotMethod,'matt')||strcmp(plotMethod,'karth')
            timeLims(1) = min(b); disp('Moving lim to min(b).');
        elseif strcmp(plotMethod,'adil')
            disp('Min values will be saturated.');
        end
    end
    if timeLims(2)<max(b)
        disp(['maxB(' num2str(max(b),3) ') > max color (' num2str(timeLims(2)) ').'])
        if strcmp(plotMethod,'matt')||strcmp(plotMethod,'karth')
            timeLims(2) = max(b); disp('Moving lim to max(b).');
        elseif strcmp(plotMethod,'adil')
            disp('Max values will be saturated.');
        end
    end
else
    timeLims = [min(b) max(b)];
end

if strcmp(plotMethod,'matt')||strcmp(plotMethod,'karth')
    [b,ii] = sort(b); x = x(ii); y = y(ii); %required for karth method   
    cmap = jet(numel(b));%flipud(hot(128));%
    for i = 1:nSide, for j  = 1:nSide, plot(i,j, 'ko','markerSize', 10); end; end
    for i = 1:length(b)
        if ~isnan(b(i))
            iColor = round(linterp([timeLims(1), timeLims(2)], [1 size(cmap, 1)], b(i)));%matt (linear interpolation) 
            if strcmp(plotMethod,'karth'), iColor =  i; %uniform color spread that ignores proximity of values
            end
            plot(x(i),y(i), '.','markerEdgeColor',cmap(iColor, :), ...
                'markerFaceColor', cmap(iColor, :),'markerSize', 60);
        end
    end
else %adil
    scatter(1:nSide,1:nSide,250,'k')
    scatter(x,y,300,b,'filled');
    caxis(timeLims); colormap(jet);%colormap(flipud(hot));
end

if drawCbar   
    if strcmp(plotMethod,'matt')||strcmp(plotMethod,'karth')
        cbar = cmap(round(linspace(1, length(cmap), ceil(sqrt(length(cmap))))), :);
        for i = 1:size(cbar,1)
            patch(.25*[i-.5 i+.5 i+.5 i-.5], .25*[1 1 2 2], cbar(i,:), ...
                'edgeColor', cbar(i,:));
        end
        text(-.5, -.4, num2str(timeLims(1), 3), 'fontSize', 12);
        text(1.5, -.4, num2str(timeLims(2), 3), 'fontSize', 12);
    else%adil
        c_bar = colorbar('EastOutside');%('southoutside');
        set(get(c_bar, 'xlabel'), 'string', 'time (ms)')
    end
end

axis([0 11 0 11]);
axis equal; axis off;

cntr=[0.5+nSide/2 0.5+nSide/2];
direction=[bx,by];

vectr=(direction./norm(direction)).*r2*10;
q = quiver(cntr(1,1),cntr(1,2),vectr(1,1),vectr(1,2),'-k');
set(q,'LineWidth',2,'MaxHeadSize',1e2,'AutoScaleFactor',0.8);

end%function
