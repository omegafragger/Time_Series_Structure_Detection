function [ sig1, sig2, sig3 ] = window_frequency( seq )
%The function calculates three arrays based on the given sequence seq,
%which identifies the consecutive window frequencies of the occurences
%of rise fall and level transitions.

sig1 = zeros(length(seq),1);
sig2 = zeros(length(seq),1);
sig3 = zeros(length(seq),1);

%Window width: A metaparameter to the algorithm has been empirically chosen
%as 5.
for i = 3:(length(seq)-2)
    window = [seq(i-2),seq(i-1),seq(i),seq(i+1),seq(i+2)];
    w1 = histc(window,1);
    w2 = histc(window,2);
    w3 = histc(window,3);
    f1 = w1/7;
    f2 = w2/7;
    f3 = w3/7;
    sig1(i) = f1;
    sig2(i) = f2;
    sig3(i) = f3;
end

% Code to plot the window frequencies
% figure;
% plot([1:length(seq)]',sig1,'g*-');
% hold on;
% plot([1:length(seq)]',sig2,'k*-');
% plot([1:length(seq)]',sig3,'r*-');

end

