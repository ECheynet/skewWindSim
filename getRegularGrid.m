function [geometry] = getRegularGrid(minZ,Zlim,Ylim,dy,dz)

z = [];
y = [];


minZ = max(1,minZ);

minY = -Ylim/2;
Zlim = Zlim+ dz;
z1 = [(minZ-dz)/2:dz:(Zlim)];
y1 = (minY-dy).*ones(1,numel(z1));

for ii=1:numel(minY:dy:-minY)
    y = [y,y1+dy*ii];
    if mod(ii,2)==1
        z = [z,fliplr(z1)];
    else
        z = [z,(z1)];
    end  
end

y = y(:);
z = z(:);


x = zeros(size(y));

% Nodes
geometry.node.X = x; % must be [1 x M]
geometry.node.Y = y; % must be [1 x M]
geometry.node.Z = z;
% elements whose coordinates are at midpoint between the elements
geometry.element.X =  (geometry.node.X(2:end)+geometry.node.X(1:end-1))/2;
geometry.element.Y = (geometry.node.Y(2:end)+geometry.node.Y(1:end-1))/2;
geometry.element.Z = (geometry.node.Z(2:end)+geometry.node.Z(1:end-1))/2;



geometry.node.Z(geometry.node.Z<0) = 0.1;
geometry.element.Z(geometry.element.Z<0) = 0.1;



end