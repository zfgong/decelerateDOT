function omega_peak_corr_zero_t = omega_peak_corr_zero(headomega_peak,omega_zero_frame)
m = max(size(omega_zero_frame));
n = max(size(headomega_peak));
omega_peak_corr_zero_t = zeros(1,n);

for i = 1:n
    idx = find(omega_zero_frame > headomega_peak(i),1);
    if ~isempty(idx)
        omega_peak_corr_zero_t(i) = idx;
    else
        omega_peak_corr_zero_t(i) = m;
    end
    omega_peak_corr_zero_t(i) = omega_zero_frame(omega_peak_corr_zero_t(i));
end
