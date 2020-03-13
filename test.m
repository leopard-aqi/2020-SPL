load(['data\5DLFr.mat']);%referenced light field image
load(['data\5DLFd.mat']);%distorted light field image
%the LFMetadata and par files are from EPFL database
load(['data\LFMetadata.mat']);
load(['data\par.mat']);
addpath('dualfan'); 
[vocrefr,ref3r,slopemin,slopemax]=vocumdepfocus0(im11,LFMetadata,par); 
[vocrefd,ref3d]=vocumdepfocus(im20,slopemin,slopemax);
%spatial quality
vocrefr=double(im2uint8(vocrefr));
refvolDogr=DOG(vocrefr); 
vocrefd=double(im2uint8(vocrefd));
refvolDogd=DOG(vocrefd); 
spatial=ssim(refvolDogr,refvolDogd);%imr,imd);  
%angular qality
for q=1:3
imout1=ref3r(:,:,:,q); 
imout1=double(im2uint8(imout1)); 
imout2=ref3d(:,:,:,q); 
imout2=double(im2uint8(imout2)); 
ref3(q)=ssim(imout1,imout2);%D1,D2);
end 
angular=mean(ref3); 
overall=0.5*angular+0.5* spatial