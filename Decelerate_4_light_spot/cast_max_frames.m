function cast_max_frames_t = cast_max_frames(headtheta, peakdet_cast_lambda, threshold_headtheta)
max = peakdet(headtheta, peakdet_cast_lambda);
min = peakdet(-headtheta, peakdet_cast_lambda);
max(find(max(:,2)<=0),:) = []; 
min(find(min(:,2)<=0),:) = []; 
peak = [max;min];
if find(abs(peak(:,2)) >= threshold_headtheta)
    index = find(abs(peak(:,2)) >= threshold_headtheta);
    cast_max_frames_t = sort(peak(index,1));
else
    cast_max_frames_t = [];
end
end

