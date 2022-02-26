function imgRGB = convertYCbCrToRGB(imgYCbCr)
% CONVERTYCBCRTORGB converts YCbCr color values to RGB.
%
% imgRGB = CONVERTRGBTOYCBCR(imgYCbCr) converts the YCbCr values in the
% image imgYCbCr to RGB and stores them in imgRGB.
%
% imgYCbCr can be uint8 or double. 
% imgRGB is always double.
%
% See ALSO CONVERTRGBTOYCBCR.
%

[M, N, nColors] = size(imgYCbCr);
if (nColors ~= 3)
    error('Image must be YCbCr');
end

if isinteger(imgYCbCr)
    imgYCbCr = double(imgYCbCr);
end

imgRGB = zeros(size(imgYCbCr));
for m = 1:M
    for n = 1:N
        imgRGB(m, n, 1) = imgYCbCr(m, n, 1)                                       + 1.402   * (imgYCbCr(m, n, 3) - 128);
        imgRGB(m, n, 2) = imgYCbCr(m, n, 1) - 0.34414 * (imgYCbCr(m, n, 2) - 128) - 0.71414 * (imgYCbCr(m, n, 3) - 128);
        imgRGB(m, n, 3) = imgYCbCr(m, n, 1) + 1.772   * (imgYCbCr(m, n, 2) - 128);
    end
end
imgRGB = uint8(imgRGB);
end