% 3D binary convolution example
%3D input and 4D weights
% Author: Esha Uboweja (euboweja)
M = 3; N = 5; C = 2; K = 2;
W = rand([M, N, C, K])
s = logical(rand_binmat([M, N, C, K]))
W(s) = -W(s)
B = sign(W)
alpha = sum(abs(W(:))) ./ numel(W(:))
A = alpha * B
M = 5; N = 7;
I = rand([M, N, C])
% flip weights before sending to MATLAB
Aflip = A;
for f = 1:K
    for ch = 1:C
        Aflip(:, :, ch, f) = rot90(A(:, :, ch, f),2);
    end
end
r = binconv3d_matlab(I, Aflip, 'valid')
m = binconv3d(I, A, 'valid')
fprintf('Error in 3d-4d VALID convolution = %f\n', mean(abs(r(:) - m(:))));
r = binconv3d_matlab(I, Aflip, 'same')
m = binconv3d(I, A, 'same')
fprintf('Error in 3d-4d SAME convolution = %f\n', mean(abs(r(:) - m(:))));