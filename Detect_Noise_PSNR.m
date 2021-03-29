clear,clc;

imgpath = 'Train10';
img = imread([imgpath,'\test_','000','.png']); % 讀取圖片
pixel=numel(img); % 每張圖有幾個pixel

%noise_level=rand*0.9;
true_noise_img = imnoise(img,'salt & pepper',0.05); % 隨機加入最高90%的雜訊量
noise1 = find(true_noise_img == 0 | true_noise_img == 255); % 找出胡椒鹽雜訊點


for i = 1:length(noise1) % 將胡椒鹽雜訊改成隨機雜訊
    true_noise_img(noise1(i)) = rand*255;
end

true_noise_map = int8(true_noise_img) - int8(img); % 真實雜訊地圖
% detected_noise_img = imnoise(true_noise_img,'salt & pepper',(noise_level)/10);
detected_noise_img = true_noise_img;
noise2 = find(detected_noise_img == 0 | detected_noise_img == 255);

% for i=1:length(noise2)
%     detected_noise_img(noise2(i)) = rand*255;
% end

detected_noise_map = int8(detected_noise_img) - int8(img); % 模擬偵測雜訊地圖

% [PSNR,MSE]=PSNR(img,true_noise_img); %學長撰寫之PSNR
% PSNR
% MSE

psnr = psnr(true_noise_img,img) % matlab內建之psnr
%-------------------------------------------------------------------------%

% subplot(2,3,1);
% imshow(img);
% subplot(2,3,2);
% imshow(true_noise_img);
% subplot(2,3,3);
% imshow(true_noise_map)
% subplot(2,3,5);
% imshow(detected_noise_img)
% subplot(2,3,6);
% imshow(detected_noise_map)

%-------------------------------------------------------------------------%
