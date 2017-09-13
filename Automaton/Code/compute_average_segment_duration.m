function [ sum_length ] = compute_average_segment_duration( start_partition, end_partition, cluster, len_segments, segment_partitions, cluster_idx)
%A function to compute the average temporal length (or duration) of time
%blocks which start at "start_partition", end at "end_partition" and
%represent the primitive pattern given by "cluster".

num_segments = length(len_segments);

sum_length = 0;
count_seg = 0;

for i = 1:num_segments-2
    if ((segment_partitions(i,1) == start_partition) && (segment_partitions(i,2) == end_partition) && (cluster_idx(i) == cluster))
        sum_length = sum_length + len_segments(i);
        count_seg = count_seg + 1;
    end
end

if count_seg ~= 0
    sum_length = sum_length/count_seg;
end
        
end

