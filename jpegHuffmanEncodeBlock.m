function [bitStr] = jpegHuffmanEncodeBlock(block, type)
% JPEGHUFFMANENCODEBLOCK encodes an 8x8 block (after DCT transform,
% quantization, and zig-zag conversion) according to the Huffman tables
% defined in the annex of the JPEG standard.
%
% BITSTR = JPEGHUFFMANENCODEBLOCK(BLOCK, 'L') encodes the 8x8 BLOCK and 
% outputs the bit stream in BITSTR as an array of chars of 1's and 0's.
%
% SYMBOLS is an array of 64 coefficients: the DC plus 63 AC coefficients.
%
% BITSTR is a cell array of arrays of chars. Each huffman codeword is
% encoded as two elements of the cell array, one for the Huffman code and
% another one for the value. The first two elements in BITSTR correspond to
% the DC coefficient.
%
% BITSTR = JPEGHUFFMANENCODEBLOCK(SYMBOLS, 'C') encodes the array of 
% chromince symbols. 
%
% See also JPEGHUFFMANDECODEBLOCK.
%

% Generation of Huffman codes for DC and AC in luminances and chrominances
persistent huff_ldc huff_lac huff_cdc huff_cac;
[huff_ldc, huff_lac, huff_cdc, huff_cac] = huffman_codes();

switch type
    case 'L'
        huff_dc = huff_ldc;
        huff_ac = huff_lac;
        zrl = '11111111001';
        eob = '1010';
    
    case 'C'
        huff_dc = huff_cdc;
        huff_ac = huff_cac;
        zrl = '1111111010';
        eob = '00';
    
    otherwise
        error('Type must be L (luminance) or C (chromince).');
end

% Huffman encoding of the DC coefficient
bitStr = {};
b = huffmanDecimalToBinary(block(1));

% Special encoding of the value 0 in binary, since it can represent the
% value 0 or −1 in decimal depending on the value of size
if block(1) == 0
    bitStr{end+1} = huff_dc{1};
else
    bitStr{end+1} = huff_dc{1+strlength(b)};
end
bitStr{end+1} = b;

% RLE encoding of AC coefficients
zeros = 0;
for i = 2:length(block)
    % RLE encoding of the run of zeros
    if block(i) == 0
        zeros = zeros+1;
    else
        % ZLR encoding when the run of zeros has exceeded the maximum length
        if zeros > 15
            streak = floor(zeros/15);
            for z=1:streak
                bitStr{end+1} = zrl;
            end
            zeros = streak+1;
        end

        % Huffman encoding of AC coefficients
        b = huffmanDecimalToBinary(block(i));
        bitStr{end+1} = huff_ac{1+zeros, strlength(b)};
        bitStr{end+1} = b;

        zeros = 0;
    end
end

% Mark of the end of the data block
bitStr{end+1} = eob;
end