function y = allpass_filter(x, c1, c2)
    % Apply a second-order allpass filter using dsp.AllpassFilter to signal x
    % x - Input signal
    % c1, c2 - Allpass filter coefficients
    
    % Create a second-order allpass filter object
    allpassFilterObj = dsp.AllpassFilter('AllpassCoefficients', [c1, c2]);
    
    % Filter the input signal
    y = allpassFilterObj(x);
end