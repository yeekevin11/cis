function transformation = RigidRegistration(pts_a, pts_b)
% RIGIDREGISTRATION Calculate the rigid homogeneous transformation from
% frame A to frame B. pts_a = transformation*pts_b
% pts_a: points relative to frame A (size: 3xN)
% pts_b: points relative to frame B (size: 3xN)

assert(length(pts_a) == length(pts_b), 'Point clouds must be the same size');
num_pts = length(pts_a);

% Center each point cloud
a_center = mean(pts_a,2);
b_center = mean(pts_b,2);
centered_a = pts_a - repmat(a_center, 1, num_pts);
centered_b = pts_b - repmat(b_center, 1, num_pts);

% Calculate rotation based on singular value decomposition
H = centered_b * centered_a';
[U,~,V] = svd(H);
R = V*U';

if ~FuzzyEquals(det(R), 1)
    V(:,3) = -V(:,3);
    R = V*U';
end

% Confirm that R is in fact a rotation matrix
assert(FuzzyEquals(det(R), 1, 1e-10), 'Determinant not equal to zero! Not a rotation matrix!');
assert(FuzzyEquals(R'*R, eye(3), 1e-10), 'Transpose not equal to inverse! Not a rotation matrix!');

% Calculate translation from the center of the point clouds
t = a_center - R*b_center;
transformation = RTtoHomog(R, t);
end
