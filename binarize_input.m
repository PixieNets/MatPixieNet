function [B, alpha] = binarize_input(W)
% binarize_input - given a double precision weights tensor, returns a
%                  binary approximation given by B, alpha
% Arguments:
%   W - double precision weights tensor
% Returns:
%   B - binarized sign(W) tensor, (values denoted as 1->1, (-1)->0)
%   alpha - average of sum of absolute values of W
% Author: Esha Uboweja (euboweja)

B = sign(W);
B(B < 0) = 0;

alpha = sum(abs(W(:))) ./ numel(W(:));

end