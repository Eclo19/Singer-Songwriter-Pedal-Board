function y = allpass_filter_bank(x, allpass_coeff)
    % Apply a series of allpass filters to the input signal x
    % x - input signal
    % allpass_coeff - cell array containing sets of coefficients for each allpass filter
    
    % Initialize the output signal with the input
    y = x;
    
    % Pass the signal through each allpass filter in series
    for i = 1:length(allpass_coeff)
        % Coefficients for the current allpass filter
        c1 = allpass_coeff{i}(1);
        c2 = allpass_coeff{i}(2);
        
        % Instantiate the allpass filter with the provided coefficients
        allpassFilterObj = dsp.AllpassFilter('AllpassCoefficients', [c1, c2]);
        
        % Process the signal with the current allpass filter
        y = allpassFilterObj(y);
    end
end