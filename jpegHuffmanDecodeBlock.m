function [block] = jpegHuffmanDecodeBlock(bitStr, type)
% JPEGHUFFMANDECODEBLOCK decodes a bit stream of an 8x8 block encoded with 
% Huffman according to the Huffman tables defined in the annex of the JPEG 
% standard.
%
% BLOCK = JPEGHUFFMANDECODEBLOCK(BITSTR, 'L') decodes the luminance bit 
% stream representation in BITSTR, which is an array of chars of 1's and 
% 0's, according to the Huffman tables defined in the annex of the JPEG 
% standard.
%
% BITSTR is a cell array of arrays of chars. Each Huffman codeword is
% encoded as two elements of the cell array, one for the Huffman code and
% another one for the value. The first two elements in BITSTR correspond to
% the DC coefficient. BITSTR must correspond to an 8x8 block and finish 
% with the EOB code.
%
% BLOCK is an 8x8 array of coefficients after Huffman decoding.
%
% BLOCK = JPEGHUFFMANDECODEBLOCK(BITSTR, 'C') decodes the bit stream
% representation of chrominace symbols.
%
% See also JPEGHUFFMANENCODEBLOCK.
%

% Generation of Huffman codes for DC and AC in luminances and chrominances
persistent huff_lac huff_cac;
[~, huff_lac, ~, huff_cac] = huffman_codes();

switch type
    case 'L'
        huff_ac = huff_lac;
        zrl = '11111111001';
        
    case 'C'
        huff_ac = huff_cac;
        zrl = '1111111010';
    
    otherwise
        error('Type must be L (luminance) or C (chromince).');
end

% Huffman decoding of the DC coefficient
x = 2;
block = zeros(1, 64);

% Special decoding of the value 0 in binary since it can represent the
% value 0 or −1 in decimal depending on the value of size
if strcmp(bitStr{2}, '0')
    if strcmp(bitStr{1}, '00')
        block(1) = 0;
    else
        block(1) = -1;
    end
else
    block(1) = huffmanBinaryToDecimal(bitStr{2});
end

% RLE decoding of AC coefficients
i = 3;
while i < length(bitStr)
    % ZLR decoding when the run of zeros has exceeded the maximum length
    if strcmp(bitStr{i}, zrl)
        x = x+14;
        i = i+1;
    end

    % Huffman decoding of AC coefficients
    [run, ~] = find(strcmp(huff_ac, bitStr{i}));
    block(x+run-1) = huffmanBinaryToDecimal(bitStr{i+1});
    x = x+run;

    i = i+2;
end
end