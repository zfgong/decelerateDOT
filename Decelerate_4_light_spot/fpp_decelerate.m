% fpp is frames per period
function fpp_decelerate_t = fpp_decelerate( pairs_decelerate_t, point_min )
    n = size(pairs_decelerate_t, 1);
    fpp_decelerate_t = [];
    for i=1:n
       start_frame = pairs_decelerate_t(i,1);
       end_frame = pairs_decelerate_t(i,2);
       frames = end_frame - start_frame + 1;
       n1 = find(point_min(:,1) == start_frame, 1);
       n2 = find(point_min(:,1) == end_frame, 1);
       period = n2 - n1;
       fpp_decelerate_t = [fpp_decelerate_t, frames / period];
    end
end

