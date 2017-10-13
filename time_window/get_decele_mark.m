function [after, before] = get_decele_mark( point_min,start_frame,touch_light)
m = length(point_min);
period = zeros(1,m-1);
n = length(start_frame);
for i=1:n
    index = find(start_frame(i) >= point_min);
    if isempty(index) 
        continue;
    end
    index = index(end);
    period(index) = 1;
end
index_touch_light = find(touch_light >= point_min);
if ~isempty(index_touch_light)
    index_touch_light = index_touch_light(end);
else
    index_touch_light = 1;
end
before = period(1:index_touch_light);
before = fliplr(before);
after = period((index_touch_light+1):end);
end

