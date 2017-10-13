function [decele_corr_headomega_peaks_t, decele_corr_theta_peaks_t] = decele_corr_headomega_peaks(point_min, pairs_decelerate, headomega_peak,theta_peak,omega_zero_frame,sub_threshold_segment)

n = size(pairs_decelerate,1);
m = size(point_min,1);
decele_corr_headomega_peaks_t = {};
decele_corr_theta_peaks_t = {};
if ~isempty(sub_threshold_segment)
    for i = 1:n
        sub_threhold_segment_t = find((sub_threshold_segment(:,2)>pairs_decelerate(i,2))&(sub_threshold_segment(:,1)<pairs_decelerate(i,2)),1);
        if ~isempty(sub_threhold_segment_t)
            decele_corr_headomega_peaks_t{i} = headomega_peak(find((headomega_peak>pairs_decelerate(i,1))&(headomega_peak<sub_threshold_segment(sub_threhold_segment_t,2))));
            omega_size_t = max(size(decele_corr_headomega_peaks_t{i}));
            if min(size(decele_corr_headomega_peaks_t{i})) == 0
               decele_corr_theta_peaks_t{i} = pairs_decelerate(i,2);
               decele_corr_headomega_peaks_t{i} = pairs_decelerate(i,2);            
            else
                for j = 1:omega_size_t
                    omega_peak_corr_zero_t =  omega_peak_corr_zero(decele_corr_headomega_peaks_t{i}(j),omega_zero_frame);
                    for x = 1:size(omega_peak_corr_zero_t)
                        if isempty(intersect(theta_peak,omega_peak_corr_zero_t(x)+1))&isempty(intersect(theta_peak,omega_peak_corr_zero_t(x)))&isempty(intersect(theta_peak,omega_peak_corr_zero_t(x)-1))
                            decele_corr_theta_peaks_t{i}(j) = omega_peak_corr_zero_t(x);
                        else
                            decele_corr_theta_peaks_t{i}(j) = omega_peak_corr_zero_t(x)-1;
                        end
                    end
                end
            end
        else
            start_t = find(point_min(:,1)==pairs_decelerate(i,1));
            end_t = find(point_min(:,1)==pairs_decelerate(i,2));
            if end_t < m-1
                end_t = end_t +2;
            else
                end_t = m;
            end
            decele_corr_headomega_peaks_t{i} = headomega_peak(find((headomega_peak>point_min(start_t,1))&(headomega_peak<point_min(end_t,1))));
            omega_size_t = max(size(decele_corr_headomega_peaks_t{i}));
            if min(size(decele_corr_headomega_peaks_t{i})) == 0
            decele_corr_theta_peaks_t{i} = point_min(end_t,1);
            decele_corr_headomega_peaks_t{i} = point_min(end_t,1);               
            else
                for j = 1:omega_size_t
                    
                    omega_peak_corr_zero_t = omega_peak_corr_zero(decele_corr_headomega_peaks_t{i}(j),omega_zero_frame);
                    for x = 1:size(omega_peak_corr_zero_t)
                        if isempty(intersect(theta_peak,omega_peak_corr_zero_t(x)+1))&isempty(intersect(theta_peak,omega_peak_corr_zero_t(x)))&isempty(intersect(theta_peak,omega_peak_corr_zero_t(x)-1))
                            decele_corr_theta_peaks_t{i}(j) = omega_peak_corr_zero_t(x);
                        else
                            decele_corr_theta_peaks_t{i}(j) = omega_peak_corr_zero_t(x)-1;
                        end
                    end
                end
            end
        end
    end
else
    for i = 1:n
        start_t = find(point_min(:,1)==pairs_decelerate(i,1));
        end_t = find(point_min(:,1)==pairs_decelerate(i,2));
        if end_t < m-1
            end_t = end_t +2;
        else
            end_t = m;
        end
        decele_corr_headomega_peaks_t{i} = headomega_peak(find((headomega_peak>point_min(start_t,1))&(headomega_peak<point_min(end_t,1))));
        omega_size_t = max(size(decele_corr_headomega_peaks_t{i}));
        if min(size(decele_corr_headomega_peaks_t{i})) == 0
            decele_corr_theta_peaks_t{i} = point_min(end_t,1);
            decele_corr_headomega_peaks_t{i} = point_min(end_t,1);
        else
            for j = 1:omega_size_t
                
                omega_peak_corr_zero_t = omega_peak_corr_zero(decele_corr_headomega_peaks_t{i}(j),omega_zero_frame);
                for x = 1:size(omega_peak_corr_zero_t)
                    if isempty(intersect(theta_peak,omega_peak_corr_zero_t(x)+1))&isempty(intersect(theta_peak,omega_peak_corr_zero_t(x)))&isempty(intersect(theta_peak,omega_peak_corr_zero_t(x)-1))
                        decele_corr_theta_peaks_t{i}(j) = omega_peak_corr_zero_t(x);
                    else
                        decele_corr_theta_peaks_t{i}(j) = omega_peak_corr_zero_t(x)-1;
                    end
                end
            end
        end
    end
end
end
