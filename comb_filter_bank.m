function y_bank = comb_filter_bank(x, fs, num_filters, base_delay_ms, delay_spread, a, b, c)
    % Ensure that x is a row vector
    if iscolumn(x)
        x = x';
    end
    
    % Initialize matrix to hold output of each comb filter with proper orientation
    y_bank = zeros(length(x), num_filters);

    % Iterate over each comb filter
    for i = 1:num_filters
        % Calculate a random delay time for current filter in the range [1, delay_spread]
        random_delay = randi(delay_spread);

        % Calculate current filter's delay including base_delay_ms
        current_delay_ms = base_delay_ms + (i-1) * random_delay;
        
        % Call comb_filter with the current delay and assign the output as a column in y_bank
        y_bank(:, i) = comb_filter(x, fs, current_delay_ms, a, b, c)';
    end
end