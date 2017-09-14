function w = Wedge3(w_hat)
% WEDGE3 Convert a 3x3 skew-symmetric matrix to a 3x1 vector
w = [w_hat(3,2); w_hat(1,3); w_hat(2,1)];
end
