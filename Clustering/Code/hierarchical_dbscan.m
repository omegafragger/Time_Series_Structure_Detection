function [ cent ] = hierarchical_dbscan( points )
%Implementation of multi-layered hierarchical DBSCAN clustering

orig_numpt = size(points,1);

[idx,c,out] = dbscan(points);
cent = c;

num_out = size(out,1);

while num_out > (orig_numpt/10)
    [idx,c,out] = dbscan(out);
    cent = [cent;c];
    num_out = size(out,1);
end

%Removing the redundant centroids
cent = purge_centroids(cent,points);

end

