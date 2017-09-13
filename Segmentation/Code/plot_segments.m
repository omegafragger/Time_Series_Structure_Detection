function [ ] = plot_segments( brk, clse )
%The function plots the segments of the time series clse as given by the
%segmentation function

figure;
len = length(clse);

plot([1:len]',clse,'k-');
hold on;

yL = get(gca,'Ylim');

for i = 1:len
    if(brk(i) == 1)
        line([i,i],yL,'Color','k');
    end
end

% mx = max(clse);
% mn = min(clse);
% 
% diff = mx-mn;
% 
% num_part = 7;
% width = diff/num_part;
% intervals = zeros(num_part,2);
% 
% for i = 1:num_part
%     intervals(i,1) = mn + (i-1)*width;
%     intervals(i,2) = mn + i*width;
% end
% 
% for i = 1:num_part
%     line([1,length(clse)],[intervals(i,1),intervals(i,1)]);
% end
% line([1,length(clse)],[intervals(num_part,2),intervals(num_part,2)]);




end

