function [ brk ] = segmentation( sig1,sig2,sig3 )
%The function which returns the indices of the time series at which it has
%to be segmented.

%determining the length of the three signals
len = length(sig1);
%the brk vector contains the indices at which the time series is to be
%segmented.
brk = zeros(len+1,1);

brk(1) = 1;

sg = [sig1(1), sig2(1), sig3(1)];
[mx, st] = max(sg);

for i = 2:len
    sg = [sig1(i), sig2(i), sig3(i)];
    [mx,ch] = max(sg);
    if(ch == st)
        continue;
    else
        if(ch ~= 1 && st == 1 && sig1(i) == mx)
            continue;
        end
        if(ch ~= 2 && st == 2 && sig2(i) == mx)
            continue;
        end
        if(ch ~= 3 && st == 3 && sig3(i) == mx)
            continue;
        end
        brk(i) = 1;
        st = ch;
    end
end
            
%removing the segmentations which are within the 7 day period
k = 0;
for i = 1:(len+1)
    if(brk(i) == 1 && k == 0)
        k = 7;
    else if(brk(i) == 1 && k ~= 0)
            brk(i) = 0;
        end
    end
    if(k > 0)
        k = k - 1;
    end
end
           

end

