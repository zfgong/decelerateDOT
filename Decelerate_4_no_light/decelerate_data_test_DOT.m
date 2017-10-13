clear all;
dataDir = 'G:\VNC inhibit\analyses\';
currentDir = pwd;
motorDataDir = fullfile(dataDir,'motorData.mat');
load(motorDataDir);
decelerateData = {};
decelerate_light = {};
decelerate_pair = {};
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
speed_theta_pair_all = [];
ratio_theta_pair_all = [];
speed_before_decelerate_all = [];
point_min_all = [];
for index=1:n
    headtheta = motorData{index}.headTheta;
    headomega = motorData{index}.headOmega;
    tailspeed = motorData{index}.tailSpeed;
    tailspeed = filter2([1], tailspeed);
    cmXY = motorData{index}.cmXY;
    tailXY = motorData{index}.tailXY;
    fs = motorData{index}.fs;
    scale = motorData{index}.scale;
    tailspeed(find(abs(tailspeed) > 100)) = 0;
    peakdet_lambda = 0.4/(fs*0.8);
    badframes_headTheta = find(headtheta == 0);
    badframes_tailspeed = find(tailspeed == 0);
    badframes = union(badframes_headTheta,badframes_tailspeed);
    pairs_decelerate_temp = [];
    threshold_min = 0.05;
    threshold_max = 0.05;
    [point_min,~,pairs_decelerate_temp] = pairs_decelerate(tailspeed, [1], peakdet_lambda,threshold_min,threshold_max); %12.03 change
    pairs_decelerate_t = [];
    pairs_decelerate_value_t =[];
    l = size(pairs_decelerate_temp,1);
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
    if ~isempty(pairs_decelerate_t) & (pairs_decelerate_t(1,1) == point_min(1,1))
        pairs_decelerate_t(1,:) = [];
    end
    advance = 3; 
    speed_before_decelerate_t = speed_before_decelerate(pairs_decelerate_t, point_min, advance, tailspeed);
    figure;
    plot(tailspeed,'green');
    hold;
    plot(headomega,'blue');
    hold;
    threshold_headtheta = 0;
    peakdet_cast_lambda = 0.02; 
    cast_max_frames_t = [];
    cast_max_frames_t = cast_max_frames(headtheta, peakdet_cast_lambda, threshold_headtheta);
    cast_zero_frames_t = [];
    cast_zero_frames_t = omega_zero_frame(headtheta, threshold_headtheta);
    headomega_peak_t =[];
    threshold_headomega = 0;
    peakdet_omega_lambda = 0.4; 
    headomega_peak_t = cast_max_frames(headomega, peakdet_omega_lambda, threshold_headomega);
    omega_zero_frame_t = omega_zero_frame(headomega,0); 
        speed_theta_pair = [];
        ratio_theta_pair = [];
        decele_corr_headomega_peaks_t = {};
        decele_corr_headtheta_peaks_t = {};
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
        pairs_decelerate_ratio_t = pairs_decelerate_value_diff_t./mean(speed_before_decelerate_t); 
        decelerate_time_t = pairs_decelerate_t(:,2) - pairs_decelerate_t(:,1);
        average_decelerate_t = pairs_decelerate_value_diff_t ./  decelerate_time_t';
        [decele_corr_headomega_peaks_t, decele_corr_headtheta_peaks_t] = decele_corr_headomega_peaks(point_min,pairs_decelerate_t,headomega_peak_t,cast_max_frames_t,omega_zero_frame_t,sub_threshold_segment_s);
        a = size(decele_corr_headtheta_peaks_t,2); 
            max_headtheta_t = [];
            for j = 1:a
                if ~isempty(decele_corr_headtheta_peaks_t{j})
                    max_headtheta_t(j) = max(abs(headtheta(decele_corr_headtheta_peaks_t{j}))); 
                else
                    max_headtheta_t(j) = 0;
                end
                max_headtheta_t(j) = max_headtheta_t(j)/pi*180;
                idx_temp = find(point_min(:,1) == pairs_decelerate_t(j,2));
                speed_theta_pair(j,1) = point_min(idx_temp,2);
                speed_theta_pair(j,2) = max_headtheta_t(j);
                ratio_theta_pair(j,1) = pairs_decelerate_ratio_t(j);
                ratio_theta_pair(j,2) = max_headtheta_t(j);
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
    end
    speed_theta_pair_all = [speed_theta_pair_all;speed_theta_pair];
    ratio_theta_pair_all = [ratio_theta_pair_all;ratio_theta_pair];
    speed_before_decelerate_all = [speed_before_decelerate_all;speed_before_decelerate_t'];
    point_min_speed_max = max(point_min(:,2));
    point_min_all = [point_min_all;point_min_speed_max];
    decelerateData{index}.badframes_headTheta = badframes_headTheta;
    decelerateData{index}.badframes_tailspeed = badframes_tailspeed;
    decelerateData{index}.point_min_t = point_min;
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
    decelerateData{index}.sub_threshold_segment = sub_threshold_segment_s;
    decelerateData{index}.headomega_peak_t = headomega_peak_t;
    decelerateData{index}.omega_zero_frame_t = omega_zero_frame_t;
    decelerateData{index}.decele_corr_headomega_peaks_t = decele_corr_headomega_peaks_t;
    decelerateData{index}.decele_corr_headtheta_peaks_t = decele_corr_headtheta_peaks_t;
    decelerateData{index}.speed_theta_pair = speed_theta_pair;
    decelerateData{index}.ratio_theta_pair = ratio_theta_pair;
    decelerateData{index}.speed_before_decelerate = speed_before_decelerate_t;
    decelerateData{index}.threshold_headtheta = threshold_headtheta;
    decelerateData{index}.cast_max_frames_t = cast_max_frames_t;
    decelerateData{index}.cast_zero_frames_t = cast_zero_frames_t;
end
    decelerate_pair.speed_theta_pair_all = speed_theta_pair_all;
    decelerate_pair.ratio_theta_pair_all = ratio_theta_pair_all;
    decelerate_pair.speed_before_decelerate_all = speed_before_decelerate_all;
    decelerate_pair.point_min_all = point_min_all; 
cd(dataDir);
save decelerateData;
save decelerate_pair;
cd(currentDir);
clear all;
