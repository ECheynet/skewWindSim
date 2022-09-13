function [Su,Sv,Sw,Suw] = getTargetSpectra(meanU,u_star0,geometry,f,coeffU,coeffV,coeffW,coeffUW)

Nfreq = numel(f);
Nyy = numel(geometry.element.X);

Su = zeros(Nfreq,Nyy);
Sv = zeros(Nfreq,Nyy);
Sw = zeros(Nfreq,Nyy);
Suw = zeros(Nfreq,Nyy);

for pp=1:Nyy
    fr = f.*geometry.element.Z(pp)./meanU(pp); % reduced frequency
    Su(:,pp) =  (u_star0.^2).* coeffU.*(geometry.element.Z(pp)./meanU(pp))./(1+(coeffU/0.3).^(3/5).*fr).^(5/3); % Kaimal model (NOT normalized)
    Sv(:,pp) =  (u_star0.^2).* coeffV.*(geometry.element.Z(pp)./meanU(pp))./(1+(coeffV/0.4).^(3/5).*fr).^(5/3); % Kaimal model (NOT normalized)
    Sw(:,pp) =  (u_star0.^2).*coeffW.*(geometry.element.Z(pp)./meanU(pp))./(1+coeffW/0.4.*fr.^(5/3)); % Modified Kaimal model  (NOT normalized)
    Suw(:,pp) = (u_star0.^2).*(-coeffUW.*(geometry.element.Z(pp)./meanU(pp))./(1+0.75*coeffUW*fr).^(7/3)); % Corrected Kaimal cross-spectrum model (NOT normalized)
end

end

