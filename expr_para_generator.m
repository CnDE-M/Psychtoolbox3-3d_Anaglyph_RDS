function expr_parameters =  expr_para_generator(expr_type)
%% >>>> discription:
% Save and Generate 6 condition parameters list for 1-5 experiments 
%
%% >>>> input arg:
% "expr_type": experment type (1, 5)
%
%% >>>> output arg:
% "expr_parameters": parameter list for 6 condition. the length are changed from vision angle to pixel size
%       expr_parameters(:,1:3) = [(central, correlate), (central, half-correlate), (central, anti-correlate)];
%       expr_parameters(:,4:6) = [(peri, correlate), (peri, half-correlate), (peri, anti-correlate)];
%       expr_parameters(1:9,:) = [vision_field,per_correlate,disparity_step,radium_surrounding,radium_innDisk,radium_outDisk,dot_size,ct_cross_size,ct_cross_position];
%

	%%........................................................
	%		1 - "experiment 1"
    if expr_type == 1
        vision_field = [repmat(0,[3,1]); repmat(1,[3,1])];
        per_correlate = repmat ([0;0.5;1],[2,1]);
        disparity_step = angle_to_pixel(repmat(0.087, [6,1]));
        radium_innDisk = angle_to_pixel(repmat(3, [6,1]));
        radium_outDisk = angle_to_pixel(repmat(4.3, [6,1]));
        radium_surrounding = radium_innDisk;
        dot_size = angle_to_pixel(repmat(0.348, [6,1]));
        ct_cross_size = angle_to_pixel(repmat(0.440, [6,1]));
        ct_cross_position = angle_to_pixel(repmat(3.65, [6,1]));
        
	%%........................................................
	%		2 - "experiment 2"
	%%%% >>>> Goal:
	%%%% visual accuity make RDS smaller in peripheral vision. This experiment is to test whether size matter.
	%%%% >>>> Method:
	%%%% The difference from Expr. 1 is: 
	%%%% <dot size, disk size, ring size, fixation cross size,cross-to-disk distance, disparity step>
	%%%% are halved in central vision experiments.   
    elseif expr_type == 2
        vision_field = [repmat(0,[3,1]); repmat(1,[3,1])];
        per_correlate = repmat ([0;0.5;1], [2,1]);
        disparity_step = angle_to_pixel( [repmat(0.044,[3,1]); repmat(0.187,[3,1])] );
        radium_innDisk = angle_to_pixel( [repmat(1.5,[3,1]); repmat(3,[3,1])] );
        radium_outDisk = angle_to_pixel( [repmat(2.15,[3,1]); repmat(4.3,[3,1])] );
        radium_surrounding = radium_innDisk;
        dot_size = angle_to_pixel( [repmat(0.174, [3,1]); repmat(0.348, [3,1])] );
        ct_cross_size = angle_to_pixel( [repmat(0.220, [3,1]); repmat(0.440, [3,1])] );
        ct_cross_position = angle_to_pixel( [repmat(1.83,[3,1]); repmat(3.65,[3,1])] );

	%		3 - "experiment 3"
	%%%% >>>> Goal:
	%%%% >>>> Method:
	%%%% The difference from Expr. 2 is: 
	%%%% <disparity step>
	%%%% are doubled in central and peripheral vision experiments.
    elseif expr_type == 3
        vision_field = [repmat(0,[3,1]); repmat(1,[3,1])];
        per_correlate = repmat ([0;0.5;1], [2,1]);
        disparity_step = angle_to_pixel( [repmat(0.087,[3,1]); repmat(0.174,[3,1])] );
        radium_innDisk = angle_to_pixel( [repmat(1.5,[3,1]); repmat(3,[3,1])] );
        radium_outDisk = angle_to_pixel( [repmat(2.15,[3,1]); repmat(4.3,[3,1])] );
        radium_surrounding = radium_innDisk;
        dot_size = angle_to_pixel( [repmat(0.174, [3,1]); repmat(0.348, [3,1])] );
        ct_cross_size = angle_to_pixel( [repmat(0.220, [3,1]); repmat(0.440, [3,1])] );
        ct_cross_position = angle_to_pixel( [repmat(1.83,[3,1]); repmat(3.65,[3,1])] );
	
	%		4 - "experiment 4"
	%%%% >>>> Goal:
	%%%% >>>> Method:
	%%%% The difference from Expr. 1 is: 
	%%%% <disparity step>
	%%%% are doubled in central and peripheral vision experiments.
    elseif expr_type == 4
        vision_field = [repmat(0,[3,1]); repmat(1,[3,1])];
        per_correlate = repmat ([0;0.5;1],[2,1]);
        disparity_step = angle_to_pixel(repmat(0.087, [6,1]));
        radium_innDisk = angle_to_pixel(repmat(3, [6,1]));
        radium_outDisk = angle_to_pixel(repmat(4.3, [6,1]));
        radium_surrounding = angle_to_pixel( repmat(3.65,[6,1]) ); 
        dot_size = angle_to_pixel(repmat(0.348, [6,1]));
        ct_cross_size = angle_to_pixel(repmat(0.440, [6,1]));
        ct_cross_position = angle_to_pixel(repmat(3.65, [6,1]));      
    
    %		5 - "experiment 5"
	%%%% >>>> Goal:
	%%%% >>>> Method:
	%%%% The difference from Expr. 2 is: 
	%%%% <disparity step>
	%%%% are doubled in central and peripheral vision experiments.
    elseif expr_type == 5
        vision_field = [repmat(0,[3,1]); repmat(1,[3,1])];
        per_correlate = repmat ([0;0.5;1], [2,1]);
        disparity_step = angle_to_pixel( [repmat(0.044,[3,1]); repmat(0.187,[3,1])] );
        radium_innDisk = angle_to_pixel( [repmat(1.5,[3,1]); repmat(3,[3,1])] );
        radium_outDisk = angle_to_pixel( [repmat(2.15,[3,1]); repmat(4.3,[3,1])] );
        radium_surrounding = angle_to_pixel( [repmat(1.825,[3,1]); repmat(3.65,[3,1])] );
        dot_size = angle_to_pixel( [repmat(0.174, [3,1]); repmat(0.348, [3,1])] );
        ct_cross_size = angle_to_pixel( [repmat(0.220, [3,1]); repmat(0.440, [3,1])] );
        ct_cross_position = angle_to_pixel( [repmat(1.83,[3,1]); repmat(3.65,[3,1])] );
    end

      dot_size = floor(dot_size/2); % adjust original parameter in paper
    % disparity_step = floor(disparity_step/2);
    % radium_innDisk = radium_innDisk - disparity_step.*15;
%     radium_outDisk = radium_outDisk .*1.4;
%     radium_innDisk = radium_innDisk .*1.4;
%     ct_cross_position = ct_cross_position .*1.4;
%     radium_surrounding = radium_surrounding.*1.4;

    expr_parameters = [vision_field,per_correlate,disparity_step,radium_surrounding,radium_innDisk,radium_outDisk,dot_size,ct_cross_size,ct_cross_position];
end