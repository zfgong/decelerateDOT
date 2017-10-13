# decelerateDOT
Self-defined variables in Decelerate_data_test_DOT.

1.	DecelerateData:  the dataset for all parameters to be saved
2.	Decelerate_light:  the dataset for the light evoked response related parameters
3.	First_decelerate_min_speed: minimal speed after the first light evoked deceleration
4.	First_decelerate_speed_change: change in minimal speed after first light evoked deceleration
5.	First_decelerate_ratio: ratio of change in minimal speed after first light evoked deceleration
6.	First_decelerate_time: time duration of first light evoked deceleration
7.	First_decelerate_deceleration: average rate of speed change in the first light evoked deceleration
8.	Headtheta_light_frame: the frame number of the light evoked headtheta peak
9.	Headomega_light_frame: the frame number of the light evoked headomega peak
10.	Headtheta_light_value: value of the light evoked headtheta peak
11.	Headomega_light_value: value of the light evoked headomega peak
12.	Point_min: point of minimal speed, including frame number and value of speed
13.	Point_touch_light_t: number of the first frame that larva enters light
14.	Point_end_light_t: number of the last frame that larva stays in light before leaving
15.	Pairs_decelerate_t: frame number of the start and end of the minimal speed of decelerate
16.	Pairs_decelerate_value_t: value of the start and end minimal speed of decelerate 
17.	First_point_min_light_ID: frame number of the first minimal speed in light
18.	First_point_min_light: value of minimal speed in light
19.	Threshold_tailspeed: threshold value for tailspeed
20.	Sub_threshold_segments_s: the time window of the period in which tailspeed is below threshold
21.	Cast_max_frames_t: frame number of headtheta peaks
22.	Headomega_peak_t: frame number of headomega peaks
23.	Omega_zero_frame_t: frame number of headomega zeros
24.	Light_window: the time window to judge the headomega peaks evoked by light
25.	Pairs_decelerate_light_t: light evoked decelerate minimal speed pairs
26.	Decele_corr_headomega_peaks_t: the frame number of headomega peak that related to decelerate
27.	Decele_corr_headtheta_peaks_t: the frame number of headtheta peak related to decelerate
28.	Fpp_decelerate_t: frames per period of deceleration
29.	Fpp_before_decelerate_t: frames per period before deceleration
30.	Periods_change_ratio: ratio of change in frames per period before and after deceleration
31.	Distance_decelerate_pairs_cm_t: distance traveled per period during decelerate by centroid
32.	Distance_decelerate_pairs_tail_t: distance traveled per period during decelerate by tail
33.	Distance_before_decelerate_pairs_cm_t: distance traveled per period before decelerate by centroid
34.	Distance_before_decelerate_pairs_tail_t: distance traveled per period before decelerate by tail
35.	Distance_pairs_tail_change_ratio_t: ratio in distance change by tail
36.	Distance_pairs_cm_change_ratio_t: ratio in distance change by centroid
37.	first_decelerate_light_ID_t_temp: all decelerate in the light define time window
38.	first_decelerate_light_ID_t: the decelerates in light window
39.	headtheta_light_temp: frame number of light evoked headtheta peaks in the time window 
40.	headomega_light_temp: frame number of light evoked headomega peaks in the time window
41.	headtheta_light_temp_maxID: frame number of the largest headtheta peak in the time window
42.	headtheta_light_frame_t: frame number of the selected headtheta peak (with maximal headtheta peak)
43.	headomega_light_frame_t: frame number of the selected headomega peak


The flowchart

Basic rules of event identification: 
1. Deceleration is required for headomega peak. 2.Headomega peak is required for headtheta peak (if there is no deceleration there won’t be a headcast shown by headomega peak; if there is not head cast, larval body angle will not change).

Extraction of decelerate-headomega peak-headtheta peak cassette (DOT assembly):
Start → larva body motion → extraction of deceleration (>5% decrease in minimal and <15% increment in maximal tailspeed in neighboring periods) → deciding the deceleration related time window for judging headomega peak (for deceleration end speed above threshold of 0.5, start from beginning of deceleration, finish at 2 periods after ending of deceleration; for deceleration end speed below threshold of 0.5, use the same subthreshold time window that spans end of deceleration ) → (for each headomega peak, find the headomega zero point that follows, the corresponding headtheta peak is the one; if there is no corresponding headtheta peak, find the headomega zero point before it and the corresponding headtheta peak is the one) → find the found largest headtheta peak → find the corresponding headomega peak → find the corresponding deceleration  → DOT cassette found






