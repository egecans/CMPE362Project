% Load the host audio signal
[hostSignal, hsr] = audioread('main_audio.wav');

% Load the watermark audio signal
[watermarkSignal, wmsr] = audioread('wm_audio.wav')

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

% Define the start index of the segment where the watermark will be embedded
startIdx = 50000;  % Modify this value to set the desired start index

% Determine the end index based on the length of the watermark signal
endIdx = startIdx + length(watermarkSignal) - 1;

% Ensure the end index does not exceed the length of the host signal
endIdx = min(endIdx, length(hostSignal));

% Extract the segment from the host signal where the watermark will be embedded
segment = hostSignal(startIdx:endIdx);



% Watermark Embedding

% Perform DFT on the segment
segmentDFT = fft(segment);

% Perform DFT on the watermark signal and adjust its length
watermarkDFT = fft(watermarkSignal);

% Spread Spectrum Watermarking
spreadFactor = 0.01;  % Adjust this value as needed

% Modulate the frequency components of the segment DFT with the watermark DFT
watermarkedDFT = segmentDFT .* (1 + spreadFactor * watermarkDFT);

% Perform inverse DFT to obtain the watermarked segment
watermarkedSegment = real(ifft(watermarkedDFT));

% Replace the watermarked segment in the host signal
hostSignal(startIdx:endIdx) = watermarkedSegment;

% Write the watermarked host audio
audiowrite('watermarked_host_ssw.wav', hostSignal, hsr);
% Play the watermarked host audio
%disp('Playing watermarked host audio...');
%sound(hostSignal, hsr);
%pause(length(hostSignal)/hsr + 1);



% Watermark Extraction

% Extract the segment from the watermarked signal
extractedSegment = hostSignal(startIdx:endIdx);

% Perform DFT on the extracted segment
extractedSegmentDFT = fft(extractedSegment);

% Retrieve the embedded watermark by demodulating the frequency components
extractedWatermarkDFT = (extractedSegmentDFT ./ segmentDFT - 1) / spreadFactor;

% Perform inverse DFT to obtain the extracted watermark signal
extractedWatermarkSignal = real(ifft(extractedWatermarkDFT));

% Write the extracted watermarked audio from watermarked_host audio
audiowrite('extracted_watermark_ssw.wav', extractedWatermarkSignal, wmsr);

% Play the extracted watermark audio
%disp('Playing extracted watermark audio...');
%sound(extractedWatermarkSignal, wmsr);
%pause(length(extractedWatermarkSignal)/wmsr + 1);
