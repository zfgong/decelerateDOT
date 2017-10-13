function point_end_light_t = point_end_light(light)
	if size(light,1) == 0
		point_end_light_t = -1;
	else
	 	point_end_light_t = light(size(light,1))
	end
end
