% em_pivot_calibration_main.m
% Perform pivot calibration using a probe with EM markers to obtain the
% position of the calibration post relative to the EM base.

% Change this variable to change the data set to be used.
trial = 'debug-a';

% Read data from file
empivot_struct = ReadFile(['pa1-',trial,'-empivot.txt']);

% Calculate positions of EM markers on probe with respect to the probe
% local frame. (g in figure)
em_markers_on_probe_ref = empivot_struct.frames{1}.em_markers_on_probe_rel_em_base;
center_em_markers_on_probe = mean(em_markers_on_probe_ref, 2);
em_markers_on_probe_rel_probe = em_markers_on_probe_ref - ...
    repmat(center_em_markers_on_probe, 1, size(em_markers_on_probe_ref,2));

% Extract frame data from struct (G in figure)
num_frames = empivot_struct.num_frames;
em_markers_on_probe_rel_em_base = zeros(3, empivot_struct.num_em_markers_on_probe, num_frames-1);
for i = 2:num_frames
    em_markers_on_probe_rel_em_base(:,:,i-1) = ...
        empivot_struct.frames{i}.em_markers_on_probe_rel_em_base;
end

% Perform pivot calibration
[post_position_rel_em_base, tip_position_rel_probe] = ...
    PivotCalibration(em_markers_on_probe_rel_probe, em_markers_on_probe_rel_em_base)

