% 2D binary convolution example
% Author: Esha Uboweja (euboweja)
M = 3; N = 5;
W = rand([M, N])
s = logical(rand_binmat([M, N]))
W(s) = -W(s)
B = sign(W)
alpha = sum(abs(W(:))) ./ numel(W(:))
A = alpha * B
M = 5; N = 7;
I = rand([M, N])
r = conv2(I, A, 'same')
m = matrix_convolve(I, A, 'same')
d = direct_convolve(I, A, 'same')
mean(abs(m(:) - r(:)))
mean(abs(m(:) - d(:)))
mean(abs(d(:) - r(:)))