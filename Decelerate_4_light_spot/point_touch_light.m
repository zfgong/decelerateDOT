function point_touch_light_t = point_touch_light(light)
    if size(light,1) == 0
        point_touch_light_t  = -1;
        display('NO light touching');
    else
        point_touch_light_t = light(1);
    end
end
