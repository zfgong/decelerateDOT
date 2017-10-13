function [ output_args ] = Untitled( input_args )
clear;
close all;
dir='N:\SOS\analyses\'; 
cd(dir);
light={};
load motorData;
framelight=[];
dirl='N:\SOS\analyses\';
cd(dirl);
n = size(motorData,2);

for larvaIdx=1:n;
    framelight = [];
    load lightregion;
    A=ismember(motorData{larvaIdx}.headXYRaw, lightregion.eroderegion,'rows');
    framelight=find(A==1);
    framelight = sort(framelight);
    larvalframe=1:length(motorData{larvaIdx}.headXYrnd);
    lightframe=ismember(larvalframe,framelight);
    light{larvaIdx}.framelight=framelight;
    light{larvaIdx}.lightframe=lightframe;
end
save light light;
end

