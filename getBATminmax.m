function bat = getBATminmax(envMean,fs,BAthres,t)
nChannels = numel(envMean);

bat = nan(1,nChannels);
% figure; hold on;
for iChannel = 1:nChannels
    
    env = envMean{iChannel};
    
    %cut to remove noisy hilbert sides
    env = env(fs/2+1:end-fs/2); tt = t(fs/2+1:end-fs/2);
    
%     subplot 121; hold on
%     h = plot(tt,env); h.Color = [0 0 0 0.3];
    
    %normalize envelope
    env = (env-min(env))./(max(env)-min(env));
    
%     subplot 122; hold on
%     h = plot(tt,env); h.Color = [0 0 0 0.3];
    
    %get bat
    bat(iChannel) = tt(find(env<BAthres,1));
    
end

end%function