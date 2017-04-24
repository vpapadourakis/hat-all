function envMean = channelMeanEnvelope(lfp,fs,bw,cf)

nChannels = numel(lfp);
envMean = cell(1,nChannels);

for iChannel = 1:nChannels      
    x = lfp{iChannel}';
    xh = abs(hilbert(filterData(x, cf, bw, fs)));    
    %mean channel envelope
    envMean{iChannel} = mean(xh,2); 
end

end
