function R = RotZ(theta)
% ROTZ Compute a rotation matrix about the Z axis.
R = [cos(theta), -sin(theta), 0;
     sin(theta),  cos(theta), 0;
              0,           0, 1];
end
