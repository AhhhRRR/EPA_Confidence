clear,clc;

imgpath = 'Train10';
img = imread([imgpath,'\test_','000','.png']); % 讀取圖片
pixel=numel(img); % 每張圖有幾個pixel

%noise_level=rand*0.9;
true_noise_img = imnoise(img,'salt & pepper',0.6); % 隨機加入最高90%的雜訊量
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

[M,N]=size(detected_noise_img); %取得detected_noise_img的長寬
B = detected_noise_img; %B=讀取的偵測的雜訊圖
B = [B(:, 1), B, B(:, N)]; %將圖片四邊加上一圈
B = [B(1, :); B; B(M, :)]; 
aa=16; %門檻值
cmap=zeros(M+2,N+2);
for i = 2:M+1
    for j = 2:N+1
         w = B((i-1:i+1),(j-1:j+1));
         w=double(w);
         if ((abs(w(1)-w(5))<aa) && (abs(w(5)-w(9))<aa)) || ((abs(w(3)-w(5))<aa) && (abs(w(5)-w(7))<aa)) || ((abs(w(2)-w(5))<aa) && (abs(w(5)-w(8))<aa)) || ((abs(w(4)-w(5))<aa) && (abs(w(5)-w(6))<aa))
             cmap(i,j)=0;
         else
             cmap(i,j)=1;
         end
    end
end

 k=1;
 num=zeros(M+1,N+1);
 while true
  for i = 2:M+1
      for j = 2:N+1
          D=zeros(1,8);
          w = B((i-1:i+1),(j-1:j+1));
          w=double(w);
          cmapw = cmap((i-1:i+1),(j-1:j+1));
          a=w(1,1);b=w(1,2);c=w(1,3);d=w(2,1);e=w(2,3);f=w(3,1);g=w(3,2);h=w(3,3);
          fcmap=cmapw(3,1);hcmap=cmapw(3,3);
          num(i,j)=sum(sum(cmapw));
          if num(i,j)==k && cmap(i,j)==1
              D(1)=abs(d-h)+abs(a-e)+abs(a-d);
              D(2)=abs(a-g)+abs(b-h)+abs(a-b);
              D(3)=3*abs(b-g);
              D(4)=abs(b-f)+abs(c-g)+abs(b-c);
              D(5)=abs(c-d)+abs(e-f)+abs(c-e);
              D(6)=3*abs(d-e);
              s=512;
              if ((s<=D(1)&D(1)<=768) || (s<=D(2)&D(2)<=768)) && hcmap==0
                  D(7)=3*abs(a-h);
              else
                    D(7)=768;
              end
              if ((s<=D(4)&D(4)<=768) || (s<=D(5)&D(5)<=768)) && fcmap==0
                  D(8)=3*abs(c-f);
              else
                 D(8)=768;
              end
              
              [val,ind]=min(D);
%               if s<=val
%                   B(i,j)=medfilt2(D);
%               end
              switch ind
                  case 1
                      B(i,j)=(a+d+e+h)/4;
                  case 2
                      B(i,j)=(a+b+g+h)/4;
                  case 3
                      B(i,j)=(b+g)/2;
                  case 4
                      B(i,j)=(b+c+f+g)/4;
                  case 5
                      B(i,j)=(c+d+e+f)/4;
                  case 6
                      B(i,j)=(d+e)/2;
                  case 7
                      B(i,j)=(a+h)/2;
                  case 8
                      B(i,j)=(c+f)/2;
              end
          end          
      end  
  end
  
    if i==M+1 && j==N+1
        k=k+1;
        if k==10
            break;
        end
        continue
    end
 end

finish_noise_img=B(2:M+1,2:N+1);

subplot(1,3,1);imshow(img);title('原圖')
subplot(1,3,2);imshow(detected_noise_img);title('雜訊圖')
subplot(1,3,3);imshow(finish_noise_img);title('濾波圖')

[PSNR,MSE]=PSNR(img,finish_noise_img);
PSNR
MSE





