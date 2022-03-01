%% Setup
n = 1;
img = imread("liver_noisy_blurry.png");
figure(n)
imshow(img)
n = n + 1;

%% Median filtering
figure(n)
imgfilt = medfilt2(img);
imshow(imgfilt)
n = n + 1;

%% Deblurring
figure(n)
F = fspecial("average", 5);
INITPSF = ones(size(F));
[imgdb,psfr] = deconvblind(imgfilt,INITPSF);
imshow(imgdb)
n = n + 1;

%% Enhance grayscale
figure(n)
imgadj = imadjust(imgdb, [0.25, 1]);
imshow(imgadj)
n = n + 1;

figure(n)
imhist(imgadj)
n = n + 1;

figure(n)
imhist(imgdb)
n = n + 1;