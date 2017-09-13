function [ res ] = find_squared_error( vec1, vec2 )
%A function to return the sum squared error between vec1 and vec2.

err = vec1 - vec2;
sq_err = err.^2;
res = sum(sq_err);

end

