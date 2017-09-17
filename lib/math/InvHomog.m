function T_inv = InvHomog(T)
% INVHOMOG Compute the inverse of a 4x4 homogeneous transformation.
R_inv = T(1:3,1:3)';
t_inv = -R_inv*T(1:3,4);
T_inv = RTtoHomog(R_inv, t_inv);
end
