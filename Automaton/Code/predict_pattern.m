function [ patterns ] = predict_pattern( start_state, target_state, automaton_transition_prob_matrix, pattern_prob )
%A function to output the most probable pattern which is going to occur
%between the given start and target states.

num_patterns = length(pattern_prob);
probs = zeros(num_patterns, 1);

for k = 1:num_patterns
    probs(k) = automaton_transition_prob_matrix(start_state, target_state, k);
end

mx = max(probs);
if mx == 0
    patterns = -1; %No structure exists in the automaton from given starting state to target state
else
    patterns = find(probs == mx);
    if length(patterns) > 1
        chosen_pattern = patterns(1);
        for i = 1:length(patterns)
            if pattern_prob(patterns(i)) > pattern_prob(chosen_pattern)
                chosen_pattern = patterns(i);
            end
        end
        patterns(1) = chosen_pattern;
    end
end

end

