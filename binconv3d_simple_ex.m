% 3D binary convolution simple example
% 1 filter, 3D input and 3D weights
% Author: Esha Uboweja (euboweja)
M = 3; N = 5; C = 2;
W = rand([M, N, C])
s = logical(rand_binmat([M, N, C]))
W(s) = -W(s)
B = sign(W)
alpha = sum(abs(W(:))) ./ numel(W(:))
A = alpha * B
M = 5; N = 7;
I = rand([M, N, C])
r = zeros(size(I));
for i=1:C
    r(:, :, i) = conv2(I(:, :, i), A(:, :, i), 'same');
end
m = zeros(size(I));
for i=1:C
    m(:, :, i) = matrix_convolve(I(:, :, i), A(:, :, i), 'same');
end
d = zeros(size(I));
for i=1:C
    d(:, :, i) = direct_convolve(I(:, :, i), A(:, :, i), 'same');
end
mean(abs(m(:) - r(:)))
mean(abs(m(:) - d(:)))
mean(abs(d(:) - r(:)))