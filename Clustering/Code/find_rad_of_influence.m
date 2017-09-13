function [ r1,dist_vec ] = find_rad_of_influence( points )
%A function to determine the radius of influence given the set of mean
%normalized points.

num_points = size(points,1);
cnt = 1;
dist_vec = zeros(num_points^2 - num_points,1);

for i = 1:num_points
    for j = 1:num_points
        if i ~= j
            dist_vec(cnt) = euclid_dist(points(i,:),points(j,:));
            cnt = cnt + 1;
        end
    end
end

dist_vec = sort(dist_vec);
len = length(dist_vec)/10;
p = dist_vec(1:len);
r1 = mean(p);

% sort(dist_vec);
% mean_rad = 0;
% cnt = 0;
% for i = 1:length(dist_vec)
%     if(dist_vec(i)>0 && dist_vec(i)<1)
%         cnt = cnt + 1;
%         mean_rad = mean_rad + dist_vec(i);
%         if cnt == 10
%             break;
%         end
%     end
% end
% 
% mean_rad = mean_rad/cnt;
% r = mean_rad;
%r = mean_rad/1.5;
%fprintf('Value of cnt : %d\n',cnt);

end

