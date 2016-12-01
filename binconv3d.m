function [result] = binconv3d(input, weights, type)
% binconv3d - im2col based implementation of convolution as a matrix
%             multiplication of the input with the kernel for 3d inputs
%             and 4d weights
% Arguments:
%   input - M x N x C matrix
%   kernel - p x q x C x k matrix
%   type - one of 'same' or 'valid' for the convolution operation
% Returns:
%   result - of convolution of input with weights
% Author: Esha Uboweja (euboweja)

if isempty(input)
    error('input[arg1] must be a non-empty matrix');
elseif isempty(weights)
    error('weights[arg2] must be a non-empty matrix');
elseif ~(strcmp(type, 'same') || strcmp(type, 'valid'))
    error('type[arg3] must be one of `valid` or `same`');
elseif numel(size(input)) ~= 3
    error('input[arg1] must be a 3D matrix');
elseif numel(size(weights)) ~= 4
    error('weights[arg2] must be a 4D matrix');
elseif any([size(input, 1) < size(weights, 1), ...
            size(input, 2) < size(weights, 2), ...
            size(input, 3) < size(weights, 3)])
    result = [];
    return;
elseif size(input, 3) ~= size(weights, 3)
    error('inputs[arg1] and weights[arg3] must have the same number of channels');
end

rows_in = size(input, 1);
cols_in = size(input, 2);
channels = size(input, 3);
filters = size(weights, 4);
stride = 1;
spatial_ext = size(weights); spatial_ext = spatial_ext(1:2);
pad = [0, 0]; % 'valid' convolution
if strcmp(type, 'same')
    pad = (size(weights) - 1) ./ 2; pad = pad(1:2);
    new_input = zeros([rows_in + 2*pad(1), cols_in + 2*pad(2), channels]);
    new_input((pad(1) + 1):(end - pad(1)), (pad(2) + 1):(end - pad(2)), :) = input;
    input = new_input;
end

rows_out = (rows_in - spatial_ext(1) + 2*pad(1)) / stride + 1;
cols_out = (cols_in - spatial_ext(2) + 2*pad(2)) / stride + 1;

% Implementation 1 - WORKS
% for f = 1:filters
%     for ch = 1:channels
%         col_input = im2col(input(:, :, ch), spatial_ext);
%         kernel = weights(:, :, ch, f);
%         result(:, :, f) = result(:, :, f) + ...
%                           reshape(col_input' * kernel(:), ...
%                                   [rows_out, cols_out]);
% 
%     end
% end
% Implementation 2 - WORKS
% for ch = 1:channels
%     col_input = im2col(input(:, :, ch), spatial_ext);
%     for f = 1:filters
%         kernel = weights(:, :, ch, f);
%         result(:, :, f) = result(:, :, f) + ...
%                           reshape(col_input' * kernel(:), ...
%                                   [rows_out, cols_out]); 
%     end
% end
% Implementation 3 - WORKS
col_input = zeros([spatial_ext(1) * spatial_ext(2) * channels, rows_out * cols_out]);
kernel_input = zeros([spatial_ext(1) * spatial_ext(2) * channels, filters]);
for ch = 1:channels
    start_idx = ch * (spatial_ext(1) * spatial_ext(2));
    end_idx = start_idx + (spatial_ext(1) * spatial_ext(2)) - 1;
    % input
    col_input(start_idx:end_idx, :) = im2col(input(:, :, ch), spatial_ext);
    % weights
    kernel_input(start_idx:end_idx, :) = reshape(weights(:, :, ch, :), ...
                                                 [spatial_ext(1) * spatial_ext(2), filters]);
end
result = reshape(col_input' * kernel_input, [rows_out, cols_out, filters]);


end