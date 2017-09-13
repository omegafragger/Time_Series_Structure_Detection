function [ partitions ] = create_large_partitions( clse, num_part )
%A function to find k partitions of a given time-series.
mn = min(clse);
mx = max(clse);

%Computing width and initializing partition data structure
width = (mx - mn) / num_part;
partitions = zeros(num_part,2);

partitions(1,1) = mn;

for i = 1:(num_part-1)
    partitions(i,2) = partitions(i,1) + width;
    partitions(i+1,1) = partitions(i,2);
end

partitions(i+1,2) = partitions(i+1,1) + width;
end

