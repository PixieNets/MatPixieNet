function result = direct_convolve(input, kernel, type)
% direct_convolve - loop based convolution of input with kernel
% Arguments:
%   input - M x N matrix
%   kernel - p x q matrix
%   type - one of 'same' or 'valid' for the convolution operation
% Returns:
%   result - of convolution of input with kernel
% Author: Esha Uboweja (euboweja)

if isempty(input)
    error('input[arg1] must be a non-empty matrix');
elseif isempty(kernel)
    error('kernel[arg2] must be a non-empty matrix');
elseif ~(strcmp(type, 'same') || strcmp(type, 'valid'))
    error('type[arg3] must be one of `valid` or `same`');
elseif any(size(input) < size(kernel))
    result = [];
    return;
end

% Convolution flips the filter
kernel = rot90(kernel,2);

p = (size(kernel) - 1) ./ 2;

if strcmp(type, 'same')
    new_input = zeros((size(input) + p .* 2));
    new_input((p(1)+1):(end-p(1)), (p(2)+1):(end-p(2))) = input;
    result = do_convolve(new_input, kernel);
elseif strcmp(type, 'valid')
    result = do_convolve(input, kernel);
end

end

function [result] = do_convolve(input, kernel)
% do_convolve - performs loop based convolution
% Arguments:
%   input - M x N matrix
%   kernel - p x q matrix
% Returns:
%   result - of convolution of input with kernel
% Author: Esha Uboweja (euboweja)

rows = size(input, 1);
cols = size(input, 2);
p = (size(kernel) - 1) ./ 2;

result = zeros(size(input) - (p .* 2));
for row = (p(1) + 1):(rows - p(1))
    for col = (p(2) + 1):(cols - p(2))
        cur_res = input((row - p(1)):(row + p(1)), (col - p(2)):(col + p(2))) ...
                    .* kernel;
        result(row - p(1), col - p(2)) = sum(cur_res(:));
    end
end

end