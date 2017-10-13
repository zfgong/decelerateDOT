function sub_threshold_segment_s = sub_threshold_segment(speed,threshold)
n = size(speed,2);
start_frame = find(speed > threshold,1);
j=0;
cross_point=[];
sub_threshold_segment_s =[];

if ~isempty(start_frame)
    for i = start_frame : (n-1)
        if (speed(i)-threshold) * (speed(i+1)-threshold) <0
            j = j+1;
            cross_point(j) = i;
        end
    end
end
j = size(cross_point,2);
if j>1
    if speed(cross_point(1))> threshold
        for i = 1:fix(j/2)
            start_t = cross_point(2*i-1)+1;
            end_t = cross_point(2*i);
            sub_threshold_segment_t = [start_t, end_t];
            sub_threshold_segment_s = [sub_threshold_segment_s;sub_threshold_segment_t];
        end
    else
        for i = 1;fix(j/2)
            start_t = cross_point(2*i)+1;
            end_t = cross_point(2*i+1);
            sub_threshold_segment_t = [start_t, end_t];
            sub_threshold_segment_s = [sub_threshold_segment_s;sub_threshold_segment_t];
        end
    end
else
    sub_threshold_segment_s =[];
end
end