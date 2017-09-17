% Optical Calibration
clear all
trial = 'debug-b';

% Read files
calbody_struct = ReadFile(['pa1-',trial,'-calbody.txt']);
optpivot_struct = ReadFile(['pa1-',trial,'-optpivot.txt']);

num_frames = optpivot_struct.num_frames;
num_opt_markers_on_em_base = calbody_struct.num_opt_markers_on_em_base;
num_opt_markers_on_probe = optpivot_struct.num_opt_markers_on_probe;

% Calculate transformation from EM base to optical tracker. This is
% necessary because the optical tracker pose relative to the EM base for
% any given frame, while the EM base is always fixed.
opt_markers_on_em_base_rel_em_base = calbody_struct.opt_markers_on_em_base_rel_em_base;
pose_em_base_to_opt_tracker = zeros(4,4,num_frames);
for i = 1:num_frames
    opt_markers_on_em_base_rel_opt_tracker = optpivot_struct.frames{i}.opt_markers_on_em_base_rel_opt_tracker;
    pose_em_base_to_opt_tracker(:,:,i) = RigidRegistration( ...
        opt_markers_on_em_base_rel_em_base, opt_markers_on_em_base_rel_opt_tracker);
end

% Calculate positions of markers on probe with respect to probe local frame
opt_markers_on_probe = optpivot_struct.frames{1}.opt_markers_on_probe_rel_opt_tracker;
center_opt_markers_on_probe = mean(opt_markers_on_probe, 2);
opt_markers_on_probe_rel_probe = opt_markers_on_probe - ...
    repmat(center_opt_markers_on_probe, 1, size(opt_markers_on_probe,2));

% Optical markers on probe are relative to optical tracker. Transform them
% to be relative to the EM base. See above for rationale.
opt_markers_on_probe_rel_em_base = zeros([3, num_opt_markers_on_probe, num_frames-1]);
for i = 2:num_frames
    opt_markers_on_probe_rel_opt_tracker = optpivot_struct.frames{i}.opt_markers_on_probe_rel_opt_tracker;
    opt_markers_on_probe_rel_opt_tracker_hg = [opt_markers_on_probe_rel_opt_tracker; 
                                               ones(1, num_opt_markers_on_probe)];
    opt_markers_on_probe_rel_em_base_hg = pose_em_base_to_opt_tracker(:,:,i) * opt_markers_on_probe_rel_opt_tracker_hg;
    opt_markers_on_probe_rel_em_base(:,:,i-1) = opt_markers_on_probe_rel_em_base_hg(1:3,:);
end

% Perform pivot calibration
[post_position_rel_em_base, tip_position_em_base] = ...
    PivotCalibration(opt_markers_on_probe_rel_probe, opt_markers_on_probe_rel_em_base)


