function ycbcr = RGBtoYCBCR(rgbImg)
%RGBTOYCBCR Summary of this function goes here
%   Detailed explanation goes here
    
    % Reshape RGB image to allow matrix multiplication

    R = double(rgbImg(:, :, 1)) ./ 255;
    G = double(rgbImg(:, :, 2)) ./ 255;
    B = double(rgbImg(:, :, 3)) ./ 255;

    Y = (0.299 * R) + (0.587 * G) + (0.114 * B);
    Cb = (-0.16874 * R) - (0.33126 * G) + (0.5 * B);
    Cr = (0.5 * R) - (0.41869 * G) - (0.08131 * B);

    Cb = Cb + 0.5;
    Cr = Cr + 0.5;

    ycbcr = cat(3, uint8(Y .* 255), uint8(Cb .* 255), uint8(Cr .* 255));

end 