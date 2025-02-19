%% CONFIGURATIONS
inputFile = 'file_example_WAV_2MG.wav';  % Input WAV file
pcmOutputFile = 'file_example_WAV_2MG_pcm.wav';  % PCM compressed output
dctOutputFile = 'file_example_WAV_2MG_dct.wav';  % DCT compressed output

% PCM Configuration
pcmBitDepth = 8;  % Change to 4, 8, 12, 16 for different bit depths

% DCT Configuration
dctThreshold = 0.01; % Threshold for coefficient reduction (0 to 1)

%% READ AUDIO FILE
[signal, Fs] = audioread(inputFile);
signal = mean(signal, 2); % Convert to mono if stereo
t = (0:length(signal)-1) / Fs; % Time axis

%% PCM COMPRESSION
disp('Performing PCM compression...');
maxAmplitude = max(abs(signal)); 
quantizedSignal = round(signal * (2^(pcmBitDepth - 1))) / (2^(pcmBitDepth - 1));
audiowrite(pcmOutputFile, quantizedSignal, Fs);
disp(['PCM Compression complete. File saved as ', pcmOutputFile]);

%% DCT COMPRESSION
disp('Performing DCT compression...');
N = length(signal);
dctCoeffs = dct(signal); % Apply DCT

% Apply thresholding to remove small coefficients
dctCoeffs(abs(dctCoeffs) < dctThreshold * max(abs(dctCoeffs))) = 0;

% Inverse DCT to reconstruct signal
reconstructedSignal = idct(dctCoeffs);

% Normalize to prevent clipping
reconstructedSignal = reconstructedSignal / max(abs(reconstructedSignal)) * maxAmplitude;

% Save the DCT compressed file
audiowrite(dctOutputFile, reconstructedSignal, Fs);
disp(['DCT Compression complete. File saved as ', dctOutputFile]);

%% PLOT THE SIGNALS
figure;
hold on;
plot(t, signal, 'b', 'LineWidth', 1); % Original signal in blue
plot(t, quantizedSignal, 'r', 'LineWidth', 1); % PCM compressed signal in red
plot(t, reconstructedSignal, 'g', 'LineWidth', 1); % DCT compressed signal in green
hold off;

title('Comparison of Original, PCM Compressed, and DCT Compressed Signals');
xlabel('Time (seconds)');
ylabel('Amplitude');
legend('Original Signal', 'PCM Compressed', 'DCT Compressed');
grid on;
xlim([0 min(0.1, t(end))]); % Show only the first 0.1s for better visibility

%% PLAYBACK OPTIONS (Uncomment if needed)
% sound(signal, Fs) % Listen to original uncompressed audio
% pause(2);
% sound(quantizedSignal, Fs); % Listen to PCM compressed audio
% pause(2);
% sound(reconstructedSignal, Fs); % Listen to DCT compressed audio
% pause(2);

disp('Compression process completed.');