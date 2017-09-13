function [normalized] = normalize_var(array, x, y)
%Function to normalize an array to a given range

% Normalize to [0, 1]:
m = min(array);
range = max(array) - m;
array = (array - m) / range;

% Then scale to [x,y]:
range2 = abs(y - x);
normalized = (array*range2) + min(x,y);