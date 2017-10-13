function omega_zero_frame_t = omega_zero_frame(omega,threshold)
% return the frame number of threshold-crossing point
n = size(omega,2);
start_frame = find(omega > threshold,1);
j=0;
omega_zero_frame_t =[];
if ~isempty(start_frame)
    for i = 1 : (n-1)
        if (omega(i)-threshold) * (omega(i+1)-threshold) <0
            j = j+1;
            omega_zero_frame_t(j) = i;
        end
    end
end
