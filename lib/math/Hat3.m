function w_hat = Hat3(w)
% HAT3 Convert a 3x1 vector to a 3x3 skew-symmetric matrix
w_hat = [    0, -w(3),  w(2);
          w(3),     0, -w(1);
         -w(2),  w(1),     0];
end
