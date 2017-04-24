
function BAM = compute_BAM(data, NUM_ELEC, START_TIME, END_TIME, REMOVE, DOPLOT)

%REMOVE is an array of all electrodes that should be removed from analysis.

if nargin < 6
    DOPLOT = 1;
end;
    BAM = nan(96,1);
    block = round((END_TIME - START_TIME) / 3);
    for i = 1:NUM_ELEC
        trial_average = nanmean(data(START_TIME:END_TIME,:,i),2);
        
        %set lower and upper bounds for [peak trough slope midpoint]
        LB = [min(trial_average(1:block)) min(trial_average(block*2:block*3)) -1 1];
        UB = [max(trial_average(1:block)) max(trial_average(block*2:block*3)) -.01 3000];
        
        x = START_TIME:END_TIME;
        clear cHat
        if(~isnan(sum(trial_average)))
            cHat = fitSigmoid2(x, trial_average, LB, UB);
            %The fourth argument of cHat is BAM
        end
        
        if exist('cHat','var') && ~any(i == REMOVE) %tossing out electrodes
            BAM(i) = cHat(4) + START_TIME;
            
            if DOPLOT% PLOT: To visualize (debugging purposes), plot BAT
                logitc = @(x, c) (c(1) - c(2)) ./ (1 + exp(-c(3) .* (x - c(4)))) + c(2);
                plot(trial_average,'LineWidth',4)
                
                hold on
                plot(logitc(x, cHat), 'r')
                line([cHat(4) - START_TIME cHat(4) - START_TIME],get(gca,'ylim'),'Color','g');
                cHat(4)
                hold off
                pause;
            end

        end %if electrode has data and is not in remove
    end %for NUM_ELECT
end%function
