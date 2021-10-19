function [vocrefd,ref3d]=vocumdepfocus(im1,slopemin,slopemax)%mn2,
LF=im1;%%imout slopemin slopemax,mn1
LFSize = size(LF);
%%%%%%%%%%%%%%%%%%%%%%%%%%
BW = 0.04;%0.04
FiltOptions = [];
FiltOptions.Rolloff = 'Butter';
%[H, FiltOptionsOut] = LFBuild4DFreqHyperfan( LFPaddedSize, slopemin, slopemax, BW, FiltOptions );
[Hdf,FiltOptionsOut] = LFBuild4DFreqDualFan( LFSize,slopemin, slopemax, BW, FiltOptions );
LFFilt = LFFilt4DFFT( LF, Hdf, FiltOptionsOut );
vocrefd=LFDisp(LFFilt);
step       = (slopemax-slopemin)/2;
for Slope = slopemin:step:slopemax
[ShiftImg] = LFFiltShiftSum( LFFilt, Slope );
ShiftImg=ShiftImg(:,:,1:3);
n0=(Slope-slopemin)/step+1;n0=round(n0);
ref3d(:,:,:,n0)=ShiftImg;
end 