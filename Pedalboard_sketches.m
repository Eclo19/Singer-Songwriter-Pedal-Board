%% Low-Shelving

shelvFilt = shelvingFilter(10,1,200,"highpass");

visualize(shelvFilt)


%% Comb Filtering

% Define the parameters for the comb filter    % Sampling frequency in Hz
delayInMs = 5;          % Delay in milliseconds
g = 0.5;                % Gain of the delayed signal

% Convert delay from milliseconds to samples
D = round(delayInMs / 1000 * fs);

%Get audio signal
[x, fs] = audioread("Baby_Im_Yours_cut.wav");

% Feedforward Comb Filter
% Define the feedforward comb filter coefficients
b = [1, zeros(1, D-1), -1]; % Numerator coefficients
a = 1;                      % Denominator coefficients

% Apply the feedforward comb filter to the input signal
y_ff = filter(b, a, x);

% Feedback Comb Filter
% Define the feedback comb filter coefficients
b = 1;                      % Numerator coefficients
a = [1, zeros(1, D-1), -g]; % Denominator coefficients

% Apply the feedback comb filter to the input signal
y_fb = filter(b, a, x);

% Plot the original and filtered signals
figure;
subplot(3,1,1);
stem( x);
title('Original Signal');

subplot(3,1,2);
stem(y_ff);
title('Feedforward Comb Filtered Signal');

%play FF CF Signal
%sound(y_ff, fs)

subplot(3,1,3);
stem(y_fb);
title('Feedback Comb Filtered Signal');

%play FB CF Signal
sound(y_fb, fs)

% Optionally, you can also plot the frequency response of the filters
% using the freqz function
figure;
freqz(b, a); % This will plot the frequency response of the feedback comb filter

% If you want to visualize the frequency response of the feedforward comb filter, call freqz like this:
freqz([1, zeros(1, D-1), -1], 1);
impz ([1, zeros(1, D-1), -1], 1)
 
%% Comb Filter function

%Read Input audio file
[x, fs] = audioread("Baby_Im_Yours_cut.wav"); % Sinusoidal test signal


a = 0.1;         % Coefficient 'a'
b = 0.1;         % Coefficient 'b'
g = 0.1;         % Coefficient 'c' (feedback term, should typically have |c| < 1 for stability)

%Define delay in samples
delay = 1;

% Call the comb filter function
y = comb_filter(x,fs, delay ,a, b, g);

% Plot the original and the filtered signals
figure;
subplot(2,1,1);
stem(y);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
stem(y);
title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');
legend

%Play y
sound(y, fs)

%% Comb filter bank

% Specifications for the comb filter bank
num_filters = 4;       % Number of comb filters in the bank
base_delay_ms = 30;    % Base delay time in milliseconds for the first comb filter
delay_spread = 5;      % Delay increment in milliseconds for successive comb filters
a = 0.1;               % Coefficient 'a'
b = 0.2;               % Coefficient 'b'
g = 0.8;              % Coefficient 'g' (feedback)

% Get mono signal
x = audioread("Baby_Im_Yours_cut.wav"); 
x = x(:, 1) ;

% Generate the filter bank output
y_bank = comb_filter_bank(x, fs, num_filters, base_delay_ms, delay_spread, a, b, g);

% Sum the outputs of the comb filters to create the reverberated signal
y = (sum(y_bank, 2) + x ) ;

% Plot the original signal
figure;
subplot(2,1,1);
stem(x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the reverberated signal
subplot(2,1,2);
stem(y);
title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');

%Play y
%sound(y, fs)


%% One allpass

% Define filter coefficients for a second-order allpass filter
c1 = 0.7; % First coefficient
c2 = 0.5; % Second coefficient

% Apply the second-order allpass filter
y_one_ap = allpass_filter(y, c1, c2);

% Recreate the second-order allpass filter object
allpassFilterObj = dsp.AllpassFilter('AllpassCoefficients', [c1, c2]);

% Get the frequency response
[h, f] = freqz(allpassFilterObj, 1024, fs);

% Plot the frequency response (Bode plot)
figure;
subplot(2,1,1);
semilogx(f, 20*log10(abs(h)));
grid on;
title('Magnitude Response');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');

subplot(2,1,2);
semilogx(f, 180/pi * unwrap(angle(h)));
grid on;
title('Phase Response');
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
xlim([0, fs / 2]); % Limit x-axis to Nyquist frequency

%Play y
%sound(y_one_ap, fs)

%% Allpass Bank

% Define coefficients for each allpass filter in the bank
allpass_coeff = {
    [0.7, 0.5], % Coefficients for the first allpass filter
    [0.6, 0.4], % Coefficients for the second allpass filter
    [0.5, 0.3]  % Coefficients for the third allpass filter 
    [0.1, 0.8]  % Coefficients for the third allpass filter 
};


% Apply the allpass filter bank
y_final = allpass_filter_bank(y, allpass_coeff);

figure();
stem(y_final)
title('Final Reverberated Signal');
xlabel('Time (s)');
ylabel('Amplitude');

%Play y
sound(y_final, fs)


%% Shelving

[x, fs] = audioread('As it Was.mp3');

% Parameters for the shelving filter
gain = 4;            % Gain in dB
slope = 1;            % Filter slope
cutoff = 300;     % Cutoff frequency in Hz
type = 'lowpass';     % Type of filter: 'lowpass' or 'highpass'

%Create filter 1
shelvFilt1 = shelvingFilter(gain,slope,cutoff,type);

%visualize(shelvFilt)

%Apply filter 1
y = shelvFilt1(x);

% Parameters for the shelving filter
gain = 4;            % Gain in dB
slope = 1;            % Filter slope
cutoffFreq = 4000;     % Cutoff frequency in Hz
type = 'highpass';     % Type of filter: 'lowpass' or 'highpass'

%Create filter 1
shelvFilt2 = shelvingFilter(gain,slope,cutoff,type);

%visualize(shelvFilt)

%Apply filter 1
y2 = shelvFilt2(y);

sound(y2, fs)


