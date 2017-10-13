% clear all;

dataDir = 'F:\lightspot-2016\';
currentDir = pwd;
motorDataDir = fullfile(dataDir,'motorData_t.mat');
load(motorDataDir);
lightDir = fullfile(dataDir,'light.txt','framelight.txt_t');
decelerateData = {};
decelerate_light = {};
motorData = motorData_t;
n = size(motorData,2);
first_decelerate_min_speed = [];
first_decelerate_speed_change = [];
first_decelerate_ratio = [];
first_decelerate_time = [];
first_decelerate_deceleration = [];
headtheta_light_frame = [];
headomega_light_frame = [];
headtheta_light_value = [];
headomega_light_value = [];
sum = [];
for index=1:n
    framelight = load(fullfile(lightDir,strcat('light{',int2str(index),'}framelight.txt')));
    headtheta = motorData{index}.headTheta;
    headomega = motorData{index}.headOmega;
    tailspeed = motorData{index}.tailSpeed;
    tailspeed = filter2([1], tailspeed);
    cmXY = motorData{index}.cmXY;
    tailXY = motorData{index}.tailXY;
    fs = motorData{index}.fs;
    scale = motorData{index}.scale;
    tailspeed(find(abs(tailspeed) > 100)) = 0;    
    peakdet_lambda = 0.08/(fs*scale); % this peakdet_lambda is specific for tailSpeed 
    badframes_headTheta = find(headtheta == 0);
    badframes_tailspeed = find(tailspeed == 0);
    badframes = union(badframes_headTheta,badframes_tailspeed);
    point_touch_light_t = point_touch_light(framelight); 
    point_end_light_t = point_end_light(framelight);

    pairs_decelerate_temp = [];
    threshold_min = 0.05;
    threshold_max = 0.05;
    [point_min,~,pairs_decelerate_temp] = pairs_decelerate(tailspeed, [1], peakdet_lambda,threshold_min,threshold_max); %12.03 change
    pairs_decelerate_t = [];
    pairs_decelerate_value_t =[];
    l = size(pairs_decelerate_temp,1);
    first_point_min_light_ID = find(point_min(:,1) >= point_touch_light_t,1);
    first_point_min_light = point_min(first_point_min_light_ID,2);
    threshold_tailspeed = 0.50;  
    sub_threshold_segment_s = sub_threshold_segment(tailspeed,threshold_tailspeed);
    idx = [];
    for j = 1:l
        if (tailspeed(pairs_decelerate_temp(j,:))  < 0.2) 
            pairs_decelerate_temp(j,:)=[0 0];
            idx = [idx;j];
        end
    end
    pairs_decelerate_temp(idx,:)=[];
    l = size(pairs_decelerate_temp,1);
    for i=1:l
        if isempty( intersect(pairs_decelerate_temp(i,1) : pairs_decelerate_temp(i,2), badframes_tailspeed))
            pairs_decelerate_t = [pairs_decelerate_t; pairs_decelerate_temp(i,:)];
        end
    end

    threshold_headtheta = 0;
    peakdet_cast_lambda = 0.02; 
    cast_max_frames_t = [];
    cast_max_frames_t = cast_max_frames(headtheta, peakdet_cast_lambda, threshold_headtheta);
    headomega_peak_t =[];
    threshold_headomega = 0;
    peakdet_omega_lambda = 0.4;
    headomega_peak_t = cast_max_frames(headomega, peakdet_omega_lambda, threshold_headomega); 
    omega_zero_frame_t = omega_zero_frame(headomega,0); 
    [light_window, pairs_decelerate_light_t] = pairs_decelerate_light(point_touch_light_t,pairs_decelerate_t,point_min);
    [decele_corr_headomega_peaks_t, decele_corr_headtheta_peaks_t] = decele_corr_headomega_peaks(point_min,pairs_decelerate_light_t,headomega_peak_t,cast_max_frames_t,omega_zero_frame_t,sub_threshold_segment_s);
    if ~isempty(pairs_decelerate_t)
        
        fpp_decelerate_t = fpp_decelerate(pairs_decelerate_t, point_min ); 
        fpp_before_decelerate_t = fpp_before_decelerate(pairs_decelerate_t, point_min, 3);  
        periods_change_ratio_t = (fpp_decelerate_t (1,:)- fpp_before_decelerate_t(1,:))./ fpp_before_decelerate_t(1,:);
        
        distance_decelerate_pairs_cm_t = distance_decelerate_pairs( pairs_decelerate_t, cmXY, point_min);
        distance_decelerate_pairs_tail_t = distance_decelerate_pairs( pairs_decelerate_t, tailXY, point_min);
        
        distance_before_decelerate_pairs_cm_t = distance_before_decelerate_pairs( pairs_decelerate_t, cmXY, point_min, 3);
        distance_before_decelerate_pairs_tail_t = distance_before_decelerate_pairs( pairs_decelerate_t, tailXY, point_min, 3);
        
        distance_pairs_cm_change_ratio_t = (distance_decelerate_pairs_cm_t(1,:) - distance_before_decelerate_pairs_cm_t(1,:))./distance_before_decelerate_pairs_cm_t(1,:);
        distance_pairs_tail_change_ratio_t = ( distance_decelerate_pairs_tail_t (1,:)- distance_before_decelerate_pairs_tail_t(1,:) )./distance_before_decelerate_pairs_tail_t(1,:);
        
        pairs_decelerate_value_t = tailspeed(pairs_decelerate_t);
        pairs_decelerate_value_diff_t = tailspeed(pairs_decelerate_t(:,1)) - tailspeed(pairs_decelerate_t(:,2));
        pairs_decelerate_ratio_t = pairs_decelerate_value_diff_t./tailspeed(pairs_decelerate_t(:,1));
        decelerate_time_t = pairs_decelerate_t(:,2) - pairs_decelerate_t(:,1);
        average_decelerate_t = pairs_decelerate_value_diff_t ./  decelerate_time_t';
        
        if ~isempty(pairs_decelerate_light_t)
            a = size(decele_corr_headtheta_peaks_t,2); 
            max_headtheta_t = [];
            for j = 1:a
                if ~isempty(decele_corr_headtheta_peaks_t{j})
                    max_headtheta_t(j) = max(abs(headtheta(decele_corr_headtheta_peaks_t{j}))); 
                else
                    max_headtheta_t(j) = 0;
                end
            end
            first_decelerate_light_ID_t_temp = find(abs(max_headtheta_t)==max(abs(max_headtheta_t))); 
            if max(size(first_decelerate_light_ID_t_temp))>1
               point_min_lowest_t = find(ismember(point_min(:,1),pairs_decelerate_light_t(first_decelerate_light_ID_t_temp,2)));
               first_decelerate_light_ID_t_temp = find(point_min(point_min_lowest_t,2) == min(point_min(point_min_lowest_t,2)));
            end
            first_decelerate_light_ID_t = first_decelerate_light_ID_t_temp;
            headtheta_light_temp = decele_corr_headtheta_peaks_t{first_decelerate_light_ID_t};
            headomega_light_temp = decele_corr_headomega_peaks_t{first_decelerate_light_ID_t};
            headtheta_light_temp_maxID = find(abs(headtheta(headtheta_light_temp)) == max(abs(headtheta(headtheta_light_temp))));
            
            headtheta_light_temp_maxID_t = headtheta_light_temp_maxID;
            if max(size(headtheta_light_temp_maxID)) > 1
               headtheta_light_temp_maxID_t = find(abs(headomega(headomega_light_temp(headtheta_light_temp_maxID))) == max(abs(headomega(headomega_light_temp(headtheta_light_temp_maxID)))));
            end
            
            headtheta_light_frame_t = headtheta_light_temp(headtheta_light_temp_maxID_t); 
            headomega_light_frame_t = headomega_light_temp(headtheta_light_temp_maxID_t); 
            
            m = first_decelerate_light_ID_t;
            first_decelerate_min_speed_t = pairs_decelerate_value_t(m,2);
            first_decelerate_speed_change_t = pairs_decelerate_value_diff_t(m);
            first_decelerate_ratio_t = pairs_decelerate_ratio_t(m);
            first_decelerate_time_t = decelerate_time_t(m);
            first_decelerate_deceleration_t = average_decelerate_t(m);
            
            headtheta_light_value_t = abs(headtheta(headtheta_light_frame_t))/pi*180; 
            headomega_light_value_t = abs(headomega(headomega_light_frame_t));
    
        else

            first_decelerate_light_ID_t = -1;
            first_decelerate_min_speed_t = min(tailspeed(light_window(1):light_window(2)));
            first_decelerate_speed_change_t = 0;
            first_decelerate_ratio_t = 0;
            first_decelerate_time_t = 0;
            first_decelerate_deceleration_t = 0;
            
            headtheta_light_frame_t = 0;
            headomega_light_frame_t = 0;
            headtheta_light_value_t = max(abs(headtheta(light_window(1):light_window(2))))/pi*180;
            headomega_light_value_t = max(abs(headomega(light_window(1):light_window(2))));
        end
        
        
    else
        fpp_decelerate_t = -1;
        fpp_before_decelerate_t = -1;
        periods_change_ratio_t = -1; 
        distance_decelerate_pairs_cm_t = -1;
        distance_decelerate_pairs_tail_t = -1;
        distance_before_decelerate_pairs_cm_t = -1;
        distance_before_decelerate_pairs_tail_t = -1; 
        distance_pairs_cm_change_ratio_t = -1;
        distance_pairs_tail_change_ratio_t = -1;
        pairs_decelerate_value_diff_t = -1;
        pairs_decelerate_ratio_t = -1;
        decelerate_time_t = -1;
        average_decelerate_t = -1;  
        first_decelerate_light_ID_t = -1;   
        first_decelerate_min_speed_t = first_point_min_light;
        first_decelerate_speed_change_t = -1;
        first_decelerate_ratio_t = -1;
        first_decelerate_time_t = -1;
        first_decelerate_deceleration_t = -1;
        headtheta_light_frame_t = 0;
        headomega_light_frame_t = 0;
        headtheta_light_value_t = max(abs(headtheta(light_window(1):light_window(2))))/pi*180;
        headomega_light_value_t = max(abs(headomega(light_window(1):light_window(2))));
    end
    display(first_decelerate_min_speed_t);
    display(headtheta_light_value_t);

    first_decelerate_min_speed = [first_decelerate_min_speed;first_decelerate_min_speed_t];
    first_decelerate_speed_change = [first_decelerate_speed_change;first_decelerate_speed_change_t];
    first_decelerate_ratio = [first_decelerate_ratio;first_decelerate_ratio_t];
    first_decelerate_time = [first_decelerate_time;first_decelerate_time_t];
    first_decelerate_deceleration = [first_decelerate_deceleration;first_decelerate_deceleration_t];
    headtheta_light_frame = [headtheta_light_frame;headtheta_light_frame_t];
    headomega_light_frame = [headomega_light_frame;headomega_light_frame_t];
    headtheta_light_value = [headtheta_light_value;headtheta_light_value_t];
    headomega_light_value = [headomega_light_value;headomega_light_value_t];
    
    decelerateData{index}.badframes_headTheta = badframes_headTheta;
    decelerateData{index}.badframes_tailspeed = badframes_tailspeed;
    decelerateData{index}.point_min_t = point_min;
    decelerateData{index}.point_touch_light_t = point_touch_light_t;
    decelerateData{index}.pairs_decelerate_t = pairs_decelerate_t;
    decelerateData{index}.fpp_decelerate_t = fpp_decelerate_t;
    decelerateData{index}.fpp_before_decelerate_t = fpp_before_decelerate_t;
    decelerateData{index}.periods_change_ratio_t = periods_change_ratio_t;
    decelerateData{index}.distance_decelerate_pairs_cm_t = distance_decelerate_pairs_cm_t;
    decelerateData{index}.distance_decelerate_pairs_tail_t = distance_decelerate_pairs_tail_t;
    decelerateData{index}.distance_before_decelerate_pairs_cm_t = distance_before_decelerate_pairs_cm_t;
    decelerateData{index}.distance_before_decelerate_pairs_tail_t = distance_before_decelerate_pairs_tail_t;
    decelerateData{index}.distance_pairs_cm_change_ratio_t = distance_pairs_cm_change_ratio_t;
    decelerateData{index}.distance_pairs_tail_change_ratio_t = distance_pairs_tail_change_ratio_t;
    decelerateData{index}.pairs_decelerate_value_t = pairs_decelerate_value_t;
    decelerateData{index}.pairs_decelerate_value_diff_t = pairs_decelerate_value_diff_t;
    decelerateData{index}.pairs_decelerate_ratio_t = pairs_decelerate_ratio_t ;
    decelerateData{index}.decelerate_time_t = decelerate_time_t;
    decelerateData{index}.average_decelerate_t = average_decelerate_t;
    decelerateData{index}.first_decelerate_light_ID_t = first_decelerate_light_ID_t;

    decelerateData{index}.first_decelerate_min_speed_t = first_decelerate_min_speed_t;
    decelerateData{index}.first_decelerate_speed_change_t = first_decelerate_speed_change_t;
    decelerateData{index}.first_decelerate_ratio_t = first_decelerate_ratio_t;
    decelerateData{index}.first_decelerate_time_t = first_decelerate_time_t;
    decelerateData{index}.first_decelerate_deceleration_t = first_decelerate_deceleration_t;

    decelerateData{index}.sub_threshold_segment = sub_threshold_segment_s;
    decelerateData{index}.headomega_peak_t = headomega_peak_t;
    decelerateData{index}.light_window = light_window;
    decelerateData{index}.pairs_decelerate_light_t = pairs_decelerate_light_t;
    decelerateData{index}.omega_zero_frame_t = omega_zero_frame_t;
    decelerateData{index}.decele_corr_headomega_peaks_t = decele_corr_headomega_peaks_t;
    decelerateData{index}.decele_corr_headtheta_peaks_t = decele_corr_headtheta_peaks_t;
    
    decelerateData{index}.threshold_headtheta = threshold_headtheta;
    decelerateData{index}.cast_max_frame_t = cast_max_frames_t;
    decelerateData{index}.headtheta_light_value_t = headtheta_light_value_t;
    decelerateData{index}.headomega_light_value_t = headomega_light_value_t;
    decelerateData{index}.headtheta_light_frame_t = headtheta_light_frame_t;
    decelerateData{index}.headomega_light_value_t = headomega_light_value_t;
    
    decelerate_light.first_decelerate_min_speed = first_decelerate_min_speed;
    decelerate_light.first_decelerate_speed_change = first_decelerate_speed_change;
    decelerate_light.first_decelerate_ratio = first_decelerate_ratio;
    decelerate_light.first_decelerate_time = first_decelerate_time;
    decelerate_light.first_decelerate_deceleration = first_decelerate_deceleration;
    decelerate_light.headtheta_light_value = headtheta_light_value;
    decelerate_light.headomega_light_value = headomega_light_value;
    decelerate_light.headtheta_light_frame = headtheta_light_frame;
    decelerate_light.headomega_light_frame = headomega_light_frame;
    
end
cd(dataDir);
save decelerateData;
save decelerate_light;
cd(currentDir);
clear all;

