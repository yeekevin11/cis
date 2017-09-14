function R = RotX(theta)
% ROTX Compute a rotation matrix about the X axis.
R = [1,          0,           0;
     0, cos(theta), -sin(theta);
     0, sin(theta),  cos(theta)];
end
