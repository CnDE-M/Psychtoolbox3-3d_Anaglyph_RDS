function load_trials(session_name, RDS_frame, expr_parameters)
%% description:
%  load trials flow according to "expr_parameters"
%
%% Input Arguments£º
%   >>>> "session_name": 
%         session name displayed in intruction window
%   >>>> "RDS_frame" = ["RDS_frame_num", "RDS_frame_time"]
%        "RDS_frame_num": RDS frame number
%        "RDS_frame_time": duration of one RDS
%   >>>> "expr_parameter" = ["vision_field", "per_correlate", "disparity_step", "radium_surrounding", "radium_innDisk",...
%                            "radium_outDisk", "dot_size", "ct_cross_size", "ct_cross_position" ];
%        See details in "anaglyph_3D_trial.m"
%
%% Output Arguments:
%   >>>> "correctness": correctness of subject response;
%   >>>> "result" = ["central/peripheral","correlation properties","disparity direction","subject response"]
%       "central/peripheral": 0 - central; 1 - peripheral;
%       "correlation properties": 0 - correlate; 0.5 - half correlate; 1 - anti correlate
%       "disparity direction": "+" - left > right; "-" - left < right;
%       "subject response": 
%               1 - identify vision depth: in front of outer disk;
%               0 - not identify vision depth;
%               -1 - identify vision depth: behind outer disk;
%               2 - wrong input;
%

    %% /////////////////// Instruction Window ////////////////////////
    global  dis_window white win_xCenter win_yCenter
    line_1 = session_name;
    line_2 = '>>>> response guide:';
    line_3 = '"In front of" - right key;\n\n\n"behind" - left key;\n\n\n"no depth" - down key;';
    line_4 = 'press any key to start.';
    
    % red image(left eye)
    Screen('SelectStereoDrawBuffer', dis_window, 0);
    
    Screen('TextSize', dis_window, 60);
    Screen('TextStyle', dis_window, 1);
    Screen('TextFont', dis_window, 'Times');
    DrawFormattedText(dis_window, line_1, 'center', 0.6 * win_yCenter, [1,0,0]);
    
    Screen('TextSize', dis_window, 20);
    Screen('TextFont', dis_window, 'Courier');
    DrawFormattedText(dis_window, '------------------------------------------------------------------', 'center', win_yCenter*0.8,white);
    DrawFormattedText(dis_window, line_2, win_xCenter*0.6, win_yCenter,white);
    DrawFormattedText(dis_window, line_3, win_xCenter*0.6, 1.1 * win_yCenter,white);  
    DrawFormattedText(dis_window, '------------------------------------------------------------------', 'center', win_yCenter*1.6,white);
  
    Screen('TextSize', dis_window, 30);
    Screen('TextFont', dis_window, 'Times');Screen('TextStyle', dis_window, 1);
    Screen('TextStyle', dis_window, 1);
    DrawFormattedText(dis_window, line_4, 'center', 1.8 * win_yCenter, [1,0,0]);
    
    % blue image(right eye)
    Screen('SelectStereoDrawBuffer', dis_window, 1);
    
    Screen('TextSize', dis_window, 60);
    Screen('TextStyle', dis_window, 1);
    Screen('TextFont', dis_window, 'Times');
    DrawFormattedText(dis_window, line_1, 'center', 0.6 * win_yCenter, [1,0,0]);
    
    Screen('TextSize', dis_window, 20);
    Screen('TextFont', dis_window, 'Courier');
    DrawFormattedText(dis_window, '------------------------------------------------------------------', 'center', win_yCenter*0.8,white);
    DrawFormattedText(dis_window, line_2, win_xCenter*0.6, win_yCenter,white);
    DrawFormattedText(dis_window, line_3, win_xCenter*0.6, 1.1 * win_yCenter,white);  
    DrawFormattedText(dis_window, '------------------------------------------------------------------', 'center', win_yCenter*1.6,white);
  
    Screen('TextSize', dis_window, 30);
    Screen('TextFont', dis_window, 'Times');Screen('TextStyle', dis_window, 1);
    Screen('TextStyle', dis_window, 1);
    DrawFormattedText(dis_window, line_4, 'center', 1.8 * win_yCenter, [1,0,0]);
 

    % Flip to the screen
    Screen('Flip', dis_window);
    
    % Now we have drawn to the screen we wait for a keyboard button press (any
    % key) to terminate the demo
    KbStrokeWait;
    
    trial_num = size(expr_parameters,1);
    for jj =1: trial_num % load trial flow
       
        %% /////////////////// Parameters Loading ////////////////////////
        waitframe=1;
        ifi = Screen('GetFlipInterval', dis_window);
        % load experiment parameters of each trial
        expr_pm = expr_parameters(jj,:);
        
        % randomly generate disparity direction
        direction = randi(2);  
        expr_pm(3) = expr_pm(3)*(-1)^direction;
        
        % load experiment parameters
        vision_field = expr_pm(1);
        ct_cross_size = expr_pm(8);
        ct_cross_position = expr_pm(9);
        pr_cross_size = angle_to_pixel(0.44);
        pr_cross_position = angle_to_pixel(10.1)-100;
       %% red fixation cross
        fix_lineWidth = 4;
        % >>>> cross position
        % cross for central vision field always exist
        ct_xCoords = [-ceil(ct_cross_size/2) ceil(ct_cross_size/2) 0 0];
        ct_yCoords = [0 0 -ceil(ct_cross_size/2) ceil(ct_cross_size/2)];
        % for peripheral trial, generate peripheral fixation
        if vision_field == 1
            pr_xCoords = [-ceil(pr_cross_size/2) ceil(pr_cross_size/2) 0 0];
            pr_yCoords = [0 0 -ceil(pr_cross_size/2) ceil(pr_cross_size/2)];
        end
        
        %% expected response on depth order
        if direction == 1 % direction == 1 ---- right > left ---- behind;
            ex_rp(jj,:) = -1;
        else              % direction == 2 ---- right < left ---- in front of;
            ex_rp(jj,:) = 1;
        end
        
        
       %% /////////////////// Pre-fixation Stage ////////////////////////
        %  cue subject to fixation cross with left and right cues
        %  subject press any button to start the trial
        %
        
        left_cue = 'press any button';
        right_cue = 'for the next trial';

        %% red image (left eye)
        Screen('SelectStereoDrawBuffer', dis_window, 0);

        Screen('TextSize', dis_window, 20);
        if vision_field == 1        
            DrawFormattedText(dis_window, left_cue, -220 + win_xCenter, 0 + win_yCenter - pr_cross_position, white);
            DrawFormattedText(dis_window, right_cue, 20 + win_xCenter, 0 + win_yCenter - pr_cross_position, white);
            Screen('DrawLines', dis_window, [pr_xCoords; pr_yCoords], fix_lineWidth, [1,0,0], [win_xCenter, win_yCenter - pr_cross_position], 2);
        else      
            DrawFormattedText(dis_window, left_cue, -220 + win_xCenter, 0 + win_yCenter - ct_cross_position, white);
            DrawFormattedText(dis_window, right_cue, 20 + win_xCenter, 0 + win_yCenter - ct_cross_position, white);
            Screen('DrawLines', dis_window, [ct_xCoords; ct_yCoords], fix_lineWidth, [1,0,0], [win_xCenter, win_yCenter - ct_cross_position], 2);
        end

        %% left image (left eye)
        Screen('SelectStereoDrawBuffer', dis_window, 1);

        Screen('TextSize', dis_window, 20);
        if vision_field == 1        
            DrawFormattedText(dis_window, left_cue, -220 + win_xCenter, 0 + win_yCenter - pr_cross_position, white);
            DrawFormattedText(dis_window, right_cue, 20 + win_xCenter, 0 + win_yCenter - pr_cross_position, white);
            Screen('DrawLines', dis_window, [pr_xCoords; pr_yCoords], fix_lineWidth, [1,0,0], [win_xCenter, win_yCenter - pr_cross_position], 2);
        else      
            DrawFormattedText(dis_window, left_cue, -220 + win_xCenter, 0 + win_yCenter - ct_cross_position, white);
            DrawFormattedText(dis_window, right_cue, 20 + win_xCenter, 0 + win_yCenter - ct_cross_position, white);
            Screen('DrawLines', dis_window, [ct_xCoords; ct_yCoords], fix_lineWidth, [1,0,0], [win_xCenter, win_yCenter - ct_cross_position], 2);
        end

        Screen('Flip', dis_window, (waitframe-0.5) *ifi );
        KbStrokeWait;
        
        %% /////////////////// Fixation Stage ////////////////////////
        % 15 independent dynamic RDS frames display, 100ms for each
        % 0-0.7s: no gaze track
        % 0.7s-1.5s: gaze track for checking whether subject fix properly (not doing).
        % this script simply shift RDS 0.1s/step
        %
        %%%% independently generate RDS frames in one trial
        vbl = Screen('Flip', dis_window);
        for ii = 1:RDS_frame(1)
            vbl = anaglyph_3D_trial(vbl, RDS_frame(2), expr_pm); 
        end
        
       %% /////////////////// Subject Report ////////////////////////
        % >>>> right key (39) - "in front of"
        % >>>> left key (37) - "behind"
        % >>>> down key (38) - "no depth"
        [~,keyCode,~] = KbStrokeWait;
        keyName = find(keyCode==1);

        if keyName == 39
            vd_response=1;
        elseif keyName == 37
            vd_response = -1;
        elseif keyName == 38
            vd_response = 0;
        else 
            vd_response = 2; %%%% wrong input
        end
        rp(jj,:) = vd_response;
    end
    
    correctness= sum(rp==ex_rp) /trial_num;
    
    % report response of all trials
    ex_rp = num2str(ex_rp);
%     ex_rp = replace(ex_rp,'1','-'); % disparity < 0
%     ex_rp = replace(ex_rp,'2','+'); % disparity > 0
    ex_rp(ex_rp=='1') = '-'; % disparity < 0
    ex_rp(ex_rp=='2') = '+'; % disparity > 0

    
    result = [expr_parameters(:,1:2), ex_rp, rp];
end
