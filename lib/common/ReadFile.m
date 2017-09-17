function file_struct = ReadFile(filename)
file_id = fopen(filename);
file_title_line = fgetl(file_id);
file_title = strsplit(file_title_line, ',');

if contains(filename, 'calbody')
    % File header
    num_opt_markers_on_em_base = str2double(file_title{1});
    num_opt_markers_on_cal_object = str2double(file_title{2});
    num_em_markers_on_cal_object = str2double(file_title{3});

    % Optical markers on EM base (relative to EM base)
    file_struct.opt_markers_em_base = zeros(3, num_opt_markers_on_em_base);
    for i = 1:num_opt_markers_on_em_base
        file_struct.opt_markers_em_base(:,i) = ParsePoint(strsplit(fgetl(file_id),','));
    end
    
    % Optical markers on calibration object (relative to calibration object)
    file_struct.opt_markers_cal_object = zeros(3, num_opt_markers_on_cal_object);
    for i = 1:num_opt_markers_on_cal_object
        file_struct.opt_markers_cal_object(:,i) = ParsePoint(strsplit(fgetl(file_id),','));
    end
    
    % EM markers on calibration object (relative to calibration object)
	file_struct.em_markers_cal_object = zeros(3, num_em_markers_on_cal_object);
    for i = 1:num_em_markers_on_cal_object
        file_struct.em_markers_cal_object(:,i) = ParsePoint(strsplit(fgetl(file_id),','));
    end
elseif contains(filename, 'calreadings')
    % File header
    num_opt_markers_on_em_base = str2double(file_title{1});
    num_opt_markers_on_cal_object = str2double(file_title{2});
    num_em_markers_on_cal_object = str2double(file_title{3});
    num_frames = str2double(file_title{4});
    
    % Loop over all frames
    file_struct.frames = cell(1,num_frames);
    for i = 1:num_frames
        % Optical markers on EM base (relative to optical tracker)
        file_struct.frames{i}.opt_markers_em_base = zeros(3, num_opt_markers_on_em_base);
        for j = 1:num_opt_markers_on_em_base
            line = strsplit(fgetl(file_id),',');
            file_struct.frames{i}.opt_markers_em_base(:,j) = ParsePoint(line);
        end
        
        % Optical markers on calibration object (relative to optical tracker)
        file_struct.frames{i}.opt_markers_cal_object = zeros(3, num_opt_markers_on_cal_object);
        for j = 1:num_opt_markers_on_cal_object
            line = strsplit(fgetl(file_id),',');
            file_struct.frames{i}.opt_markers_cal_object(:,j) = ParsePoint(line);
        end
        
        % EM markers on calibration object (relative to EM tracker)
        file_struct.frames{i}.em_markers_cal_object = zeros(3, num_em_markers_on_cal_object);
        for j = 1:num_em_markers_on_cal_object
            line = strsplit(fgetl(file_id),',');
            file_struct.frames{i}.em_markers_cal_object(:,j) = ParsePoint(line);
        end        
    end
elseif contains(filename, 'empivot')
    % File header
    num_em_markers_probe = str2double(file_title{1});
    num_frames = str2double(file_title{2});

    % Loop over all frames
    file_struct.frames = cell(1, num_frames);
    for i = 1:num_frames
        % EM markers on probe (relative to EM tracker')
        file_struct.frames{i}.em_markers_probe = zeros(3, num_em_markers_probe);
        for j = 1:num_em_markers_probe
            file_struct.frames{i}.em_markers_probe(:,j) = ParsePoint(strsplit(fgetl(file_id),','));
        end
    end
elseif contains(filename, 'optpivot')
    % File header
    num_opt_markers_on_em_base = str2double(file_title{1});
    num_opt_markers_probe = str2double(file_title{2});
    num_frames = str2double(file_title{3});
    
    % Loop over all frames
    file_struct.frames = cell(1, num_frames);
    for i = 1:num_frames
        % Optical markers on EM base (relative to optical tracker)
        file_struct.frames{i}.opt_markers_em_base = zeros(3, num_opt_markers_on_em_base);
        for j = 1:num_opt_markers_on_em_base
             file_struct.frames{i}.opt_markers_em_base(:,j) = ParsePoint(strsplit(fgetl(file_id),','));           
        end
        
        % Optical markers on probe (relative to optical tracker)
        file_struct.frames{i}.opt_markers_probe = zeros(3, num_opt_markers_probe);
        for j = 1:num_opt_markers_probe
             file_struct.frames{i}.opt_markers_probe(:,j) = ParsePoint(strsplit(fgetl(file_id),','));           
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

