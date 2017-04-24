function   batOUT = simpleBATregress(x,y,bat)

d = dataset(x,y,bat);
lm = fitlm(d,'bat ~ x + y'); tbl = anova(lm,'summary');
batOUT.x = lm.Coefficients{2,1}; batOUT.y = lm.Coefficients{3,1};
batOUT.R2 = lm.Rsquared.Ordinary; batOUT.R2p = tbl{2,5};
batOUT.times = bat;

end%function