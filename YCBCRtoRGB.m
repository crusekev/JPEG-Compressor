function rgbImage = YCBCRtoRGB(ycbcrImg)
%YCBCRTORGB Summary of this function goes here
%   Detailed explanation goes here
    Y = double(ycbcrImg(:, :, 1)) ./ 255;
    Cb = double(ycbcrImg(:, :, 2)) ./ 255;
    Cr = double(ycbcrImg(:, :, 3)) ./ 255;

    R = Y + (1.402 * (Cr - 0.5));
    G = Y - (0.34414 * (Cb - 0.5)) - (0.71414 * (Cr -0.5 ));
    B = Y + (1.772 * (Cb - 0.5));

    rgbImage = cat(3, uint8(R .* 255), uint8(G .* 255), uint8(B .* 255));

end