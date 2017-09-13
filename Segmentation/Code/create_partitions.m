function [ partitions ] = create_partitions( clse )
%Given the time series clse, the function calculates the
%partitions for appropriate segmentation of the time series.

%variable to store the average difference between points
diff = 0;

for i = 2:length(clse)
    diff = diff + abs(clse(i) - clse(i-1));
end

w = diff/length(clse);

num_partitions = floor((max(clse) - min(clse))/w);
partitions = zeros(num_partitions,2);

cnt = min(clse);
for i = 1:num_partitions
    partitions(i,1) = cnt;
    partitions(i,2) = cnt + w;
    cnt = cnt + w;
end

end

