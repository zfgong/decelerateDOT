function [point_min, point_max, pairs_decelerate_temp] = pairs_decelerate(speed, kernel, peakdet_lambda,threshold_min,threshold_max) 
    data = filter2(kernel, speed);
    point_max = peakdet(data, peakdet_lambda);
    point_min = peakdet(-data, peakdet_lambda);
    point_min(:,2) = - point_min(:,2);
    point_min(find(point_min(:,2)==0),:) = [];
    n = size(point_min, 1); 
    if point_max(1,1) >= point_min(1,1)
        point_min = point_min(2:n,:);
        n = n - 1;
    end
    if point_max(size(point_max, 1), 1) <= point_min(n, 1) 
        point_min = point_min(1:(n-1), :);
        n = n - 1;
    end
    pairs_decelerate_t_origin =[]; 
    for i=1:(n-1)
        if (point_min(i,2) - point_min(i+1, 2)) > (threshold_min * point_min(i, 2))
            cond1 = (point_max(i,2) - point_max(i+1,2)) > (threshold_max*point_max(i,2));
            cond2 = (point_max(i+1,2) - point_max(i+2,2)) > (threshold_max*point_max(i+1,2));
            cond3 = point_max(i+1,2) < point_max(i,2) * 1.15;
            cond2 = cond2 & cond3;
            if cond1 | cond2
                pairs_decelerate_t_origin= [pairs_decelerate_t_origin; point_min(i,1), point_min(i+1,1)];
            end
        end
    end
    
    if ~isempty(pairs_decelerate_t_origin)
       pairs_decelerate_temp = [pairs_decelerate_t_origin(1,:)];
    else 
        pairs_decelerate_temp= [];
    end
    now_index = 1;
    for i=2:size(pairs_decelerate_t_origin,1)
        if pairs_decelerate_t_origin(i, 1) == pairs_decelerate_temp(now_index, 2)
            pairs_decelerate_temp(now_index, 2) = pairs_decelerate_t_origin(i,2);
        else
            now_index = now_index + 1;
            pairs_decelerate_temp = [pairs_decelerate_temp; pairs_decelerate_t_origin(i,:)];
        end
    end
end
