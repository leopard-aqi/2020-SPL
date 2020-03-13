function D = DOG(inputImage)
% This function is to extract sift features from a given image
Scales=2;
Sigma=1.3;
    %% Setting Variables.
    Sigmas = sigmas(Scales,Sigma);
    %% Calculating Gaussians
        [row,col,color] = size(inputImage);
        temp = zeros(row,col,color,Scales);
        for s=1:Scales
            temp(:,:,:,s) = imgaussfilt(inputImage,Sigmas(1,s));
        end

    %% Calculating DoG
        images =temp;
        temp = zeros(row,col,color);
        temp(:,:,:) = images(:,:,:,2) - images(:,:,:,1);
        D= temp;
function matrix = sigmas(scale,sigma)
% Function to calculate Sigma values for different Gaussians
    matrix = zeros(1,scale);
    k = 1.6;%sqrt(2);
        for j=1:scale
            matrix(1,j) = k^(j-1)*sigma;
        end