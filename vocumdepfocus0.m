%%vocumetric focus-----LFBuild4DFreqHyperfan.m%%
function [vocrefr,ref3r,slopemin,slopemax]=vocumdepfocus0(LF,LFMetadata,par)


%%%%%%%%%%%%%%%%%%%%the following code is quoted from the following paper
% @INPROCEEDINGS{8451077, 
% author={L. {Shi} and S. {Zhao} and W. {Zhou} and Z. {Chen}}, 
% booktitle={2018 25th IEEE International Conference on Image Processing (ICIP)}, 
% title={Perceptual Evaluation of Light Field Image}, 
% year={2018}, 
% volume={}, 
% number={}, 
% pages={41-45}, 
% keywords={data compression;image coding;image reconstruction;stereo image processing;perceptual evaluation;light field quality;image quality assessment;degree of freedom;windowed 5 degree of freedom light field image database;Databases;Interpolation;Image quality;Distortion;Transform coding;Image coding;Image reconstruction;Light field;Image quality assessment;Degree of Freedom (DOF);Database;Perceptual evaluation}, 
% doi={10.1109/ICIP.2018.8451077}, 
% ISSN={2381-8549}, 
% month={Oct},}

if ~isa(LF,'uint8') 
   LF=im2uint8(LF);  
end
maxLambda = par.maxLambda;
minLambda = par.minLambda;
depthmap = par.depthmap;
if ~isa(depthmap,'uint8') 
    depthmap = im2uint8(depthmap);
end 
%   read parameters
f=LFMetadata.lens.focalLength*10^5;     %main lens focal length
fnum=LFMetadata.lens.fNumber;           %f-number of main lens and microlens
lambda=LFMetadata.lens.infinityLambda;  %the minmize distance of sensor plane move to cover a pitch
pitch = LFMetadata.mla.lensPitch*10^5;  %the pitch of microlens
distance = f + lambda*fnum*pitch;               %the distance of from main lens to microlens
A = f/fnum;                                     %aperture of main lens

% LF_size = size(LF);
unique_depth = unique(depthmap);
bb=length(unique_depth);
for depth_id = [1,bb] 
    depth = unique_depth(depth_id);
    curLambda = double(depth)/255*(maxLambda-minLambda) + minLambda;    %the lambda distance to refocus to current depth
    curDistance = curLambda*fnum*pitch;                                 %convert the unit 
    slope(depth_id) = curDistance/(distance-curDistance)*(A/15)/pitch;%A/15
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%the above code is quoted from the above paper

slopemin=slope(1);
slopemax=slope(bb);
%%%%%%%%%%%%%%%%%%%%%%%%%%% 
LFSize = size(LF);
 
% A=size(LF,3);
% if A==512
%  LFPaddedSize = [16, 16, 512, 512];
% else 
%   LFPaddedSize = [16, 16, 434, 625];   
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%
BW = 0.04;%0.04
FiltOptions = [];
FiltOptions.Rolloff = 'Butter';%gaussian
%[H, FiltOptionsOut] = LFBuild4DFreqHyperfan( LFPaddedSize, slopemin, slopemax, BW, FiltOptions );
[Hdf,FiltOptionsOut] = LFBuild4DFreqDualFan( LFSize,slopemin, slopemax, BW, FiltOptions );
LFFilt = LFFilt4DFFT( LF, Hdf, FiltOptionsOut );
vocrefr=LFDisp(LFFilt);%
step       = (slopemax-slopemin)/2;
for Slope = slopemin:step:slopemax
[ShiftImg] = LFFiltShiftSum( LFFilt,Slope);
ShiftImg=ShiftImg(:,:,1:3);
n0=(Slope-slopemin)/step+1;n0=round(n0);
ref3r(:,:,:,n0)=ShiftImg;
end 

