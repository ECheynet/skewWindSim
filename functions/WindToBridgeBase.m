function [vx,vy] = WindToBridgeBase(u,v,windDirection,X,Y)



Orientation =180/pi.*atan2(diff(X),diff(Y));
vx = zeros(size(u));
vy = zeros(size(v));
M = numel(X)-1;

for jj = 1:M % for each element calculate the wind component normal to the deck
    if numel(windDirection)==M
        ROT = [cosd(windDirection(jj)-Orientation(jj)), sind(windDirection(jj)-Orientation(jj)); -sind(windDirection(jj)-Orientation(jj)), cosd(windDirection(jj)-Orientation(jj))];
    else
        ROT = [cosd(windDirection-Orientation(jj)), sind(windDirection-Orientation(jj)); -sind(windDirection-Orientation(jj)), cosd(windDirection-Orientation(jj))];
    end
    dummy = ROT*[u(:,jj)';v(:,jj)'];
    vy(:,jj) =  dummy(1,:);
    vx(:,jj) =  dummy(2,:);
end


end

