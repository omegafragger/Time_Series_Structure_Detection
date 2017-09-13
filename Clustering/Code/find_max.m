function [ idx,max ] = find_max( func )
%A function to return the index at which the maximum value of func is
%encountered.

max = 0;
max_idx = 1;
flag = 0;

for i = 1:length(func)
    if(func(i) ~= -1)
        flag = 1;
        if(func(i) > max)
            max = func(i);
            max_idx = i;
        end
    end
end

if (flag == 0)
    idx = -1;
else
    idx = max_idx;
end

end

