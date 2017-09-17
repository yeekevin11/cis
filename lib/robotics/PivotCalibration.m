function [post_position, tip_position] = PivotCalibration(...
    markers_on_probe_rel_probe, markers_on_probe_rel_tracker)

num_frames = size(markers_on_probe_rel_tracker, 3);
cumulative_A = [];
cumulative_b = [];
for i = 1:num_frames
    pose_tracker_to_probe = RigidRegistration(...
        markers_on_probe_rel_tracker(:,:,i), markers_on_probe_rel_probe);
    rotation_tracker_to_probe = pose_tracker_to_probe(1:3,1:3);
    translation_tracker_to_probe = pose_tracker_to_probe(1:3,4);
    cumulative_A = [cumulative_A; [rotation_tracker_to_probe, -eye(3)]];
    cumulative_b = [cumulative_b; -translation_tracker_to_probe];
end
x = cumulative_A\cumulative_b;
tip_position = x(1:3);
post_position = x(4:6);

end
