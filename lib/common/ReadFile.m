function output = ReadFile(filename)
file_id = fopen(filename);
file_title = strsplit(fgetl(file_id), ',');

if contains(filename, 'calbody')
    % File header
    output.num_opt_markers_on_em_base = str2double(file_title{1});
    output.num_opt_markers_on_cal_object = str2double(file_title{2});
    output.num_em_markers_on_cal_object = str2double(file_title{3});

    % Optical markers on EM base relative to EM base
    output.opt_markers_on_em_base_rel_em_base = zeros(3, output.num_opt_markers_on_em_base);
    for i = 1:output.num_opt_markers_on_em_base
        output.opt_markers_on_em_base_rel_em_base(:,i) = ...
            ParsePoint(strsplit(fgetl(file_id),','));
    end
    
    % Optical markers on calibration object relative to calibration object
    output.opt_markers_on_cal_object_rel_cal_object = zeros(3, output.num_opt_markers_on_cal_object);
    for i = 1:output.num_opt_markers_on_cal_object
        output.opt_markers_on_cal_object_rel_cal_object(:,i) = ...
            ParsePoint(strsplit(fgetl(file_id),','));
    end
    
    % EM markers on calibration object relative to calibration object
	output.em_markers_on_cal_object_rel_cal_object = zeros(3, output.num_em_markers_on_cal_object);
    for i = 1:output.num_em_markers_on_cal_object
        output.em_markers_on_cal_object_rel_cal_object(:,i) = ...
            ParsePoint(strsplit(fgetl(file_id),','));
    end
elseif contains(filename, 'calreadings')
    % File header
    output.num_opt_markers_on_em_base = str2double(file_title{1});
    output.num_opt_markers_on_cal_object = str2double(file_title{2});
    output.num_em_markers_on_cal_object = str2double(file_title{3});
    output.num_frames = str2double(file_title{4});
    
    % Loop over all frames
    output.frames = cell(1,output.num_frames);
    for i = 1:output.num_frames
        % Optical markers on EM base relative to optical tracker
        output.frames{i}.opt_markers_on_em_base_rel_opt_tracker = zeros(3, output.num_opt_markers_on_em_base);
        for j = 1:output.num_opt_markers_on_em_base
            output.frames{i}.opt_markers_on_em_base_rel_opt_tracker(:,j) = ...
                ParsePoint(strsplit(fgetl(file_id),','));
        end
        
        % Optical markers on calibration object relative to optical tracker
        output.frames{i}.opt_markers_on_cal_object_rel_opt_tracker = zeros(3, output.num_opt_markers_on_cal_object);
        for j = 1:output.num_opt_markers_on_cal_object
            output.frames{i}.opt_markers_on_cal_object_rel_opt_tracker(:,j) = ...
                ParsePoint(strsplit(fgetl(file_id),','));
        end
        
        % EM markers on calibration object relative to EM base
        output.frames{i}.em_markers_on_cal_object_rel_em_base = zeros(3, output.num_em_markers_on_cal_object);
        for j = 1:output.num_em_markers_on_cal_object
            output.frames{i}.em_markers_on_cal_object_rel_em_base(:,j) = ...
                ParsePoint(strsplit(fgetl(file_id),','));
        end        
    end
elseif contains(filename, 'empivot')
    % File header
    output.num_em_markers_on_probe = str2double(file_title{1});
    output.num_frames = str2double(file_title{2});

    % Loop over all frames
    output.frames = cell(1, output.num_frames);
    for i = 1:output.num_frames
        % EM markers on probe relative to EM tracker
        output.frames{i}.em_markers_on_probe_rel_em_base = zeros(3, output.num_em_markers_on_probe);
        for j = 1:output.num_em_markers_on_probe
            output.frames{i}.em_markers_on_probe_rel_em_base(:,j) = ...
                ParsePoint(strsplit(fgetl(file_id),','));
        end
    end
elseif contains(filename, 'optpivot')
    % File header
    output.num_opt_markers_on_em_base = str2double(file_title{1});
    output.num_opt_markers_on_probe = str2double(file_title{2});
    output.num_frames = str2double(file_title{3});
    
    % Loop over all frames
    output.frames = cell(1, output.num_frames);
    for i = 1:output.num_frames
        % Optical markers on EM base relative to optical tracker
        output.frames{i}.opt_markers_on_em_base_rel_opt_tracker = zeros(3, output.num_opt_markers_on_em_base);
        for j = 1:output.num_opt_markers_on_em_base
             output.frames{i}.opt_markers_on_em_base_rel_opt_tracker(:,j) = ...
                 ParsePoint(strsplit(fgetl(file_id),','));           
        end
        
        % Optical markers on probe relative to optical tracker
        output.frames{i}.opt_markers_on_probe_rel_opt_tracker = zeros(3, output.num_opt_markers_on_probe);
        for j = 1:output.num_opt_markers_on_probe
             output.frames{i}.opt_markers_on_probe_rel_opt_tracker(:,j) = ...
                 ParsePoint(strsplit(fgetl(file_id),','));           
        end
    end
else
    error('Unknown file!');
end

end

function point = ParsePoint(line)
x = str2double(line{1});
y = str2double(line{2});
z = str2double(line{3});
point = [x;y;z];
end

