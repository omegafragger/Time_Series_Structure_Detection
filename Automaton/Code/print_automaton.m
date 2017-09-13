function [ ] = print_automaton( automaton_transition_prob_matrix, automaton_expected_duration_matrix )
%A function to represent the DSA in a simple compact form.

num_states = size(automaton_transition_prob_matrix,1);
num_patterns = size(automaton_transition_prob_matrix, 3);

fprintf('----------------------------------------------------------------------------------------------\n');
for i = 1:num_states
    for k = 1:num_patterns
        for j = 1:num_states
            if (automaton_transition_prob_matrix(i,j,k) > 0)
                fprintf('State %d => State %d, Symbol => P%d, Probability => %0.2f, Duration => %0.2f days\n', i, j, k, automaton_transition_prob_matrix(i,j,k), automaton_expected_duration_matrix(i,j,k));
            end
        end
    end
end
fprintf('----------------------------------------------------------------------------------------------\n');

end

