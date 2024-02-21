function y = comb_filter(x, fs, delay_ms, a, b, g)
    % Comb filter that uses the equation y[n] = ax[n] + bx[n-D] + gy[n-D]
    % x - Input signal
    % fs - Sampling frequency in Hz
    % delay_ms - Delay in milliseconds
    % a, b, g - Filter coefficients
    
    % Convert delay from milliseconds to samples
    D = round(delay_ms * fs / 1000);
    
    % Initialize output signal
    y = zeros(size(x));   % Ensures y has the same dimensions as x
    
    % Apply the comb filter to the input signal
    for n = 1:length(x)
        % Include the gain 'a' term
        y(n) = a * x(n);
        
        % Add the feedforward term b * x[n-D]
        if n > D
            y(n) = y(n) + b * x(n - D);
        end
        
        % Add the feedback term c * y[n-D]
        if n > D
            y(n) = y(n) + g * y(n - D);
        end
    end
end