function R = RotY(theta)
% ROTY Compute a rotation matrix about the Y axis.
R = [ cos(theta), 0, sin(theta);
               0, 1,          0;
     -sin(theta), 0, cos(theta)];
end
