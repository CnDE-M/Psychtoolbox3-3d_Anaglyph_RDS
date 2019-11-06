%% //////////////////////////// Instruction ////////////////////////////
% use psychophysics toolbox to program and reproduce the experiment in Zhaoping & Ackermann 2018 paper
% https://webdav.tuebingen.mpg.de/u/zli/prints/ZhaopingAckermann_2018_Post.pdf
% program it using red-green or red-blue anaglyph 3D mode
% https://en.wikipedia.org/wiki/Anaglyph_3D

%% /////////////// ALL ASSEIGNMENT INCLUDE THIS SESSION ///////////////
%
%   Title: 
%         StereoVision_expr_Anaglygh_3D
%   Script File: 
%         stereo_vision_expr_Anaglygh_3D.m
%   Function File:
%         load_trial.m
%         anaglygh_3D_trial.m
%         angle_to_pixel.m
%         expr_para_generator.m
%
%   Author: Xinyue Ma
%   Email: 1653515@tongji.edu.cn
%
%   MATLAB version: R2019a

%% ///////////////// screen and psychtoolbox initialization //////////////
sca;
close all;
clear
clearvars;

global  dis_window black white grey win_xCenter win_yCenter
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
screens = Screen('Screens');
screenNumber = max(screens); % display on laptop

