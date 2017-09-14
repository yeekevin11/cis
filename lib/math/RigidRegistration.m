function T = RigidRegistration(pts_a, pts_b)
% RIGIDREGISTRATION Calculate the rigid homogeneous transformation from
% point cloud A to point cloud B. Both point clouds must be 3xN

assert(length(pts_a) == length(pts_b), 'Point clouds must be the same size');
num_pts = length(pts_a);

a_center = mean(pts_a,2);
b_center = mean(pts_b,2);

centered_a = pts_a - repmat(a_center, 1, num_pts);
centered_b = pts_b - repmat(b_center, 1, num_pts);

R = centered_b'\centered_a';
assert(FuzzyEquals(det(R), 1), 'Not a rotation matrix. Determinant ~= 1');
assert(FuzzyEquals(R'*R, eye(3)), 'Not a rotation matrix. Transpose ~= inverse');

% for i = 1:100
%     rotated_b = R'*centered_b;
%     skew_alpha = (centered_a'\(rotated_b' - centered_a'))'
%     R = R * (eye(3) + skew_alpha)
% end

t = b_center - R*a_center;
T = RTtoHomog(R, t);

end
