clear;
close all;

display('light spot region recognition!');

lightregion={}; % this light region data is to be saved at each experiment
display('Write "return" when the light is in the arena');
keyboard;
filename='M:\SOS\video\20160724\light area.avi'
vidobj=VideoReader(filename);
firstbg=read(vidobj,1)
goodbackground=firstbg;
thresholdbackground=0.3                                                                                                                                                       ; % adjust threshold to extract visualize light spot % the threshold value can be adjustable

imspot=im2bw(firstbg,thresholdbackground);
% imspot=1-imspot; % If animal is white in a black background, comment this line
imspot=imclearborder(imspot);
[LO,num]=bwlabel(imspot,8);
Areas=regionprops(LO,'area');
area_val=[Areas.Area];
maxarea=max(area_val);
idxBig= find(maxarea == area_val);
it2=ismember(LO,idxBig);
it2=imfill(it2,'holes');
[c r]=find(it2);
lightregion.image=it2;
lightregion.region = [r c];
radiu = 10;
N=2*radiu + 1;
dilate_area=zeros(N,N);
[i, j] = meshgrid(1:N, 1:N);
idx = find((i-radiu-1).^2 + (j-radiu-1).^2 <= radiu^2);
dilate_area(idx) = 1;

lightregion.erodeimage = imdilate(lightregion.image, dilate_area);
[Row, Col] = find(lightregion.erodeimage == 1);
lightregion.eroderegion = [Col, Row];

cd(outdir);
save lightregion lightregion;
