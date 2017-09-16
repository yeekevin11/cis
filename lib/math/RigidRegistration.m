function T = RigidRegistration(pts_a, pts_b)
% RIGIDREGISTRATION Calculate the rigid homogeneous transformation from
% point cloud A to point cloud B. Both point clouds must be 3xN

assert(length(pts_a) == length(pts_b), 'Point clouds must be the same size');
num_pts = length(pts_a);

% Center each point cloud
a_center = mean(pts_a,2);
b_center = mean(pts_b,2);
centered_a = pts_a - repmat(a_center, 1, num_pts);
centered_b = pts_b - repmat(b_center, 1, num_pts);

% Calculate rotation based on singular value decomposition
H = centered_a * centered_b';
[U,~,V] = svd(H);
R = V*U';

% Confirm that R is in fact a rotation matrix
assert(FuzzyEquals(det(R), 1, 1e-10), 'Determinant not equal to zero! Not a rotation matrix!');
assert(FuzzyEquals(R'*R, eye(3), 1e-10), 'Transpose not equal to inverse! Not a rotation matrix!');

% Calculate translation from the center of the point clouds
t = b_center - R*a_center;
T = RTtoHomog(R, t);
end
