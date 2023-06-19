function [y,x,varargout] = binAveraging(y0,x0,varargin)
% function [y,x,varargout] = binAveraging(Y,x0,varargin) computes
% non-overlapping bin-averaged quantities from vectors.
% 
% Input: 
% x0: vector [1 x N] of absiccsa values, e.g. a time vector
% y0: vector [1 x N] of ordinate values in each x0, e.g. a time series
% varargin
% 
% 
% options for Input:
% newX: vector [1 x M]: new abcissa
% Nbin: scalar [1 x 1]: number of bins (overwritten by newX, if specified) 
% binWidth: scalar [1 x 1]: width of bins (overwritten by newX, if specified) 
% BMAX: scalar: Max value of the bin (x0<=BMAX) 
% BMIN: scalar: Min value of the bin (x0>=BMIN) 
% averaging: string: 'mean" or 'median'
% dispersion: string: 'std', 'decile_10_90' or 'decile_25_75'
% 
% Output:
% y: vector [1 x M]: binned values of y0
% x: vector [1 x M]: new absiccsa
% varargout: if specified, provides a [ 1x M] vector for the dispersion
% 
% Author: E. Cheynet  - UiB - Norway
% LAst modified 06/12/2019
% 
%  see also histcounts accumarray

%%  Inputparser

p = inputParser();
p.CaseSensitive = false;
p.addOptional('newX',[]);
p.addOptional('binMethod','auto');
p.addOptional('BMIN',nanmin(x0));
p.addOptional('BMAX',nanmax(x0));
p.addOptional('binWidth',[]);
p.addOptional('Nbin',[]);
p.addOptional('averaging','mean');
p.addOptional('dispersion','std');
p.parse(varargin{:});
% shorthen the variables name
BMIN = p.Results.BMIN ;
BMAX = p.Results.BMAX ;
binMethod = p.Results.binMethod ;
binWidth = p.Results.binWidth ;
Nbin = p.Results.Nbin;
newX = p.Results.newX ;
averaging = p.Results.averaging ;
dispersion = p.Results.dispersion ;
y0 = y0(:);
x0 = x0(:);

%%
if ~isempty(newX)
    [~,~,bin] = histcounts(x0,newX);
elseif ~isempty(Nbin)
    [~,~,bin] = histcounts(x0,Nbin);
elseif isempty(newX) && isempty(binWidth)
    [~,~,bin] = histcounts(x0,'BinMethod',binMethod,'BinLimits',[BMIN,BMAX]);
elseif isempty(newX) && ~isempty(binWidth)
    [~,~,bin] = histcounts(x0,'BinMethod',binMethod,'BinLimits',[BMIN,BMAX],'binWidth',binWidth);
else
    error('unspecfied options')
end
% bin(bin==0)=1;


%% Mean values
if strcmpi(averaging,'mean')
    y = accumarray(bin(bin>0), y0(bin>0), [], @nanmean, nan);
    x = accumarray(bin(bin>0), x0(bin>0), [], @nanmean, nan);
elseif strcmpi(averaging,'median')
    y = accumarray(bin(bin>0), y0(bin>0), [], @nanmedian, nan);
    x = accumarray(bin(bin>0), x0(bin>0), [], @nanmedian, nan);
else
    error(' ''averaging'' should be ''mean'' or ''median'' ')
end


%% Dispersion
if strcmpi(dispersion,'std')
    stdY = accumarray(bin(bin>0), y0(bin>0), [], @nanstd, nan);
elseif strcmpi(dispersion,'decile_10_90')
    stdY(1,:) = accumarray(bin(bin>0), y0(bin>0), [], @(x) quantile(x,0.1), nan);
    stdY(2,:) = accumarray(bin(bin>0), y0(bin>0), [], @(x) quantile(x,0.9), nan);
elseif strcmpi(dispersion,'decile_25_75')
    stdY(1,:) = accumarray(bin(bin>0), y0(bin>0), [], @(x) quantile(x,0.25), nan);
    stdY(2,:) = accumarray(bin(bin>0), y0(bin>0), [], @(x) quantile(x,0.75), nan);    
elseif strcmpi(dispersion,'decile_1_99')
    stdY(1,:) = accumarray(bin(bin>0), y0(bin>0), [], @(x) quantile(x,0.01), nan);
    stdY(2,:) = accumarray(bin(bin>0), y0(bin>0), [], @(x) quantile(x,0.99), nan);    
else
    error(' ''std'' should be ''decile_10_90'' or ''decile_25_75'' ')
end

stdY = stdY';


y(isnan(x))=[];
x(isnan(x))=[];


if nargout ==3,    varargout = {stdY};end



end