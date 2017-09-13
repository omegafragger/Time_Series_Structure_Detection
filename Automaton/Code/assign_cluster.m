function [ idx ] = assign_cluster( blocks, centroids )
%The function takes in a set of time blocks each block being a ten
%dimensional point and assigns each temporal block to its respective
%cluster.

num_blocks = size(blocks,1);
num_centroids = size(centroids,1);
idx = zeros(num_blocks,1);

for i = 1:num_blocks
    
    bl = blocks(i,:);
    c = centroids(1,:);
    min_dist = euclid_dist(bl,c);
    idx(i) = 1;
    
    for j = 2:num_centroids
        c = centroids(j,:);
        e = euclid_dist(bl,c);
        if e < min_dist
            min_dist = e;
            idx(i) = j;
        end
    end

end

end

