function [ zone ] = partition_containing_point( partitions, pt )
%A function to return the partition which contains a given point.

zone = 0;

for i = 1:(size(partitions,1))
    if(pt >= partitions(i,1) && pt < partitions(i,2))
        zone = i;
        break;
    end
end
end

