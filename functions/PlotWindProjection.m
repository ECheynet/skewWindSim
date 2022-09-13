function PlotWindProjection(geometry,meanU,vx,vy,windDirection)

scale_factor = 0.2;
N = sqrt(diff(geometry.node.Y).^2+diff(geometry.node.X).^2);
diffY = diff(geometry.node.Y)./N;
diffX = diff(geometry.node.X)./N;

% Get eastern and northern wind components
M = numel(geometry.element.Z);
for jj=1:M
    if numel(windDirection) == M
        ROT = [cosd(90-windDirection(jj)) sind(90-windDirection(jj)); -sind(90-windDirection(jj)) cosd(90-windDirection(jj))];
    else
        ROT = [cosd(90-windDirection) sind(90-windDirection); -sind(90-windDirection) cosd(90-windDirection)];
    end
    dummy = ROT*[meanU(jj);0];
    Veast(jj) = -dummy(1);
    Vnorth(jj) = dummy(2);
end
% Get mean wind component along and across the deck
midVx = nanmean(vx); midVx = midVx(:);
midVy = nanmean(vy); midVy = midVy(:);

% clf;close all;
% figure
% plot the nodes
plot3(geometry.node.X,geometry.node.Y,geometry.node.Z,'k:','markersize',15,'linewidth',1)
box on; hold on;
grid on

% plot wind direction at each element

% Plot the along span and cross-span component component

X1 = scale_factor.*midVx(:).*diffY(:);
Y1 = -scale_factor.*midVx(:).*diffX(:);
X2 = scale_factor.*midVy(:).*diffX(:);
Y2 = scale_factor.*midVy(:).*diffY(:);
q1 = quiver3(geometry.element.X(:),geometry.element.Y(:),geometry.element.Z(:),Veast(:).*scale_factor,Vnorth(:).*scale_factor,0.*Vnorth(:),'b','linewidth',2);
q2 = quiver3(geometry.element.X(:),geometry.element.Y(:),geometry.element.Z(:),X1,Y1,0.*Vnorth(:),'m','linewidth',1.5); % crosspan
q3 = quiver3(geometry.element.X(:),geometry.element.Y(:),geometry.element.Z(:),-X2,-Y2,0.*Vnorth(:),'c','linewidth',1.5); % alongspan
q1.AutoScale = 'off';
q2.AutoScale = 'off';
q3.AutoScale = 'off';
view(0,90)

q1.ShowArrowHead = 'off';
q1.Marker = 'd';

q2.ShowArrowHead = 'off';
q2.Marker = 'o';

q3.ShowArrowHead = 'off';
q3.Marker = '.';

% axis equal
axis tight
xlabel('X')
ylabel('Y')

legend('Bridge','Wind Direction','Normal wind component (vx)','Axial wind component (vy)','location','eastoutside')
title(['wind Dir = ',num2str(nanmean(windDirection)),' deg; Veast = ',...
    num2str(round(abs(nanmean(Veast(:))*100))/100,2),' m/s; Vnorth = ',...
    num2str(round(abs(nanmean(Vnorth(:))*100))/100,2),' m/s'])

set(gcf,'color','w')

M = numel(geometry.element.X);
for ii=1:M
    fth = text(geometry.element.X(ii),geometry.element.Y(ii),num2str(ii),'horizontalalignment','left','verticalalignment','bottom','fontsize',10,'color','r','fontweight','bold');
    set(fth,'interpreter','latex')
end

hold off

end

