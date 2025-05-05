%% Step 0: Set Excel file path
filename = 'data_fing.xlsx';  % <=== Replace with your actual Excel filename

% Sheets to process
sheets = {'sheet1', 'sheet2', 'sheet3', 'sheet4', 'sheet5'};

% Set the line width for plots
line_width = 0.5;

% Create color table (different color for each curve)
colors = lines(length(sheets));

% Create a figure
figure;
hold on;  % Allow multiple curves on the same plot

% Store natural frequencies for each dataset
all_naturalFreqs = cell(length(sheets), 1);

for i = 1:length(sheets)
    %% Step 1: Read data
    sheetName = sheets{i};
    data = readtable(filename, 'Sheet', sheetName);

    % Extract time and amplitude
    time = data{:,1};        % First column: time
    amplitude = data{:,2};   % Second column: amplitude

    % Remove DC offset
    amplitude = amplitude - mean(amplitude);

    %% Step 2: Calculate sampling rate
    dt = mean(diff(time));   % Time step
    Fs = 1/dt;               % Sampling frequency

    %% Step 3: Perform FFT
    N = length(amplitude);
    Y = fft(amplitude);
    f = (0:N-1)*(Fs/N);

    %% Step 4: Plot each frequency response curve
    plot(f(1:N/2), abs(Y(1:N/2)), 'DisplayName', sheetName, ...
         'LineWidth', line_width, 'Color', colors(i,:));

    %% Step 5: Find natural frequencies (peaks)
    [pks, locs] = findpeaks(abs(Y(1:N/2)), 'MinPeakProminence', 0.05);
    naturalFreqs = f(locs);
    all_naturalFreqs{i} = naturalFreqs;  % Save frequencies

    % Print first few natural frequencies
    fprintf('Natural Frequencies - %s: %.2f Hz, %.2f Hz, %.2f Hz\n', ...
        sheetName, naturalFreqs(1:min(3,end)));

    %% Step 6: Annotate the largest peaks
    % Find top 3 peaks
    [sortedPks, sortedIdx] = sort(pks, 'descend');
    topIdx = locs(sortedIdx(1:min(3,end))); % Top 3 peak locations

    for j = 1:length(topIdx)
        freq = f(topIdx(j));
        amp = abs(Y(topIdx(j)));

        % Annotate text
        text(freq, amp, sprintf('%.0f Hz', freq), ...
             'VerticalAlignment', 'bottom', ...
             'HorizontalAlignment', 'center', ...
             'FontSize', 10, ...
             'Color', colors(i,:), ...
             'FontWeight', 'bold');
    end
end

%% Step 7: Set up plot
hold off;
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency Response of Different Tapping Positions');
legend('show');
grid on;
xlim([0, 1000]);  % Adjust frequency axis if needed
set(gca, 'FontSize', 14);  % Optional: make axis labels larger
