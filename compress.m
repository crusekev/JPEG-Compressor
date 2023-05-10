function outImg = compress(imgFile, qf)
    %COMPRESS Summary of this function goes here
    %   Detailed explanation goes here
    % Load source image and copy 
    % ito output image
    sourceImg = imread(imgFile);
    
    % Deal with cases: if qf is out-of-bounds or if qf implies no
    % compression (We do not want to introduce rounding errors)
    if (qf > 100) || (qf < 0)
        return;
    elseif qf == 100
        outImg = sourceImg;
        imwrite(outImg, "output.png");
        return;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%
    %  PT.1:  COMPRESSION  %
    %%%%%%%%%%%%%%%%%%%%%%%%
    
    ycbcr = RGBtoYCBCR(sourceImg);

    ycbcr_422 = ycbcr;
    ycbcr_422(:, 2:2:end, 2:3) = ycbcr_422(:, 1:2:end-1, 2:3);

    % ycbcr_422_norm = (ycbcr_422 - min(ycbcr_422(:))) / (max(ycbcr_422(:)) - min(ycbcr_422(:))) * 255;
    
    ycbcr_dct = DCT(ycbcr_422);
    y_dct = ycbcr_dct(:,:,1);
    cb_dct = ycbcr_dct(:,:,2);
    cr_dct = ycbcr_dct(:,:,3);

    lum_quant = [16 11 10 16 24 40 51 61; 12 12 14 19 26 58 60 55; 14 13 16 24 40 57 69 56; 14 17 22 29 51 87 80 62; 18 22 37 56 68 109 103 77; 24 35 55 64 81 104 113 92; 49 64 78 87 103 121 120 101; 72 92 95 98 112 100 103 99];
    chr_quant = [17 18 24 47 99 99 99 99; 18 21 26 66 99 99 99 99; 24 26 56 99 99 99 99 99; 47 66 99 99 99 99 99 99; 99 99 99 99 99 99 99 99; 99 99 99 99 99 99 99 99; 99 99 99 99 99 99 99 99; 99 99 99 99 99 99 99 99];
    
    % Change quantization tables based on qf
    if qf >= 50
        scaling_factor = (100-qf)/50;
    else
        scaling_factor = (50/qf);
    end

    if scaling_factor ~= 0 % if qf is not 100
        lum_scale = round(scaling_factor .* lum_quant);
        chr_scale = round(scaling_factor .* chr_quant);
    else
        lum_scale = ones(8); %no quantization
        chr_scale = ones(8); %no quantization
    end

    lum_scale = uint8(lum_scale); %max is clamped to 255 for qf=1
    chr_scale = uint8(chr_scale); %max is clamped to 255 for qf=1
    
    % Setup for DCT quantization
    [rows, cols]=size(ycbcr_dct(:,:,1));
    y_quant = zeros(rows,cols);
    cb_quant = zeros(rows,cols);
    cr_quant = zeros(rows,cols);
    
    % Apply DCT quantization
    for i = 1:rows
        for j = 1:cols
            y_quant(i,j) = round(y_dct(i,j) / double(lum_scale(mod(i - 1, 8) + 1, mod(j - 1, 8) + 1)));
            cb_quant(i,j) = round(cb_dct(i,j) / double(chr_scale(mod(i - 1, 8) + 1, mod(j - 1, 8) + 1)));
            cr_quant(i,j) = round(cr_dct(i,j) / double(chr_scale(mod(i - 1, 8) + 1, mod(j - 1, 8) + 1)));
        end
    end
    dct_quant = cat(3, y_quant, cb_quant, cr_quant);

    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PT.2:  DECOMPRESSION  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%

    % Dequantize elements to perform IDCT
    y_dequant = zeros(rows,cols);
    cb_dequant = zeros(rows,cols);
    cr_dequant = zeros(rows,cols);
    for i = 1:rows
        for j = 1:cols
            y_dequant(i,j) = round(y_quant(i,j) * double(lum_scale(mod(i - 1, 8) + 1, mod(j-1, 8) + 1)));
            cb_dequant(i,j) = round(cb_quant(i,j) * double(chr_scale(mod(i-1, 8) + 1, mod(j-1, 8) + 1)));
            cr_dequant(i,j) = round(cr_quant(i,j) * double(chr_scale(mod(i-1, 8) + 1, mod(j-1, 8) + 1)));
        end
    end
    dct_dequant = cat(3, y_dequant, cb_dequant, cr_dequant);
    
    % Apply IDCT and convert color space: ycbcr -> RGB
    ycbcr_decomp = IDCT(dct_dequant);
    ycbcr_decomp = round(ycbcr_decomp);
    outImg = YCBCRtoRGB(ycbcr_decomp);
    imshow(outImg);
    imshow(sourceImg);
    % return;

    %%%%%%%%%%%%%%%%%%%%
    %  PT.3:  OUTPUTS  %
    %%%%%%%%%%%%%%%%%%%%
    
    filename = sprintf("qf%d_%s", qf, imgFile);
    imwrite(outImg, "output.png");

    % MISC %
    % The following can be used for the lab report

    % Bullet Point 1
    % -> Show 8x8 blocks for each stage in step 1
    % Concatenate the images: 
    block1 = sourceImg(1:8, 1:8, 2);
    block2 = ycbcr(1:8, 1:8, 2);
    block3 = ycbcr_422(1:8, 1:8, 2);
    block4 = ycbcr_dct(1:8, 1:8, 2);
    block5 = dct_quant(1:8, 1:8, 2);
    Im = [block1 block2 block3;
          block4 block5 block1]; 
    image(Im);
    axis image off

    % Bullet Point 2
    % -> Show all steps from source Image to output
    montage({sourceImg, ycbcr, ycbcr_422, ycbcr_dct, dct_quant, dct_dequant, outImg}, "Size", [2 4]);
end