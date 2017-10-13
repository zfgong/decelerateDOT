dir='N:\SOS\analyses\';
cd(dir);
load light.mat;
dirFinal=strcat(dir,'\light.txt\framelight.txt')
mkdir(dirFinal);
maxrun=size(light, 2);
for a=1:maxrun
    b=light{a}.framelight;
    cd(dirFinal);
    filename=strcat('light{', num2str(a),'}framelight.txt');
    save(filename, '-ascii', 'b');
end
