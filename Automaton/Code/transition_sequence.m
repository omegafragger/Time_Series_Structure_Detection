function [ seq ] = transition_sequence( clse )
%The function produces the sequences of rise and falls which will be used
%in determining the segments of the time series.
% 1 -> rise
% 2 -> level (equality)
% 3 -> fall

partitions = create_partitions(clse);
seq = zeros(1,1);

for i = 2:length(clse)
    z_prev = partition_containing_point(partitions,clse(i-1));
    z_now = partition_containing_point(partitions,clse(i));
    if(z_now - z_prev > 0)
        seq = [seq, 1];
    else 
        if(z_now - z_prev < 0)
            seq = [seq, 3];
        else
            seq = [seq, 2];
        end
    end
end

seq = seq(2:end);
seq = seq';
end

