% fpp is frames per period 
function fpp_before_decelerate_t = fpp_before_decelerate(pairs_decelerate_t, point_min, advance)
    n = size(pairs_decelerate_t, 1);
    fpp_before_decelerate_t = [];  
    for i=1:n
       decelerate_frame = pairs_decelerate_t(i,1);
       n2 = find(point_min(:,1) == decelerate_frame, 1);
       n1 = n2 - advance;   
       if n2 == 1
          fpp_before_decelerate_t = [fpp_before_decelerate_t, -1];
          continue;
       end
       if(n1 < 1)
          n1 = 1; 
       end
       frames = point_min(n2,1) - point_min(n1,1);
       period = n2 - n1;
       fpp_before_decelerate_t = [fpp_before_decelerate_t, frames / period];
    end
    
end

