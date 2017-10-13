function [light_window, pairs_decelerate_light_t] = pairs_decelerate_light( point_touch_light_t, pairs_decelerate_t, point_min)
period = 4;
period_advance = 2;
pairs_decelerate_light_t =[];
point_light_index = find(point_touch_light_t <= point_min(:,1));
if size(point_light_index,1) <period
    period = size(point_light_index,1);
end
point_light_index = point_light_index(1);
if point_light_index <= period_advance
    period_advance = point_light_index-1;  
end
start_t = point_light_index-period_advance;
end_t = point_light_index+period;
if end_t > size(point_min,1)
    end_t = size(point_min,1);
end
frame_index = point_min(start_t:end_t,:);
light_window = [point_min(start_t,1), point_min(end_t,1)];
if ~isempty(pairs_decelerate_t)
    pairs_decelerate_light_t_1 = intersect(frame_index(:,1), pairs_decelerate_t(:,1));
    if ~isempty(pairs_decelerate_light_t_1)
        idx = find(ismember(pairs_decelerate_t(:,1),pairs_decelerate_light_t_1));
        pairs_decelerate_light_t = pairs_decelerate_t(idx,:);
    end
end
end

