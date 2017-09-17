% EM pivot calibration
trial = 'debug-a';

empivot_struct = ReadFile(['pa1-',trial,'-empivot.txt']);

em_markers_probe_reference = empivot_struct.frames{1}.em_markers_probe;
center_em_markers_probe = mean(em_markers_probe_reference, 2);
em_markers_probe_reference_centered = em_markers_probe_reference - ...
    repmat(center_em_markers_probe, 1, size(em_markers_probe_reference,2));

num_frames = length(empivot_struct.frames);
em_markers_rel_tracker = zeros([size(em_markers_probe_reference), num_frames-1]);
for i = 2:num_frames
    em_markers_rel_tracker(:,:,i-1) = empivot_struct.frames{i}.em_markers_probe;
end
em_markers_rel_tracker
size(em_markers_rel_tracker)
[post, tip] = PivotCalibration(em_markers_probe_reference_centered, em_markers_rel_tracker)