% define color
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% open red-green anaglygh 3d window
stereoMode = 8; % 8 = Red-blue anaglyph
PsychImaging('PrepareConfiguration');
InitializeMatlabOpenGL;
[dis_window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], 32, 2, stereoMode);
% [dis_window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], 32, 2);
% Screen('Flip', dis_window);
Screen('BlendFunction', dis_window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
topPriorityLevel = MaxPriority(dis_window);
Priority(topPriorityLevel); 

% load window parameters
% % [window_Xpixels, window_Ypixels] = Screen('WindowSize', dis_window);
% % [win_width, win_height] = Screen('DisplaySize', screenNumber);
[win_xCenter, win_yCenter] = RectCenter(windowRect);


%% /////////////////////////// experiments parts ////////////////////////////
%
% The experiment include 4 practices and 5 experiments;
% Only correctness >=0.9 in first 3 practices, subject can start the 4th practice and full 4 experiments
% 
% In each sesion (both practice and experiment), 
% (1) set parameters: 
%     "trialPerCond": trial number per condition;
%     "cond_type": condition type, from 1-6. according to "expr_parameter_list" sequence.
%     "experiment_parameters": load by function "expr_para_generator(expr_type)"
%     "frame_RDS": [frame_RDS_num, frame_RDS_time]; 
%     "session_name": display before each session
% (2) load trials in loop by function "load_trials(RDS_frame, expr_parameters)"
%
% "expr_parameter_list" sequence:
% [ "central","correlated";         ,,,
%   "central","half-correlated";    ,,,
%   "central","anti-correlated";    ,,,
%   "peripheral","correlated";      ,,,
%   "peripheral","half-correlated"; ,,,
%   "peripheral","anti-correlated"]
%   
% Response from experiments 1-5 will export into "op_filename";
% response format is: 
% "result" = ["central/peripheral","correlation properties","disparity direction","subject response"]
% 

op_filename = 'expr_response.xlsx';
% 
% %% ////////   practice 1-3   //////////
% %% -----------------------------------------------------
% %  >>>> PRACTICE 1: 
% %       10 trials: central + full correlated;
% %       static RDS frame for 2 seconds;
% %  -----------------------------------------------------------
% trialPerCond = 1; % trial number per condition
% cond_type = [1]; % condition type, from 1-6. according to "expr_parameter_list" sequence.
% 
% expr_type = 1;
% expr_parameter_list =  expr_para_generator(expr_type); 
% expr_parameters = repmat(expr_parameter_list(cond_type,:),[trialPerCond,1]);
% expr_parameters(:,3) = 15 * expr_parameters(:,3); %%%% because it is static RDS, only display the largest disparity
% 
% RDS_frame = [1,2]; % static RDS, that is only 1 RDS frame, duration of 2 seconds;
% 
% session_name = 'Practice 1';
% 
% % start all trials in loop, with function "load_trials";
% [correctness(1),~] = load_trials(session_name, RDS_frame, expr_parameters);
% 
% %% -----------------------------------------------------
% %  >>>> PRACTICE 2: 
% %       10 trials: central + full correlated;
% %       dynamic 15 RDS frame per 0.1 Second;
% %  -----------------------------------------------------------
% trialPerCond = 1; % trial number per condition
% cond_type = [1]; % condition type, from 1-6. according to "expr_parameter_list" sequence.
% 
% expr_type = 1;
% expr_parameter_list =  expr_para_generator(expr_type); 
% expr_parameters = repmat(expr_parameter_list(cond_type,:),[trialPerCond,1]);
% 
% RDS_frame = [15, 0.1]; % dynamic15 RDS, that is only 1 RDS frame, duration of 0.1 seconds;
% 
% session_name = 'Practice 2';
% % start all trials in loop, with function "load_trials";
% [correctness(2),~] = load_trials(session_name, RDS_frame, expr_parameters);
% 
% %% -----------------------------------------------------
% %  >>>> PRACTICE 3: 
% %       10 trials: central + full correlated;
% %       10 trials: peripheral + full correlated;
% %       random order;
% %       dynamic 15 RDS frame per 0.1 Seconds;
% %  -----------------------------------------------------------
% trialPerCond = 1; % trial number per condition
% cond_type = [1,4]; % condition type, from 1-6. according to "expr_parameter_list" sequence.
% 
% expr_type = 1;
% expr_parameter_list =  expr_para_generator(expr_type); 
% expr_parameters = repmat(expr_parameter_list(cond_type,:),[trialPerCond,1]);
% % randomize the trial sequence
% rd_sq = randperm(size(expr_parameters,1));
% expr_parameters = expr_parameters(rd_sq,:);
% 
% RDS_frame = [15, 0.1]; % dynamic15 RDS, that is only 1 RDS frame, duration of 0.1 seconds;
% 
% session_name = 'Practice 3';
% 
% % start all trials in loop, with function "load_trials";
% [correctness(3),~] = load_trials(session_name, RDS_frame, expr_parameters);

%% ////////   practice 4 and experiment 1-5   //////////
% correctness=[1,1,1];
% if sum(correctness>=0.9) == 3 % all three pratices reach more than 0.9 correctness
%     %% -----------------------------------------------------
%     %  >>>> PRACTICE 4: 
%     %       1 trials: central + full correlated;
%     %       1 trials: central + half correlated;
%     %       1 trials: central + anti correlated;
%     %       1 trials: peripheral + full correlated;
%     %       1 trials: peripheral + half correlated;
%     %       1 trials: peripheral + anti correlated;
%     %       dynamic 15 RDS frame per 0.1 Seconds;
%     %  -----------------------------------------------------------
%     trialPerCond = 1; % trial number per condition
%     cond_type = 1:6; % condition type, from 1-6. according to "expr_parameter_list" sequence.
% 
%     expr_type = 1;
%     expr_parameter_list =  expr_para_generator(expr_type); 
%     expr_parameters = repmat(expr_parameter_list(cond_type,:),[trialPerCond,1]);
% 
%     RDS_frame = [15, 0.1]; % dynamic15 RDS, that is only 1 RDS frame, duration of 0.1 seconds;
% 
%     session_name = 'Practice 4';
% 
%     % start all trials in loop, with function "load_trials";
%     [~,~] = load_trials(session_name, RDS_frame, expr_parameters);

    %% >>>> Experiments 1-5
    trialPerCond = 10; % trial number per condition
    cond_type = 1:6; % condition type, from 1-6. according to "expr_parameter_list" sequence.
    RDS_frame = [15, 0.1]; % dynamic15 RDS, that is only 1 RDS frame, duration of 0.1 seconds;
    for expr_type = 1:1
        expr_parameter_list =  expr_para_generator(expr_type); 
        expr_parameters = repmat(expr_parameter_list(cond_type,:),[trialPerCond,1]);
        
        % randomize the conditions
        seq = randperm(size(expr_parameters,1));
        expr_parameters = expr_parameters(seq,:);
        
        session_name = ['Experiement_', num2str(expr_type)];
        load_trials(session_name, RDS_frame, expr_parameters);
        % xlswrite(expr_result(:,:,expr_type) ,op_filename, session_name); % export response to "" file, each sheetpage per experiment
    end
    

% else % fail to complete practices efficiently
%     % report the result of each practice
%     fprintf('Low correctness in first 3 trials \n');
%     fprintf('You need to get >= 0.9 correctness in previous 3 sessions\n');
%     fprintf('-------------------------------------------- \n');
%     for ii=1:3
%         fprintf('Trial %d: %d%%\n',ii,correctness*100);
%     end
%     fprintf('-------------------------------------------- \n');
%     fprintf('Please restart the practice sessions.\n');
% end

%% End of Experiments
Priority(0);
sca;







