% EM pivot calibration
trial = 'debug-a';

% Read file
empivot_struct = ReadFile(['pa1-',trial,'-empivot.txt']);

% Calculate positions of markers on probe with respect to probe local frame
em_markers_on_probe_ref = empivot_struct.frames{1}.em_markers_on_probe_rel_em_base;
center_em_markers_on_probe = mean(em_markers_on_probe_ref, 2);
em_markers_on_probe_rel_probe = em_markers_on_probe_ref - ...
    repmat(center_em_markers_on_probe, 1, size(em_markers_on_probe_ref,2));

% Extract contents from struct.
num_frames = empivot_struct.num_frames;
em_markers_on_probe_rel_em_base = zeros(3, empivot_struct.num_em_markers_on_probe, num_frames-1);
for i = 2:num_frames
    em_markers_on_probe_rel_em_base(:,:,i-1) = ...
        empivot_struct.frames{i}.em_markers_on_probe_rel_em_base;
end
[post, tip] = PivotCalibration(em_markers_on_probe_rel_probe, em_markers_on_probe_rel_em_base)