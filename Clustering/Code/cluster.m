function [ processed_points ] = cluster( func, ad_list )
%A function to perform the non-parametric clustering using a depth-first
%search or seed filling approach.

%initialising the cluster count to 1 
cluster_cnt = 1;

%getting the number of points to create the hash table to store cluster
%values of processed points.
m = size(func,1);
processed_points = zeros(m,1);

%setting the threshold max for the func vector which, when encountered
%stops the processing.
[mx_idx,mx] = find_max(func);

%Creating stack data structure
stack = zeros(m,1);%an array of point indices
top = 1;%top of stack
%Stack data structure created

%loop ending criterion
while(mx_idx ~= -1 && mx > 3)
    %in one iteration of this while loop we are supposed to create and form
    %one cluster from the data
    
    %Pushing the index onto the stack
    stack(top) = mx_idx;
    top = top + 1;
    
    %Continue while stack is not empty
    while(top ~= 1)
       
       %Pop a point from the stack
       pt_idx = stack(top-1);
       top = top - 1;
       
       %Continue processing on this point if this point has not been seen
       %before
       if func(pt_idx) ~= -1
           %Get the surrounding points for the current popped point
           surr = ad_list(pt_idx,:);
           counter = 1;
           %For each point in the surroinding points, push it in the stack
           %if it has not been processed.
           while 1>=0
               if surr(counter) == 0
                   break;
               end
               if processed_points(surr(counter)) == 0
                   stack(top) = surr(counter);
                   top = top + 1;
               end
               counter = counter + 1;
           end
           %Process the point
           processed_points(pt_idx) = cluster_cnt;
           %Removing the point which has just been processed from the
           %func
           func(pt_idx) = -1;%Logical deletion
       end
    end
    %Incrementing the cluster count by 1 
    cluster_cnt = cluster_cnt + 1;
    
    %Finding the max point and its index
    [mx_idx,mx] = find_max(func);
end

end

