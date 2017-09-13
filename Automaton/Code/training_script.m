%% The script is used to load and segment a time series into time blocks using the Slope Sensitive Natural Segmentation (SSNS) algorithm.
clc; clear; close all;

%Loading the test time-series
series = input('Please input the time-series ("TAIEX" or "NASDAQ" or "DOW"):', 's');
year = input('Please input the year (1990/1991/1992/1993/1994/1995/1996/1997/1998/1999):', 's');

path_train = strcat('../Data/',series,'/',lower(series),year,'train.txt');
path_test = strcat('../Data/',series,'/',lower(series),year,'test.txt');
[clse, test_clse] = read_files(path_train, path_test);


%Loading the centroids obtained from the corresponding tims-series
cent_str = strcat('centroids_',lower(series));
load(cent_str);
% load('centroids_dow');

%Step 0 : Filtering the time series using a Gaussian Filter for smoothing.
clse = gaussfilt([1:length(clse)]',clse,2);
test_clse = gaussfilt([1:length(test_clse)]',test_clse,2);

%Step 1 : Divide the range of the entire time series into equi width
%partitions and find out the label (R,F,E) from each point to its next.
partitions = create_partitions(clse);
seq = transition_sequence(clse);

%Step 2 : Find the window frequencies of the transitions
[sig1,sig2,sig3] = window_frequency(seq);

%Step 3 : Segment the time series based on the window frequencies
%brk is a binary vector (1 = segment boundary, 0 = no segment boundary)
brk = segmentation(sig1,sig2,sig3);



%% Generating metaparameters for each segment which will be required during construction of the automaton %%
%The parameters include: 
% a) Length of the segment
% b) Starting partition of the segment
% c) Ending partition of the segment
% d) Cluster to which the segment belongs
% NOTE: We leave out the first and the last segments from our calculations
% as they are distorted due to smoothing.

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
        len_segments(cnt-1) = start_and_end(cnt-1,2) - start_and_end(cnt-1,1);
        cnt = cnt + 1;
    end
end
start_and_end(cnt-1,2) = length(brk);
len_segments(cnt-1) = start_and_end(cnt-1,2) - start_and_end(cnt-1,1);


% b) Finding starting and end partition of each segment

%CHANGE THE PARAMETER "num_large_partitions" BELOW FOR CHANGING THE NUMBER
%OF STATES IN THE AUTOMATON
num_large_partitions = 7;

large_partitions = create_large_partitions(clse(start_and_end(2,1):start_and_end(end-1,2)), num_large_partitions);
segment_partitions = zeros(num_blocks-2, 2);

for i = 2:num_blocks-1
    start_partition = partition_containing_point(large_partitions, clse(start_and_end(i,1)));
    end_partition = partition_containing_point(large_partitions, clse(start_and_end(i,2)));
    segment_partitions(i-1,1) = start_partition;
    segment_partitions(i-1,2) = end_partition;
end

%segment_partitions = segment_partitions(2:end-1, :);

%Plot the segments and the time series.
%plot_segments(brk, clse, start_and_end, num_large_partitions);


% c) Finding the cluster centers for each temporal segment or time-block

%Size normalizing and mean normalizing all the temporal segments
param_bank = zeros(num_blocks, 10);

for i = 1:num_blocks
    ser = clse(start_and_end(i,1):start_and_end(i,2));
    %calculating division length
    l = length(ser);
    jmp = l/10;
    inc = 0;
    for j = 1:10
        param_bank(i,j) = ser(1 + floor(inc));
        inc = inc + jmp;
    end
end

%Mean normalizing the points
param_bank = param_bank';
[param_bank_mn,mn,sd] = mean_normalize(param_bank);
param_bank = param_bank';
param_bank_mn = param_bank_mn';

idx = assign_cluster(param_bank_mn, cent);
idx = idx(2:end-1);


%% Construction of the Dynamic Stochastic Automaton (DSA)

% The states of a DSA correspond to partitions in the time-series. Hence,
% we can represent the automaton using a state transition table where the
% columns and rows both correspond to states. The rows correspond to the
% current state and the columns correspond to the respective next states.
% We also have three labels attached to each arc in the automaton:
% a) The cluster center (primitive pattern) that triggers the transition
% b) The transition probablity
% c) The expected duration of the transition

num_cent = size(cent, 1);
automaton_transition_prob_matrix = zeros(num_large_partitions, num_large_partitions, num_cent);
automaton_expected_duration_matrix = zeros(num_large_partitions, num_large_partitions, num_cent);

%Finding the frequency count entries
for i = 1:num_blocks-2
    st = segment_partitions(i, 1);
    if st == 0
        st = 1;
    end
    en = segment_partitions(i, 2);
    if en == 0
        en = 1;
    end
    cluster = idx(i);
    automaton_transition_prob_matrix(st,en,cluster) = automaton_transition_prob_matrix(st,en,cluster) + 1;
end

%Normalizing the count entries to obtain probabilities
for i = 1:num_large_partitions
    s = 0;
    for j = 1:num_cent
        r = automaton_transition_prob_matrix(i,:,j);
        s = s + sum(r);
    end
    if s ~= 0
        for j = 1:num_cent
            automaton_transition_prob_matrix(i,:,j) = automaton_transition_prob_matrix(i,:,j) ./ s;
        end
    end
end

%Computing the expected duration labels of the Dynamic Stochastic Automaton
for i = 1:num_large_partitions
    for j = 1:num_large_partitions
        for k = 1:num_cent
            if automaton_transition_prob_matrix(i,j,k) ~= 0
                automaton_expected_duration_matrix(i,j,k) = compute_average_segment_duration(i, j, k, len_segments, segment_partitions, idx);
            end
        end
    end
end

%Creating a vector for the overall occurrence probability of a primitive
%pattern (cluster center).
pattern_prob = zeros(size(cent,1),1);
for i = 1:length(pattern_prob)
    pattern_prob(i) = histc(idx,i)/length(idx);
end
            