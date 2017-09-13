function [ d ] = euclid_dist( p1, p2 )
%A function to calculate the euclidean distance between two
%multidimensional points p1 and p2.
%p1 and p2 can be a 1*n matrix where n is the dimension of the point.

n = size(p1,2);
d = 0;
for i = 1:n
    d = d + (p1(i) - p2(i))^2;
end
d = sqrt(d);
end

