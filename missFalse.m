function [Nmiss, Nfalse]=missFalse(img,cimg,cmap,ctype)
%img=���
%cimg=���T��
%cmap=�Q�P�_�X�����T����m
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
 %miss,corrupted �P��noise free
 unmatch=cmap-tmap;
 i=find(unmatch>0);
 Nmiss=length(i);
  %false, noise free�P��corrupted
 i=find(unmatch<0);
 Nfalse=length(i);

 