function [tip_position, post_position] = PivotCalibration(...
    pts_rel_probe, pts_rel_tracker)

num_frames = size(pts_rel_tracker, 3);
cumulative_A = [];
cumulative_b = [];
for i = 1:num_frames
    pose_tracker_to_instrument = RigidRegistration(...
        pts_rel_probe, pts_rel_tracker(:,:,i));
    rotation_tracker_to_instrument = pose_tracker_to_instrument(1:3,1:3);
    translation_tracker_to_instrument = pose_tracker_to_instrument(1:3,4);
    cumulative_A = [cumulative_A; [rotation_tracker_to_instrument, -eye(3)]];
    cumulative_b = [cumulative_b; -translation_tracker_to_instrument];
end
x = cumulative_A\cumulative_b;
tip_position = x(1:3);
post_position = x(4:6);

end
