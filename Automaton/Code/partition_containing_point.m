function [ zone ] = partition_containing_point( partitions, pt )
%A function to return the partition which contains a given point.

zone = 0;

for i = 1:(size(partitions,1))
    if(pt >= partitions(i,1) && pt <= partitions(i,2))
        zone = i;
        break;
    end
end

num_part = size(partitions,1);

if (zone == 0)
    if (pt > partitions(num_part,2))
        zone = num_part;
    else if(pt < partitions(1,1))
            zone = 1;
        end
    end
end

end

