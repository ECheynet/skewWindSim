function [u,v,w,newT,dx,dy,N] = windSim4D(f,Su,Sv,Sw,CoeffDecay,U,geometry,windDirection,varargin)

% options: default values
p = inputParser();
p.CaseSensitive = false;
p.addOptional('Suw',zeros(size(Su)));
p.addOptional('eddySlopeU',0); % per default, no eddy slope (Bowen et al. 1983)
p.addOptional('eddySlopeV',0); % per default, no eddy slope although Bowen et al use eddySlopeV= 3
p.addOptional('eddySlopeW',0); % per default, no eddy slope (Bowen et al. 1983)
p.parse(varargin{:});
Suw = p.Results.Suw ;
eddySlopeU = p.Results.eddySlopeU ;
eddySlopeV = p.Results.eddySlopeV ;
eddySlopeW = p.Results.eddySlopeW ;
%% Rename variables for the sake of brevity

% x-direction
Cux = CoeffDecay.Cux;
Cvx = CoeffDecay.Cvx;
Cwx = CoeffDecay.Cwx;
% y-direction
Cuy = CoeffDecay.Cuy;
Cvy = CoeffDecay.Cvy;
Cwy = CoeffDecay.Cwy;
% z-direction
Cuz = CoeffDecay.Cuz;
Cvz = CoeffDecay.Cvz;
Cwz = CoeffDecay.Cwz;

%% Rotate coordiantes such that the wind direction is equaivalent to "zero"
windDirection0 = windDirection;
windDirection(windDirection>180)= windDirection(windDirection>180)-180;
windDirection(windDirection<-180)= windDirection(windDirection<-180)+180;
    
Z = geometry.element.Z(:);
M = numel(geometry.element.Y);
X = nan(M,1);
Y = nan(M,1);
for jj = 1:M
    if numel(windDirection)==numel(Z)
        R = [cosd(windDirection(jj)),-sind(windDirection(jj));sind(windDirection(jj)) cosd(windDirection(jj))];
    else
        R = [cosd(windDirection),-sind(windDirection);sind(windDirection) cosd(windDirection)];
    end
    A = R*[geometry.element.X(jj);geometry.element.Y(jj)];
    X(jj)=A(1);
    Y(jj)=A(2);
