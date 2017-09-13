function [ mod_centroids ] = purge_centroids( centroids, points )
%This function processes the centroids and removes the centroids which are
%too close to each other.

r = find_rad_of_influence(points);
null_ct = ones(1,size(centroids,2));
null_ct = -null_ct;

for i = 1:size(centroids,1)
    c1 = centroids(i,:);
    if sum(c1 - null_ct) ~= 0
        for j = 1:size(centroids,1)
            if j ~= i
                c2 = centroids(j,:);
                if euclid_dist(c1,c2) < (r*2)
                    centroids(j,:) = null_ct;
                end
            end
        end
    end
end

mod_centroids = zeros(1,size(centroids,2));

for i = 1:size(centroids,1)
    c1 = centroids(i,:);
    if sum(c1 - null_ct) ~= 0
        mod_centroids = [mod_centroids;c1];
    end
end

mod_centroids = mod_centroids(2:end,:);

end

