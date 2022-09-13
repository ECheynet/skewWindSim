function [u_star,varargout] = frictionVelocity(u,v,w,varargin)
% [u_star] = frictionVelocity(u,v,w) computes the friction velocity
%
% Input
% u: [1 x N] vector: Along wind component (m/s)
% v: [1 x N] vector: Across wind component (m/s)
% w: [1 x N] vector: Vertical wind component (m/s)
%
% Output
% u_star: [1 x N] vector: friction velocity (m/s)
%
% Author. E. Cheynet - University of Stavanger - last modified 10/02/2018


%% Inputparseer
p = inputParser();
p.CaseSensitive = false;
p.addOptional('method','standard');
p.parse(varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%
method = p.Results.method ;

%%



if strcmpi(method,'standard'),
    
    u = nandetrend(u);
    v = nandetrend(v);
    w = nandetrend(w);
    
    uw = nanmean(u(:)'.*w(:)').^2;
    vw = nanmean(v(:)'.*w(:)').^2;
    u_star = (uw+vw).^(1/4);
    
elseif strcmpi(method,'Klipp2018') || strcmpi(method,'Klipp'),
    [R] = reynoldsStressTensor(u,v,w);
    
    [V,eigVal] = svd(R);
    
    if license('test', 'statistics_toolbox'),
        A = [nanmean(u), nanmean(v), nanmean(w)];
    else
        A = [mean(u),mean(v), mean(w)];
    end
    B = V(:,3);    
    gamma1 = acosd(dot(A,B)./(norm(A,2).*norm(B,2)));
    
    beta1 = 90-gamma1;
    if beta1>90, beta1 = 180-beta1; end
%     
%     if gamma1>90, gamma1 = 180-gamma1; end    
%     beta1 = 90-gamma1;
    
    
    u_star = sqrt(abs((eigVal(1,1)-eigVal(3,3)).*sind(beta1).*cosd(beta1)));
    
    
else
    error('the variable ''method'' is undefined');
end

if nargout==2
    [R] = reynoldsStressTensor(u,v,w);
    varargout{1}= R;
end


u_star(isinf(u_star))=NaN;
u_star(u_star==0)=NaN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [R] = reynoldsStressTensor(u,v,w)
        %         [R] = reynoldsStressTensor(u,v,w) computes the Reynolds stress
        %         matrix
        u = nandetrend(u);
        v = nandetrend(v);
        w = nandetrend(w);
        
        
        R(1,1) = nanvar(u);
        R(2,2) = nanvar(v);
        R(3,3) = nanvar(w);
        
        R(1,2) = nanmean(u(:)'.*v(:)');
        R(2,3) = nanmean(v(:)'.*w(:)');
        R(1,3) = nanmean(u(:)'.*w(:)');
        
        R(2,1)=R(1,2);
        R(3,1)=R(1,3);
        R(3,2)=R(2,3);
        
    end
    function y = nandetrend(x)
        % I am not the original author of this function. You can find it at:
        % http://gru.stanford.edu/svn/matlab/nandetrend.m
        
        
        %  Reshape x if necessary, assuming the dimension to be
        %  detrended is the first
        
        szx = size(x); ndimx = length(szx);
        if ndimx > 2;
            x = reshape(x, szx(1), prod(szx(2:ndimx)));
        end
        
        n = size(x,1);
        if n == 1,
            x = x(:);			% If a row, turn into column vector
        end
        [N, m] = size(x);
        y = repmat(NaN, [N m]);
        
        for i = 1:m;
            kp = find(~isnan(x(:,i)));
            a = [(kp-1)/(max(kp)-min(kp)) ones(length(kp), 1)];  %  Build regressor
            y(kp,i) = x(kp,i) - a*(a\x(kp,i));
        end
        
        if n == 1
            y = y.';
        end
        
        %  Reshape output so it is the same dimension as input
        
        if ndimx > 2;
            y = reshape(y, szx);
        end
    end
end

