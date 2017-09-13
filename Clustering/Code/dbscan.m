function [ processed_points,c,outliers ] = dbscan( points )
%Implementation of the DBSCAN clustering algorithm

pt = points;
[func, ad_list] = distribution_function(pt);

processed_points = cluster(func,ad_list);
c = find_centroids(processed_points,points);

outliers = zeros(histc(func,-1),size(points,2));
cnt = 1;
for i = 1:size(points,1);
    if(func(i) == -1)
        outliers(cnt,:) = points(i,:);
        cnt = cnt + 1;
    end
end

    
%proc = assign_unclustered_points(c,processed_points,points);
%plot_clusters(points,processed_points);

%the final step is to find the cluster centroids and assign all the
%unassigned clusters to their centroids.
% num_clusters = max(processed_points);



end

