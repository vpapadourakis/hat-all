function [BAT,BAM] = compute_BAMandBAT(data, START_TIME, END_TIME, THRESHOLD, REMOVE,DOPLOT,t)

%returns results in t units (ie defined by input)

%FITSIGMOID2 does not do what I would expect it to do. Should investigate
%with examples of slope and bounds. Not clear to me how the "amplitude" is
%computed.

nChannels = size(data,3);

BAT = nan(nChannels,1); BAM = nan(nChannels,1);
block = round((END_TIME - START_TIME) / 3);

if DOPLOT, figure('Position',[ 2099 653 576 293]);
end

for i = 1:nChannels
    
    clear tidx min_ba max_ba cutoff cHat
    trial_average = nanmean(data(START_TIME:END_TIME,:,i),2);
  
    %max min normalization for bat
    min_ba = min(trial_average); max_ba = max(trial_average);
    cutoff = min_ba + (max_ba - min_ba) * THRESHOLD; %cutoff is the voltage at which point we say beta attenuation occured at this time.
    batTidx = find(trial_average < cutoff, 1); %Find the first time the average amplitude is less than the cutoff voltage (because we expect beta to decrease)
    
    %sigmoid fit for BAM
    LB = [min(trial_average(1:block)) min(trial_average(block*2:block*3)) -3 1]; %[peak trough slope midpoint]
    UB = [max(trial_average(1:block)) max(trial_average(block*2:block*3)) -.01 numel(t)];
    
    if(~isnan(sum(trial_average)))
        cHat = fitSigmoid2(t, trial_average, LB, UB);
        %The fourth argument of cHat is BAM
    end
    
    if exist('cHat','var') && ~any(i == REMOVE) %tossing out electrodes
        BAM(i) = cHat(4);
    end
    
    if ~isempty(batTidx) && ~any(i == REMOVE) %tossing out electrodes
        BAT(i) = t(batTidx);
    end
     
    if ~isempty(batTidx) && exist('cHat','var') && ~any(i == REMOVE)
        if DOPLOT                         
            hold off
            plot(t,trial_average,'LineWidth',4);
            hold on
            %plot BAT
            line(get(gca,'xlim'),[cutoff cutoff])
            plot(t(batTidx),trial_average(batTidx), 'r*')
            
            %plot BAM
            ylims = get(gca,'ylim');
            logitc = @(x, c) (c(1) - c(2)) ./ (1 + exp(-c(3) .* (x - c(4)))) + c(2);
            plot(t,logitc(t, cHat), 'r')
            line([cHat(4) cHat(4)],ylims,'Color','g');
            
            txt = {['channel ' num2str(i)];...
                   ['BAT: ' num2str(round(BAT(i)))]; ...
                   ['BAM: ' num2str(round(BAM(i)))];
                   ['diff: ' num2str(round(BAT(i)) - round(BAM(i)))]}; 
            text(t(end)-500,ylims(2)*0.8,txt);
                       
            pause;        
        end
    end%if plot
    
end

end%function

