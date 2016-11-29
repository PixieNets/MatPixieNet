function result = xnor(x, y)
% xnor - returns the bitwise xnor of elements in x and y
% Author: Esha Uboweja (euboweja)

if all(size(x) ~= size(y))
    error('x[arg1] and y[arg2] must be of the same size');
end

result = ~xor(x, y);

end