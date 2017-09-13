%%Script to find the cluster centroids in the given time-segments using a
%%non-parametric DBSCAN clustering approach.
clc;  close all;

%Taking the time-series as input
inp_time_series = input('Enter the time-series to be clustered ("TAIEX" or "NASDAQ" or "DOW"): ', 's');
ts = strcat('param_bank_mn_',lower(inp_time_series));
load(ts);

dt = param_bank_mn;
cent = hierarchical_dbscan(dt);

n = size(cent,1);
for i=1:n
    figure;
    plot([1:10],cent(i,:),'ko-','LineWidth',6);
end
