function [ p1 ] = plot_test_segments( brk, clse, start_and_end, num_large_partitions, large_partitions )
%The function plots the segments of the time series clse as given by the
%segmentation function

figure;
len = length(clse);

p1 = plot([1:len]',clse,'k*-','LineWidth',4);
hold on;



hold on;
%plot_partitions(num_large_partitions, start_and_end, clse, large_partitions);

yL = get(gca,'Ylim');

for i = 1:len
    if(brk(i) == 1)
        line([i,i],yL,'Color','k');
    end
end

end

