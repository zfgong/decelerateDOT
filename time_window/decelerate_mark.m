clear all;
dataDir = 'E:\SOS_software\time_window\data\';
currentDir = pwd;
motorDataDir = fullfile(dataDir,'motorData.mat');
load(motorDataDir);
decelerateDir = fullfile(dataDir,'decelerateData.mat');
load(decelerateDir);
decele_mark_t = {{}};
decele_mark = {{}};
m = size(motorData, 2);
for i=1:m
    point_min = decelerateData{i}.point_min_t;
    pairs_decelerate = decelerateData{i}.pairs_decelerate_t;
    touch_light = decelerateData{i}.point_touch_light_t;
    if touch_light == -1
        continue;
    end
    point_min_t = point_min(:,1);
    if  ~isempty(pairs_decelerate)
    decele_start_t = pairs_decelerate(:,1);
    [decele_mark_t{i}.after, decele_mark_t{i}.before] = get_decele_mark(point_min_t,decele_start_t,touch_light);
    end   
end
min_after = 40;
min_before = 10;
j=0;
for i = 1:m
        display(i);
    display(decele_mark_t{i}.before);
    if (size(decele_mark_t{i}.after,2) > min_after) & (size(decele_mark_t{i}.before,2) > min_before)
        j = j + 1;
        decele_mark{j} = decele_mark_t{i};
    end
end
sum={};
sum.after = decele_mark{1}.after;
sum.before= decele_mark{1}.before;
n = size(decele_mark,2)
for i=2:n
    if ~isempty(decele_mark{i})
        if (length(sum.after) > 40)
        sum.after = decele_mark_sum(sum.after,decele_mark{i}.after);
        sum.before = decele_mark_sum(sum.before,decele_mark{i}.before);
        end
    end
end
display(sum.after);
sum.after = sum.after(1:min_after);
sum.before = sum.before(1:min_before);
move = length(sum.before);
n = length(sum.after) + length(sum.before);
stem((-(move-1):1:(n-move)),[fliplr(sum.before),sum.after]);
hold;
stem([min_before,min_before]-move,[0,10],'red');
axis([-50 100 0 max(max(sum.after),max(sum.before))]);
cd(dataDir);
save sum

