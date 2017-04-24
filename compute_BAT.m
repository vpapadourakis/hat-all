%REMOVE is an array of all electrodes that should be removed from analysis.
%
function BAT = compute_BAT(data, NUM_ELEC, START_TIME, END_TIME, THRESHOLD, REMOVE,DOPLOT)
    BAT = nan(96,1);
    for i = 1:NUM_ELEC
        clear tidx min_ba max_ba cutoff
        trial_average = nanmean(data(START_TIME:END_TIME,:,i),2);
        min_ba = min(trial_average);
        max_ba = max(trial_average);
        cutoff = min_ba + (max_ba - min_ba) * THRESHOLD; %cutoff is the voltage at which point we say beta attenuation occured at this time.
        tidx = find(trial_average < cutoff, 1); %Find the first time the average amplitude is less than the cutoff voltage (because we expect beta to decrease)
        if ~isempty(tidx) && ~any(i == REMOVE) %tossing out electrodes
            BAT(i) = tidx + START_TIME;
                   
            if DOPLOT
                %% PLOT: To visualize (debugging purposes), plot BAT
                plot(trial_average,'LineWidth',4);                
                hold on
                line(get(gca,'xlim'),[cutoff cutoff])
                plot(BAT(i),trial_average(BAT(i)), 'r*')
                hold off
                pause;
            end
            
        end
    end
end
