function [ nearby_points, ad_list ] = distribution_function( X )
%A function to find the number of nearby points given a particular point in
%the points matrix X.
%Each row in X corresponds to an n dimensional point where n is the number
%of columns.

num_points = size(X,1);
nearby_points = zeros(num_points, 1);
ad_list = zeros(num_points, num_points-1);
ad_list_index = ones(num_points,1);

%Function call for finding the dbscan radius parameter
r1 = find_rad_of_influence(X);
%fprintf('The radius chosen is : %d\n',r1);
% r = r/3;

for i = 1:num_points
    p1 = X(i,:);
    for j = 1:num_points
        if(j ~= i)
            p2 = X(j,:);
            if(euclid_dist(p1,p2) < r1)
                nearby_points(i) = nearby_points(i) + 1;
                ad_list(i,ad_list_index(i)) = j;
                ad_list_index(i) = ad_list_index(i) + 1;
            end
        end
    end
end

avr = mean(nearby_points);


%Removing all those points whose surroindings are relatively sparse
for i = 1:num_points
    if(nearby_points(i) < avr)
        nearby_points(i) = -1;
    end
end
end

