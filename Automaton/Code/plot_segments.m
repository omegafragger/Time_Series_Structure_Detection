function [ ] = plot_segments( brk, clse, start_and_end, num_large_partitions )
%The function plots the segments of the time series clse as given by the
%segmentation function

figure;
len = length(clse(start_and_end(2,1):start_and_end(end-1,2)));

plot([1:len]',clse(start_and_end(2,1):start_and_end(end-1,2)),'k*-');
hold on;

yL = get(gca,'Ylim');

for i = 1:len
    if(brk(i+(start_and_end(2,1)-1)) == 1)
        line([i,i],yL,'Color','k');
    end
end

hold on;
plot_partitions(num_large_partitions, start_and_end, clse);

end