end
Origin = [1e5*cosd(90),1e5.*sind(90)];
meanZ = 0.5*abs(bsxfun(@plus,geometry.element.Z(:)',geometry.element.Z(:)));
dz = abs(bsxfun(@minus,Z(:)',Z(:)));
indRef = nearestneighbour(Origin', [X(:)';Y(:)']);
fprintf(['Element no ',num2str(indRef),' is the first impacted by the wind from ',num2str(windDirection0(indRef)),' degrees \n'])

dy = abs(X(:)'-X(:)); % x is the horizontal component in a cartesian grid but dy is the crosswind distancewith Dir = 0 (Northern direction)
dx = abs(Y(:)'-Y(:)); % y is the horizontal component in a cartesian grid but dx is the along-wind distance with Dir = 0 (Northern direction)
meanU = 0.5*abs(U(:)'+U(:)); % either nodes or elements

%% Time and frequency definition

if min(size(Su))==1
    Nfreq = numel(Su); % Nfreq = N/2 (normally)
else
    [Nfreq] = size(Su,1);
end

Nmax = 2*Nfreq; % N is the numbe rof time steps
dt = 1/(2*f(end)); % time step
t = [0:Nmax-1].*dt;

M3 = 3*M; % 3 variables: u, v and w


%% Main loop

tic

i2pi = 1i*2*pi;
A = zeros(Nfreq,M3);
for ii=2:Nfreq % The first frequency is zero
    randPhase = rand(M3,1);
    [cohU] = cohDavenport(meanU,Cux,Cuy,Cuz,f(ii),dx,dy,dz);
    [cohV] = cohDavenport(meanU,Cvx,Cvy,Cvz,f(ii),dx,dy,dz);
    [cohW] = cohDavenport(meanU,Cwx,Cwy,Cwz,f(ii),dx,dy,dz);
    [cohUW] = -0.5*(cohU + cohW);    
    Suu = sqrt(Su(ii,:)'*Su(ii,:)).*cohU;
    Sww = sqrt(Sw(ii,:)'*Sw(ii,:)).*cohW;
    Suw2 = sqrt(Suw(ii,:)'*Suw(ii,:)).*cohUW;
    Svv = sqrt(Sv(ii,:)'*Sv(ii,:)).*cohV;
    Svu2 = zeros(size(Svv));
    Svw2 = zeros(size(Svv));
    S = [Suu,Svu2,Suw2;Svu2,Svv,Svw2;Suw2,Svw2,Sww];
    %     tic
    [L,D]=ldl(S,'lower'); % a LDL decomposition is applied this time
    G = L*sqrt(D);
    A(ii,:)= G*exp(i2pi*randPhase);
end

toc
%% Phase differences from yaw angle
% Time delay with fft
if size(Y,1)>size(Y,2)
    U = U(:);
else
    U = U(:)';
end
DT = (Y(indRef)-Y)./U; % Y is the along-wind distance with dir = 0
Delay = exp(-1i.*2*pi*f(:)*repmat(DT(:),3,1)');

%% Model the phase differences from mean wind shear
[~,indRefZ] = min(Z); % last point to be reached by the eddies
zm = 0.5*(Z+Z(indRefZ)); % averaged height based on indRefZ
um = 0.5*(U+U(indRefZ));  % averaged speed based on indRefZ

su = eddySlopeU*(Z-Z(indRefZ))./zm; % eddy slope s for u
sv = eddySlopeV*(Z-Z(indRefZ))./zm; % eddy slope s for v
sw = eddySlopeW*(Z-Z(indRefZ))./zm; % eddy slope s for v

DZ = (Z-Z(indRefZ))./um(:); % time delay due to eddy slope

Delay_eddySlope = ones(numel(f),3*M);
Delay_eddySlope(:,1:M) =  exp(-1i.*2*pi*f(:)*(su.*DZ)');
Delay_eddySlope(:,M+1:2*M) =  exp(-1i.*2*pi*f(:)*(sv.*DZ)');
Delay_eddySlope(:,2*M+1:3*M) =  exp(-1i.*2*pi*f(:)*(sw.*DZ)');

%% Introduce phase differences from both yaw angle mean wind shear
A = A.*Delay.*Delay_eddySlope;

% Mirror A around the Nyquist frequency
Nu = [A(1:Nfreq,:) ; real(A(Nfreq,:)); conj(flipud(A(2:Nfreq,:)))];
%% IFFT

speed=real(ifft(Nu).*sqrt(Nfreq./(dt)));
u = speed(:,1:M);
v = speed(:,M+1:2*M);
w = speed(:,2*M+1:3*M);

% Remove time steps at time before the first point impacted by the gust
[~,indMaxDelay] = min(abs(max(abs(DT))-t));
u = u(indMaxDelay:Nmax,:);
v = v(indMaxDelay:Nmax,:);
w = w(indMaxDelay:Nmax,:);
newT = t(indMaxDelay:Nmax)';
newT = newT-newT(1);

N = size(u,1);

    function [coh] = cohDavenport(meanU,Cx,Cy,Cz,f,dx,dy,dz)
               
        % longitudinal separation
        a1x = Cx(1).*dx.*f;
        a2x = Cx(2).*dx;
        
        % lateral separation
        a1y = Cy(1).*dy.*f;
        a2y = Cy(2).*dy;
        
        % vertical separation
        a1z = Cz(1).*dz.*f;
        a2z = Cz(2).*dz;
        
        coh = exp(-sqrt(a1x.^2+a1y.^2+a1z.^2+a2x.^2+a2y.^2+a2z.^2)./meanU); % Modified Davenport
    end
end

