function [ c ] = find_centroids( processed_points,points )
%A function to detect the centroids from the clustered points

num_clusters = max(processed_points);
dim = size(points,2);

c = zeros(num_clusters,dim);

for i = 1:num_clusters
    cnt = 0;
    for j = 1:length(processed_points)
        if(processed_points(j) == i)
            c(i,:) = c(i,:) + points(j,:);
            cnt = cnt + 1;
        end
    end
    c(i,:) = c(i,:)/cnt;
    
end
        

end

