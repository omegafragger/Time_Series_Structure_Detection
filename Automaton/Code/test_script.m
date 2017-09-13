%% This script is used to process the test data of the time-series.

clse = test_clse;
clse = clse(6:end-5);
partitions = create_partitions(clse);
seq = transition_sequence(clse);

[sig1,sig2,sig3] = window_frequency(seq);

brk = test_segmentation(sig1,sig2,sig3);

% a) Finding the length of each segment 
num_blocks = histc(brk,1);
start_and_end = zeros(num_blocks, 2);
len_segments = zeros(num_blocks, 1);
start_and_end(1,1) = 1;
cnt = 2;
for i = 2:length(brk)
    if(brk(i) == 1)
        start_and_end(cnt-1,2) = i-1;
        start_and_end(cnt,1) = i;
        len_segments(cnt-1) = (start_and_end(cnt-1,2) - start_and_end(cnt-1,1)) + 1;
        cnt = cnt + 1;
    end
end
start_and_end(cnt-1,2) = length(brk);
len_segments(cnt-1) = (start_and_end(cnt-1,2) - start_and_end(cnt-1,1)) + 1;


% b) Finding starting and end partition of each segment
segment_partitions = zeros(num_blocks, 2);

for i = 1:num_blocks
    start_partition = partition_containing_point(large_partitions, clse(start_and_end(i,1)));
    end_partition = partition_containing_point(large_partitions, clse(start_and_end(i,2)));
    segment_partitions(i,1) = start_partition;
    segment_partitions(i,2) = end_partition;
end

%Plot the segments and the time series.
p1 = plot_test_segments(brk, clse, start_and_end, num_large_partitions, large_partitions);
hold on;

%Computing the predicted sequence of structures
prediction = 0;
num_predicted_points = 0;
sum_sq_err = 0;
flag = 0;
predicted_patterns = zeros(size(segment_partitions,1),1);
predicted_duration = zeros(size(segment_partitions,1),1);

for i = 1:size(segment_partitions,1)
    start_state = segment_partitions(i,1);
    target_state = segment_partitions(i,2);
    len = len_segments(i);
    patterns = predict_pattern(start_state, target_state, automaton_transition_prob_matrix, pattern_prob);
    predicted_patterns(i) = patterns(1); %In case of multiple possible patterns choose the first one (can technically choose any pattern)
    if predicted_patterns(i) ~= -1
        predicted_duration(i) = automaton_expected_duration_matrix(start_state, target_state, predicted_patterns(i));
    end
    
    if patterns == -1
        flag = 0;
        continue;
    else
        pattern = patterns(1);
        centroid = cent(pattern,:);
        %Denormalize the cluster centroids
        mn = clse(start_and_end(i,1));
        mx = clse(start_and_end(i,2));
        centroid = normalize_var(centroid, mn, mx);
        %Size normalize the denormalized cluster centroid%
        norm_cent = zeros(1,len);
        jmp = 10/len;
        inc = 0;
        for j = 1:len
            norm_cent(j) = centroid(1 + floor(inc));
            inc = inc + jmp;
            num_predicted_points = num_predicted_points + 1;
        end
        if flag == 1
            plot([start_and_end(i-1,2), start_and_end(i,1)], [prev_point, norm_cent(1)], 'ro-', 'LineWidth', 4);
        end
        p2 = plot([start_and_end(i,1):start_and_end(i,2)], norm_cent, 'ro-', 'LineWidth', 4);
        prev_point = norm_cent(len);
        sq_err = find_squared_error(norm_cent', clse(start_and_end(i,1):start_and_end(i,2)));
        sum_sq_err = sum_sq_err + sq_err;
        flag = 1;
    end
end

%Adding features to the graph
l = legend([p1, p2], 'Actual time-series', 'Predicted time-series');
set(l, 'FontSize', 15);
xlabel('Time---------------------->', 'FontSize', 15);
ylabel('Test period time-series value---------------------->', 'FontSize', 15);

mean_sq_err = sum_sq_err / num_predicted_points;
rmse = sqrt(mean_sq_err);

%Presenting the output report%
fprintf('============================Output Report============================\n');
fprintf(strcat('Time series on which model was trained:\t', series, '.\n'));
fprintf(strcat('Training Period:\t', year, '.\n'));
fprintf('The DSA generated is as follows: \n');
print_automaton(automaton_transition_prob_matrix, automaton_expected_duration_matrix);
fprintf('Printing test phase results:------------------------------------------\n');
fprintf('Number of segments in test phase time-series: %d\n', num_blocks);
fprintf('-----------------------------------------------------------------------\n');
fprintf('Segment id\tStart partition\tTarget Partition\tPredicted pattern\tPredicted Duration\n');
for i = 1:num_blocks
    if predicted_patterns(i) ~= -1
        fprintf('\t\t%d\t\t\t\t%d\t\t\t\t%d\t\t\t\tP%d\t\t\t\t%f\n',i,segment_partitions(i,1), segment_partitions(i,2),predicted_patterns(i),predicted_duration(i));
    else
        fprintf('\t\t%d\t\t\t\t%d\t\t\t\t%d\t\t\t  N.A.\t\t\t  N.A.\n',i,segment_partitions(i,1), segment_partitions(i,2));
    end
end
fprintf('The overall RMSE of prediction is: %f\n',rmse);
fprintf('============================Output Report============================\n');