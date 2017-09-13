%% The script is used to load and segment a time series into time blocks using the Slope Sensitive Natural Segmentation (SSNS) algorithm.
clc; clear; close all;

%Loading the time-series for segmentation
load('segmentation_data.txt');
clse = segmentation_data; %Close price time-series

%Step 0 : Filtering the time series using a Gaussian Filter for smoothing.
clse = gaussfilt([1:length(clse)]',clse,2);

%Step 1 : Divide the range of the entire time series into equi width
%partitions and find out the label (R,F,E) from each point to its next.
partitions = create_partitions(clse);
seq = transition_sequence(clse);

%Step 2 : Find the window frequencies of the transitions
[sig1,sig2,sig3] = window_frequency(seq);

%Step 3 : Segment the time series based on the window frequencies
%brk is a binary vector (1 = segment boundary, 0 = no segment boundary)
brk = segmentation(sig1,sig2,sig3);

%Plot the segments and the time series.
plot_segments(brk,clse);

%% Generating parameters for each segment which will be required during construction of the training set for clustering %%
%The parameters include: 
% a) Starting index (time-instant) for each segment
% b) Ending index (time-instant) for each segment
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

%% Code for generating the data set to send for clustering %%
%This part of the code is for generating the primitive patterns and can be
%run once for a long time-series. Once the cluster centers (primitive patterns)
%are obtained, we can easily place any given temporal segment into its
%respective cluster.

%Preparing the training set for the clustering algorithm
%Initializing the parameter set for training the clustering algorithm
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

%Mean normalizing the points for clustering
param_bank = param_bank';
[param_bank_mn,mn,sd] = mean_normalize(param_bank);
param_bank = param_bank';
param_bank_mn = param_bank_mn';
