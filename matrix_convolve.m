function result = matrix_convolve(input, kernel, type)
% matrix_convolve - im2col based implementation of convolution as a matrix
%                   multiplication of the input with the kernel
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
    col_input = im2col(new_input, size(kernel));
    result = reshape(col_input' * kernel(:), size(input));
elseif strcmp(type, 'valid')
    col_input = im2col(input, size(kernel));
    result = reshape(col_input' * kernel(:), (size(input)-(p .* 2)));
end


end
