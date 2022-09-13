function plotSPectra(meanU,u,v,w,fs,t,u_star0,geometry,coeffU,coeffV,coeffW,coeffUW)

% load('windData_TD_No.mat')
N = numel(t);
if numel(size(u))==3
    Nsamples = size(u,3);
else
    Nsamples = 1;
end
tmax = t(end);
Nfft = round(N./(tmax/600));


if mod(Nfft,2)
    Su0 = zeros(round(Nfft/2),Nsamples);
    Sv0 = zeros(round(Nfft/2),Nsamples);
    Sw0 = zeros(round(Nfft/2),Nsamples);
    Suw0 = zeros(round(Nfft/2),Nsamples);
else
    Su0 = zeros(round(Nfft/2)+1,Nsamples);
    Sv0 = zeros(round(Nfft/2)+1,Nsamples);
    Sw0 = zeros(round(Nfft/2)+1,Nsamples);
    Suw0 = zeros(round(Nfft/2)+1,Nsamples);
end
for indSample= 1:Nsamples
    tic
    [Su0(:,indSample),f0]=pwelch(detrend(squeeze(u(:,1,indSample))),Nfft,round(Nfft/2),Nfft,fs);
    [Sv0(:,indSample),f0]=pwelch(detrend(squeeze(v(:,1,indSample))),Nfft,round(Nfft/2),Nfft,fs);
    [Sw0(:,indSample),~]=pwelch(detrend(squeeze(w(:,1,indSample))),Nfft,round(Nfft/2),Nfft,fs);
    [Suw0(:,indSample),~]=cpsd(detrend(squeeze(u(:,1,indSample))),detrend(w(:,1,indSample)),Nfft,round(Nfft/2),Nfft,fs);
    toc
end


f3 = logspace(log10(f0(2)*0.8),log10(f0(end)),100);

[newSu,~] = binAveraging(nanmean(Su0,2),f0,f3);
[newSv,~] = binAveraging(nanmean(Sv0,2),f0,f3);
[newSw,~] = binAveraging(nanmean(Sw0,2),f0,f3);
[newSuw,newF] = binAveraging(real(nanmean(Suw0,2)),f0,f3);

newSu(isnan(newF)) = [];
newSv(isnan(newF)) = [];
newSw(isnan(newF)) = [];
newSuw(isnan(newF)) = [];
newF(isnan(newF)) = [];


f1 = logspace(log10(f0(2)),log10(f0(end)),50);

[Su,Sv,Sw,Suw] = getTargetSpectra(meanU,u_star0,geometry,f1,coeffU,coeffV,coeffW,coeffUW);
clf; close all;
figure
semilogx(f1,f1(:).*Su(:,1)./u_star0.^2,'k',f1,f1(:).*Sv(:,1)./u_star0.^2,'r',f1,f1(:).*Sw(:,1)./u_star0.^2,'b',f1,f1(:).*Suw(:,1)./u_star0.^2,'g')
hold on; box on;
semilogx(newF,newF.*newSu./u_star0.^2,'k.',newF,newF.*newSv./u_star0.^2,'r.',newF,newF.*newSw./u_star0.^2,'b.',newF,newF.*newSuw./u_star0.^2,'g.','markersize',8)
% hold on
% plot([1 10],0.3*[1 10].^(-2/3),'m')
xlabel('f (Hz)')
ylabel('fS_i/u^2_* (Hz)')
axis tight
set(gcf,'color','w')
legend('i=u','i=v','i=w','i=uw')
xlim([f0(2),f0(end)])



end

