function plotCoh_diamond(freq,f1,meanU,CoeffDecay,cohU,cohV,cohW,cohUW,ind1,ind2,dx,dy,dz,u_star0,geometry,coeffU,coeffV,coeffW,coeffUW,ind)







[Su,~,Sw,Suw] = getTargetSpectra(meanU,u_star0,geometry,f1,coeffU,coeffV,coeffW,coeffUW);

[cohU1] = cohDavenport(meanU(ind1,ind2),CoeffDecay.Cux,CoeffDecay.Cuy,CoeffDecay.Cuz,f1,dx(ind1,ind2),dy(ind1,ind2),dz(ind1,ind2));
[cohV1] = cohDavenport(meanU(ind1,ind2),CoeffDecay.Cvx,CoeffDecay.Cvy,CoeffDecay.Cvz,f1,dx(ind1,ind2),dy(ind1,ind2),dz(ind1,ind2));
[cohW1] = cohDavenport(meanU(ind1,ind2),CoeffDecay.Cwx,CoeffDecay.Cwy,CoeffDecay.Cwz,f1,dx(ind1,ind2),dy(ind1,ind2),dz(ind1,ind2));

cohUW1 = -0.5.*(cohU1+cohW1).*sqrt(Suw(:,ind2)'.*Suw(:,ind1)'./(Su(:,ind2).*Sw(:,ind1))');

subplot(3,4,ind)
semilogx(freq,squeeze(nanmedian(cohU(ind1,ind2,:,:),4)),'r.',f1,cohU1,'k');
% legend('Computed','Target','location','southwest')
hold on; box on
ylim([-1 1])
xlim([0 2])
if ind >=9,
xlabel('$f$ (Hz)','interpreter','latex')
end
ylabel('$\gamma_{uu} (d_x,d_y,f)$','interpreter','latex')
% ylim([max([-1,4*min([0;squeeze(nanmean(cohU(ind1,ind2,:,:),4))])]) 1])

titlestring = ['$ e_',num2str(ind1),'$ - ','$ e_',num2str(ind2),'$'];
fth = text(.03,0.03,titlestring,'units','normalized','verticalalignment','bottom');
set(gcf,'CurrentAxes',gca,'name',titlestring);
set(fth,'interpreter','latex')


subplot(3,4,ind+1)
semilogx(freq,squeeze(nanmedian(cohV(ind1,ind2,:,:),4)),'r.',f1,cohV1,'k');
hold on; box on
ylim([-1 1])
xlim([0 2])
if ind >=9,
xlabel('$f$ (Hz)','interpreter','latex')
end
ylabel('$\gamma_{vv} (d_x,d_y,f)$','interpreter','latex')
% ylim([max([-1,4*min([0;squeeze(nanmean(cohU(ind1,ind2,:,:),4))])]) 1])

titlestring = ['$ e_',num2str(ind1),'$ - ','$ e_',num2str(ind2),'$'];
fth = text(.03,0.03,titlestring,'units','normalized','verticalalignment','bottom');
set(gcf,'CurrentAxes',gca,'name',titlestring);
set(fth,'interpreter','latex')

subplot(3,4,ind+2)
semilogx(freq,squeeze(nanmedian(cohW(ind1,ind2,:,:),4)),'r.',f1,cohW1,'k');
hold on; box on
ylim([-1 1])
xlim([0 2])
if ind >=9,
xlabel('$f$ (Hz)','interpreter','latex')
end
ylabel('$\gamma_{ww} (d_x,d_y,f)$','interpreter','latex')
% ylim([max([-1,4*min([0;squeeze(nanmean(cohU(ind1,ind2,:,:),4))])]) 1])

titlestring = ['$ e_',num2str(ind1),'$ - ','$ e_',num2str(ind2),'$'];
fth = text(.03,0.03,titlestring,'units','normalized','verticalalignment','bottom');
set(gcf,'CurrentAxes',gca,'name',titlestring);
set(fth,'interpreter','latex')

subplot(3,4,ind+3)
semilogx(freq,squeeze(nanmedian(cohUW(ind1,ind2,:,:),4)),'r.',f1,cohUW1,'k');
hold on; box on
ylim([-1 1])
xlim([0 2])
if ind >=9,
xlabel('$f$ (Hz)','interpreter','latex')
end
ylabel('$\gamma_{uw} (d_x,d_y,f)$','interpreter','latex')
% ylim([max([-1,4*min([0;squeeze(nanmean(cohU(ind1,ind2,:,:),4))])]) 1])

titlestring = ['$ e_',num2str(ind1),'$ - ','$ e_',num2str(ind2),'$'];
fth = text(.03,0.83,titlestring,'units','normalized','verticalalignment','bottom');
set(gcf,'CurrentAxes',gca,'name',titlestring);
set(fth,'interpreter','latex')

set(gcf,'color','w')


%     function [coh] = cohEC_3D(meanU,meanZ,Cx,Cy,Cz,f,dx,dy,dz,component)
%         
%         % longitudinal separation
%         a1x = Cx(1).*dx.*f./meanU;
%         a2x = Cx(2).*dx./meanU;
%         
%         % lateral separation
%         a1y = Cy(1).*dy.*f./meanU;
%         a2y = Cy(2).*dy./meanU;
%         % vertical separation
%         a1z = Cz(1).*dz.*f./meanU;
%         a2z = Cz(2).*dz./meanU;
%         a3z = Cz(3).*dz.*f./meanU;
%         
%         AA = exp(-sqrt(a1x.^2+a1y.^2+a1z.^2+a2x.^2+a2y.^2+a2z.^2)); % Modified Davenport
%         BB = exp(-dz.*a3z./meanZ); % Term from Bowen et al (1984)
%         
%         if strcmpi(component,'v')
%             s = 3*dz./meanZ;
%             fr = f.*dz./meanU;
%             phi = 2*pi.*fr.*s;
%             coh = AA.*BB.*cos(2*pi*f.*dx./meanU + phi);
%         elseif strcmpi(component,'u')
%             s = 1.3*dz./meanZ;
%             fr = f.*dz./meanU;
%             phi = 2*pi.*fr.*s;
%             coh = AA.*BB.*cos(2*pi*f.*dx./meanU + phi);
%         else
%             coh = AA.*BB.*cos(2*pi*f.*dx./meanU);
%         end
%         
%     end
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
        
        coh = exp(-sqrt(a1x.^2+a1y.^2+a1z.^2+a2x.^2+a2y.^2+a2z.^2)./meanU).*cos(2*pi*f.*dx./meanU); % Modified Davenport
    end
end

