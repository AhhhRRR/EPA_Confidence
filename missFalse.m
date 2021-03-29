function [Nmiss, Nfalse]=missFalse(img,cimg,cmap,ctype)
%img=原圖
%cimg=雜訊圖
%cmap=被判斷出為雜訊的位置
%ctype, default=0:cruppted

th1=1;
if ctype==1
    cmap=ones(size(cmap))-cmap;
end
img=double(img);
cimg=double(cimg);
% umimg=abs(img-cimg);
% 
%  [i,j]=find(umimg<=th1); % uncorrupt  
%  tmap=sparse(i,j,ones(size(i)));
 tmap = (img==cimg);
 %miss,corrupted 判為noise free
 unmatch=cmap-tmap;
 i=find(unmatch>0);
 Nmiss=length(i);
  %false, noise free判為corrupted
 i=find(unmatch<0);
 Nfalse=length(i);

 