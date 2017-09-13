function [ clse, test_clse ] = read_files( path_train, path_test )
%A function to read the training and test files.

fp_train = fopen(path_train,'r');
fp_test = fopen(path_test,'r');
[clse,lclse] = fscanf(fp_train, '%f');
[test_clse, ltestclse] = fscanf(fp_test, '%f');

end

