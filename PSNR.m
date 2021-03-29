function [PSNR,MSE]=PSNR(O,J)
    [N,M] = size(J);
    count=sum(sum((double(O(:,:))-double(J(:,:))).^2));
    MSE = count/(M*N);
    PSNR = 10*log10((255^2)/MSE);    
end