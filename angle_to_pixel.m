function op_pixel = angle_to_pixel(ip_angle)
%% description:
%       transfer all vision angle unit to pixel unit
%       according to pre-set standard angle and pixel size ["std_angle, std_pixel"]
%
%% Input arg:
%       "ip_angle": vision angle size
%
%% >> output arg:
%       "op_pixel": pixel size

    % angle-pixel standard setting
    std_angle = 21; %%%% standard vision angle
    std_pixel = 880; %%%% standard length in pixels
    
    ip_angle = ip_angle / 180 * pi;
    std_angle = std_angle / 180 * pi;
    op_pixel = tan(ip_angle/2) * std_pixel / tan(std_angle/2);
    op_pixel = ceil(op_pixel); %%%% round to integer;
    
end