function T = RTtoHomog(R,t)
% RTTOHOMOG Combine a 3x3 rotation matrix and 3x1 translation vector into a
% 4x4 homogeneous transformation
T = eye(4);
T(1:3,1:3) = R;
T(1:3,4) = t;
end
