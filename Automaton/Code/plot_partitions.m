function [ ] = plot_partitions( num_part, start_and_end, clse, large_partitions )
%A function to plot the number of large partitions used as states in the
%automaton.

intervals = large_partitions;

for i = 1:num_part
    line([1,length(clse)],[intervals(i,1),intervals(i,1)]);
end
line([1,length(clse)],[intervals(num_part,2),intervals(num_part,2)]);

end

