% Load the host audio signal
[hostSignal, hsr] = audioread('main_audio.wav');

% Load the watermark audio signal
[watermarkSignal, wmsr] = audioread('wm_audio.wav');

% Normalize the host and watermark signals
hostSignal = hostSignal / max(abs(hostSignal));
watermarkSignal = watermarkSignal / max(abs(watermarkSignal));

% Play the original host and watermark audio
%disp('Playing original host audio...');
%sound(hostSignal, hsr);
%pause(length(hostSignal)/hsr + 1);

%disp('Playing original watermark audio...');
%sound(watermarkSignal, wmsr);
%pause(length(watermarkSignal)/wmsr + 1);

% Watermark Embedding

% Ensure the watermark signal is repeated to match the length of the host signal
numRepetitions = ceil(length(hostSignal) / length(watermarkSignal));
repeatSignal = repmat(watermarkSignal, numRepetitions , 1);
repeatSignal = repeatSignal(1:length(hostSignal));

% Set the echo parameters
delay = 0.1; % Delay for the echo (in seconds)
gain = 0.05; % Gain for the echo

% Create an echo of the watermark signal
echoLength = round(delay * hsr);
echo = zeros(length(hostSignal) + echoLength, 1);
echo(echoLength + 1 : echoLength + length(hostSignal)) = gain * repeatSignal;

% Add the echo to the host signal
watermarkedSignal = hostSignal + echo(1:length(hostSignal));

% Write the watermarked_host audio
audiowrite('watermarked_host_ehw.wav', watermarkedSignal, hsr);


% Play the watermarked host audio
%disp('Playing watermarked host audio...');
%sound(watermarkedSignal, hsr);
%pause(length(watermarkedSignal)/hsr + 1);


% Watermark Extraction

% Extract the watermark from the watermarked signal
extractedWatermark = (watermarkedSignal - hostSignal) / gain;

% Revert the repetitions
extractedWatermark = extractedWatermark(echoLength + 1 : echoLength + length(watermarkSignal));

% Write the extracted watermarked audio from watermarked_host audio
audiowrite('extracted_watermarked_ehw.wav', extractedWatermark, wmsr);


% Play the extracted watermark audio
%disp('Playing extracted watermark audio...');
%sound(extractedWatermark, wmsr);
%pause(length(extractedWatermark)/wmsr + 1);
