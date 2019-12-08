function [header, rf_data] = read_sonixRF(filename)

[~, ~, ext] = fileparts(filename);
if ~strcmp(ext,'.rf'), error('ERROR: Unexpected file format %s', ext); end

fp = fopen(filename, 'r');

hdr_field{1} = 'type';      % data type (can be determined by file extensions)
hdr_field{2} = 'frames';	% number of frames in file 
hdr_field{3} = 'w';         % width (number of vectors for raw, image width for processed data)
hdr_field{4} = 'h';         % height (number of samples for raw, image height for processed data)
hdr_field{5} = 'ss';        % data sample size in bits
hdr_field{6} = 'ulx';       % roi - upper left (x) 
hdr_field{7} = 'uly';       % roi - upper left (y) 
hdr_field{8} = 'urx';       % roi - upper right (x) 
hdr_field{9} = 'ury';       % roi - upper right (y) 
hdr_field{10} = 'brx';      % roi - bottom right (x) 
hdr_field{11} = 'bry';      % roi - bottom right (y) 
hdr_field{12} = 'blx';      % roi - bottom left (x) 
hdr_field{13} = 'bly';      % roi - bottom left (y) 
hdr_field{14} = 'probe';	% probe identifier - additional probe information can be found using this id   
hdr_field{15} = 'txf';      % transmit frequency in Hz
hdr_field{16} = 'sf';       % sampling frequency in Hz
hdr_field{17} = 'dr';       % data rate (fps or prp in Doppler modes)
hdr_field{18} = 'ld';       % line density (can be used to calculate element spacing if pitch and native # elements is known)
hdr_field{19} = 'extra';	% extra information (ensemble for color RF)

for ii = 1:19, header.(hdr_field{ii}) = double(fread(fp,1,'int32')); end

ensemble = ceil(header.w/header.ld); % Har-Res configuration uses pulse inversion technique (ensemble == 2)
header.w = header.w/ensemble; % raw_data width

n_samples = header.w*header.h*ensemble;
rf_data = zeros(header.frames, ensemble, header.w, header.h);

% % FC = zeros(header.frames, 2); % Frame Count (spatial compounding mode)
for jj = 1:header.frames
% %     FC(jj, :) = fread(fp,2,'uint32'); % The upper 4 bytes of the frame header will determine the angle count, whereas the lower 4 bytes always is correlated to the frame counter. 
    
    tmp = fread(fp, n_samples, 'int16');
    tmp = reshape(tmp, header.h, header.w*ensemble)';
    
    for kk = 1:ensemble
        rf_data(jj,kk,:,:) = tmp(kk:ensemble:end, :);
    end
end
fclose(fp);