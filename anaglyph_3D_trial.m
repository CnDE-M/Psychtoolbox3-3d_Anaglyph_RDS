function [vbl] = anaglyph_3D_trial(vbl, RDS_frame_time, expr_parameter)
%% discription:
% Input experiment parameters, generate one dynamic RDS trial£¬ with 3 periods
% pre-fixation; fixation; subject report;
%  
%% Input arguments (unit in pixel) explain in sequence
%   >>>> session_name:
%        session name displayed in the start instruction page
%   >>>> "RDS_frame" = ["RDS_frame_num", "RDS_frame_time"]
%        "RDS_frame_num": RDS frame number
%        "RDS_frame_time": duration of one RDS
%   >>>> "expr_parameter" = ["vision_field", "per_correlate", "disparity_step", "radium_surrounding", "radium_innDisk",...
%                            "radium_outDisk", "dot_size", "ct_cross_size", "ct_cross_position" ];
%        "vision_field": 
%               0 - central(one cross within outer disk); 
%               1 - peripheral(two crosses one is within outer disk, while other is out of outer disk)
%       "per_correlate": percentage of correlated dots
%               0 = anti-correlate; 0.5 = half-correlated; 1 = correlated;]
%       "disparity_step": disparity per RDS.
%               + for "in front of"; - for "behind";
%       "radium_surrounding"£º in experiments 4&5 the dot within ( r, R1 ) are excluded, that is to turn color grey
%               for experiment 1-3, radium_surrounding == r("radium_inner");
%               for experiment 4-5, radium_surrounding > r("radium_inner");
%       "radium_innDisk": 
%               radium of inner disk, dots in which display disparity;
%       "radium_outDisk": 
%               radium of outer disk, dots in which display zero-disparity;
%       "dot_size": 
%               side length of square dot;
%       "ct_cross_size"; 
%               side length of fixation cross for central vision field
%       "ct_cross_position"; 
%                vertical distance from central vision fixation cross to disk center;
% 
%% Output arguments
%  >>>> "vd_response": whether subject identify stereogram 
%           1 - identify vision depth: in front of outer disk;
%           0 - not identify vision depth;
%          -1 - identify vision depth: behind outer disk;
%           2 - wrong input;


    %% /////////////////// Parameters ////////////////////////
    % parameters that are constant through all experiments
    global  dis_window grey win_xCenter win_yCenter
    dot_density = 0.1;
    fix_lineWidth = 4;
    pr_cross_size = angle_to_pixel(0.44);
    pr_cross_position = angle_to_pixel(10.1)-100;
    
    % load experiment parameters
    vision_field = expr_parameter(1);
    per_correlate = expr_parameter(2);
    disparity_step = expr_parameter(3);
    radium_surrounding = expr_parameter(4);
    radium_innDisk = expr_parameter(5);
    radium_outDisk = expr_parameter(6);
    dot_size = expr_parameter(7);
    ct_cross_size = expr_parameter(8);
    ct_cross_position = expr_parameter(9);

    %% Dots
    %  Initialize dors parameters including: dot size, postion and color
    
    % >>>> Dot Number
    % According to the constant dot density, calculate dots number in the frame
    dot_number=floor( (radium_outDisk^2) * pi * dot_density / dot_size^2); % constant area taken by dot
    
    % >>>> Dot position
    % randomly generate polar coordinate [theta. radium] centered at (0,0), then transfer to cartesian coordinates.
    dot_theta = rand(1,dot_number)*2*pi;
    if radium_innDisk < radium_surrounding
        % Expr 4-5, dot range in (0, r)&&(R1, R)
        % randomly generate dot radium in length (r+R-R1);
        dot_r = rand([1,dot_number])*(radium_innDisk+radium_outDisk-radium_surrounding);
        % move dot radium in (r, R1) to (R1-r)+(r, R1)£¬ so that dot will
        % not be within surrounding ring
        col_sr = 1:length(dot_r) .* (dot_r<=radium_surrounding) .* (dot_r>=radium_innDisk);
        dot_r(col_sr) = dot_r(col_sr) + (radium_surrounding - radium_innDisk);
    else
        % expr 1-3, dot radium in range (0, R)
        dot_r = rand([1,dot_number])*radium_outDisk;
    end
    
    % from polar coordinate to cartesion coordinate
    dot_x = ceil(dot_r .* cos(dot_theta));
    dot_y = ceil(dot_r .* sin(dot_theta));
    
    % dots square position
    dot_baseRect = [-dot_size/2, -dot_size/2, dot_size, dot_size];
    dot_baseRects = repmat(dot_baseRect,[dot_number,1])';
    dot_baseRects(1,:) = dot_baseRects(1,:) + dot_x + win_xCenter;
    dot_baseRects(3,:) = dot_baseRects(3,:) + dot_x + win_xCenter;
    dot_baseRects(2,:) = dot_baseRects(2,:) + dot_y + win_yCenter;
    dot_baseRects(4,:) = dot_baseRects(4,:) + dot_y + win_yCenter;
    
    %%%% select dots in inner disk or outer disk.
    % "dot_inner": 0 - outer disk; 1 - inner disk
    dot_inner = ( dot_r <=radium_innDisk );
    column_inner = find(dot_inner==1);
    column_outer = find(dot_inner==0);
    dot_outBaseRects = dot_baseRects(:,column_outer);
    dot_lBaseRects = dot_baseRects(:,column_inner);
    dot_rBaseRects = dot_baseRects(:,column_inner);
    
    % >>>> Dot Color
    % generate dot color, black/white occur in same possibility
    dot_color_raw = randsrc(1,dot_number,[[0,1]; [0.5,0.5]]);

    % "Coordinate Properties" of dots in inner disk
    %  with "per_correlated" percentage of dots will turn to contrast color 
    %       Change the right vision dots'color, 
    %       while keep left vision dots'color constant
    %
    % randomly select "per_correlate" percentage of columns
    contrast_num = ceil(length(column_inner) * per_correlate);
    contrast_column = [ones([1,contrast_num]),zeros([1,length(column_inner) - contrast_num])];
    contrast_column = contrast_column(randperm( length(column_inner) ));
    contrast_column = [1:length(column_inner)] .* contrast_column;
    contrast_column(contrast_column==0)=[];
 
    % contrast color of dots selected
    %%%% dots in left vision are unchanged
    dot_lColor = dot_color_raw(column_inner);
    %%%% dots in right vision are changed.
    dot_rColor = dot_color_raw(column_inner);
    dot_rColor(:,contrast_column) = ~dot_rColor(:,contrast_column); 
    %%%% dots in outer disk
    dot_oColor =  dot_color_raw(column_outer);
    
    % transfer color into RGB form
    dot_lColor_RGB = repmat(dot_lColor',[1,3]); 
    dot_rColor_RGB = repmat(dot_rColor',[1,3]);
    dot_oColor_RGB = repmat(dot_oColor',[1,3]);
    
    %% red fixation cross
    % >>>> cross position
    
    % cross for central vision field always exist
    ct_xCoords = [-ceil(ct_cross_size/2) ceil(ct_cross_size/2) 0 0];
    ct_yCoords = [0 0 -ceil(ct_cross_size/2) ceil(ct_cross_size/2)];

    % for peripheral trial, generate peripheral fixation
    if vision_field == 1
        pr_xCoords = [-ceil(pr_cross_size/2) ceil(pr_cross_size/2) 0 0];
        pr_yCoords = [0 0 -ceil(pr_cross_size/2) ceil(pr_cross_size/2)];
    end

    %% disparity step per RDS
    % move both left and right vision dots in opposite direction
    % make sure disparity step is integer
    if rem(disparity_step,2) == 0
        d_r = -disparity_step / 2;
        d_l = disparity_step / 2;
    else
        d_r = -(disparity_step + 1) / 2;
        d_l = (disparity_step - 1) / 2;
    end
    
    %% disparity items coordinate:
    dot_rBaseRects(1,:)= dot_rBaseRects(1,:) + d_r;
    dot_rBaseRects(3,:)= dot_rBaseRects(3,:) + d_r;
    dot_lBaseRects(1,:) = dot_lBaseRects(1,:) + d_l;
    dot_lBaseRects(3,:) = dot_lBaseRects(3,:) + d_l;   

    %% /////////////////// Display ////////////////////////
    vbl = Screen('Flip', dis_window);

    %% >>>> red image (left eye)
    Screen('SelectStereoDrawBuffer', dis_window, 0);

    % grey background 
    Screen('FillRect', dis_window, grey, [0 0  win_xCenter*2 win_yCenter*2]);

    % zero-disparity dots
    Screen('FillRect', dis_window, dot_oColor_RGB', dot_outBaseRects)

    % red fixation cross
    % last to draw, or it will be covered by dots
    Screen('DrawLines', dis_window, [ct_xCoords; ct_yCoords], fix_lineWidth, [1,0,0], [win_xCenter, win_yCenter - ct_cross_position], 2);
    % draw periperal cross in peripheral vision experiments
    if vision_field == 1 
        Screen('DrawLines', dis_window, [pr_xCoords; pr_yCoords], fix_lineWidth, [1,0,0], [win_xCenter, win_yCenter - pr_cross_position], 2);
    end
    % disparity dots(left)
    Screen('FillRect', dis_window, dot_lColor_RGB', dot_lBaseRects);

    %% >>>> blue image (right eye) 
     Screen('SelectStereoDrawBuffer', dis_window, 1);

    % grey background 
    Screen('FillRect', dis_window, grey, [0 0  win_xCenter*2 win_yCenter*2]);

    % zero-disparity dots
    Screen('FillRect', dis_window, dot_oColor_RGB', dot_outBaseRects)

    % red fixation cross
    % last to draw, or it will be covered by dots
    Screen('DrawLines', dis_window, [ct_xCoords; ct_yCoords], fix_lineWidth, [1,0,0], [win_xCenter, win_yCenter - ct_cross_position], 2);
    % draw periperal cross in peripheral vision experiments
    if vision_field == 1 
        Screen('DrawLines', dis_window, [pr_xCoords; pr_yCoords], fix_lineWidth, [1,0,0], [win_xCenter, win_yCenter - pr_cross_position], 2);
    end
    % disparity dots(right)
    Screen('FillRect', dis_window, dot_rColor_RGB', dot_rBaseRects);

    % Tell PTB no more drawing commands will be issued until the next flip
    Screen('DrawingFinished', dis_window);
    
    
    vbl = Screen('Flip', dis_window, vbl + RDS_frame_time );
    % Flip to the screen
%         if RDS_frame_num == 1
%             Screen('Flip', dis_window, (waitframe-0.5) *ifi );
%             pause(RDS_frame_time);
%         else            

%     end

end