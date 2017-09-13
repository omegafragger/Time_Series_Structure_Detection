function [ X_mn,mn,sd ] = mean_normalize( X )
%A function to mean normalize the data set given in X.

%col here represents the number of columns in X which is equal to the number
%of features or the number of dimensions of a point.
%row represents the number of rows or the number of col dimensional points.
col = size(X,2);

mn = mean(X);
sd = std(X);
X_mn = zeros(size(X));

for i = 1:col
    X_mn(:,i) = (X(:,i)-mn(i))/sd(i);
end

end

