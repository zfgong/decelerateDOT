function distance_decelerate_pairs_t = distance_decelerate_pairs( pairs_decelerate_t, coordinate, point_min)
    n = size(pairs_decelerate_t, 1);
    distance_decelerate_pairs_t = [];
    for i=1:n
        dis_sum = 0;
        for j=pairs_decelerate_t(i,1):(pairs_decelerate_t(i,2)-1)
            dis_sum = dis_sum + distance_pair(coordinate(j,:), coordinate(j+1,:));
        end
        start_frame = pairs_decelerate_t(i,1);
        end_frame = pairs_decelerate_t(i,2);
       
        n1 = find(point_min(:,1) == start_frame, 1);
        n2 = find(point_min(:,1) == end_frame, 1);
        period = n2 - n1;
        distance_decelerate_pairs_t = [distance_decelerate_pairs_t, dis_sum/period];
    end   
    function distance = distance_pair(coord1, coord2)
       temp1 = coord1(1) - coord2(1);
       temp2 = coord1(2) - coord2(2);
       distance = sqrt(temp1*temp1 + temp2*temp2);
    end
end

