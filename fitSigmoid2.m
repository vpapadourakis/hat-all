function [fittedParams, fittedR2] = fitSigmoid2(xData, yData, LB, UB, OPTIONS)
%FITSIGMOID2 fits a two parameter sigmoidal function of the form:
%   y = b + (a - b) ./ (1 + exp(-c .* d))
% using a nonlinear least squares curve fitting routine.
%
% fittedParams = FITSIGMOID2(xData, yData) returns the four parameters of
%   the sigmoid curve specified by xData and yData (both column vectors).
%
% fittedParams = FITSIGMOID2(xData, yData, LB, UB, OPTIONS) constrains the
%   fitted parameters to be within the boundaries specified by LB and UB and
%   using the options specified by the optimset function.  LB and UB parameters
%   are specified as [peak, trough, slope, midpoint].
%
% [fittedParams, fittedR2] = FITSIGMOID2(xData, yData) additionally returns
%   the coefficient of determination, R2 of the model.  This corresponds to
%   the proportion of variance accounted for.  
%
%
% EXAMPLE: 
%   logitc = @(x, c) (c(1) - c(2)) ./ (1 + exp(-c(3) .* (x - c(4)))) + c(2);
%   cTrue = [1 0 -.0250 500];
%   x = 1:1000;
% 
%   y = logitc(x, cTrue) + smoothWithGaussianKernel(.1*randn(size(x))', .005, 1000)';
% 
%   plot(x, y)
% 
%   LB = [1 0 -1, 1];
%   UB = [1 0 -.01, 1000];
%   cHat = fitSigmoid2(x, y, LB, UB);
% 
%   hold on;
%   plot(logitc(x, cHat), 'r')


if nargin < 5
    OPTIONS = optimoptions('lsqcurvefit', 'display', 'off');
end;
if nargin < 4
    LB = [0 0 -.1, 1200];
end;
if nargin < 3
    UB = [1e8 1e8 0 2000];
end;


if LB(1) == UB(1)
    p1 = LB(1);
else
    p1 = mean([LB(1) UB(1)]);
end;

if LB(2) == UB(2)
    p2 = LB(2);
else
    p2 = mean([LB(2) UB(2)]);
end;

LB = LB(3:4);
UB = UB(3:4);

logitc = @(x, c, p1, p2) (p1 - p2) ./ (1 + exp(-c(1) .* (x - c(2)))) + p2;

[fittedParams, resnorm] = lsqcurvefit(@(c, xdata) logitc(xdata, c, p1, p2), ...
    [-0.01, 1500], xData(:), yData(:), LB, UB, OPTIONS);
fittedParams = [p1 p2 fittedParams];
fittedR2 = 1 - (resnorm / sum((yData(:) - mean(yData(:))).^2));

