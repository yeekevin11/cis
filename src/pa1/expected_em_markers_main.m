% expected_em_markers_main.m
% Calculate the expected positions of the EM trackers on the calibration
% object relative to the EM tracker base. This is accomplished by using
% the transformations from the optical tracker to the EM tracker base and
% to the calibration object. 

% Change this variable to change the data set to be used.
trial = 'debug-a';

% Read data from file
calbody_struct = ReadFile(['pa1-',trial,'-calbody.txt']);
calreadings_struct = ReadFile(['pa1-',trial,'-calreadings.txt']);

num_frames = calreadings_struct.num_frames;
num_em_markers_on_cal_object = calbody_struct.num_em_markers_on_cal_object;

% d in figure
opt_markers_on_em_base_rel_em_base = calbody_struct.opt_markers_on_em_base_rel_em_base;
% a in figure
opt_markers_on_cal_object_rel_cal_object = calbody_struct.opt_markers_on_cal_object_rel_cal_object;
% c in figure (convert to homogeneous)
em_markers_on_cal_object_rel_cal_object = calbody_struct.em_markers_on_cal_object_rel_cal_object;
em_markers_on_cal_object_rel_cal_object_hg = ...
    [em_markers_on_cal_object_rel_cal_object; ones(1,num_em_markers_on_cal_object)];

em_markers_on_cal_object_rel_em_base_expected_hg = zeros(4, num_em_markers_on_cal_object, num_frames);
for i = 1:num_frames
    % D in figure
    opt_markers_on_em_base_rel_opt_tracker = ...
        calreadings_struct.frames{i}.opt_markers_on_em_base_rel_opt_tracker;
    transform_opt_tracker_to_em_base = RigidRegistration( ...
        opt_markers_on_em_base_rel_opt_tracker, opt_markers_on_em_base_rel_em_base);
    
    % A in figure
    opt_markers_on_cal_object_rel_opt_tracker = ...
        calreadings_struct.frames{i}.opt_markers_on_cal_object_rel_opt_tracker;
    transform_opt_tracker_to_cal_object = RigidRegistration( ...
        opt_markers_on_cal_object_rel_opt_tracker, opt_markers_on_cal_object_rel_cal_object);
    
    transform_em_base_to_cal_object = InvHomog(transform_opt_tracker_to_em_base) * transform_opt_tracker_to_cal_object;
    em_markers_on_cal_object_rel_em_base_expected_hg(:,:,i) =  transform_em_base_to_cal_object * ...
        em_markers_on_cal_object_rel_cal_object_hg;
end

em_markers_on_cal_object_rel_em_base_expected = em_markers_on_cal_object_rel_em_base_expected_hg(1:3,:,:)

