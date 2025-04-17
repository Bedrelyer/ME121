% Demo to extract frames and get frame means from a movie and save individual frames to separate image files.
% Then rebuilds a new movie by recalling the saved images from disk.
% Also computes the mean gray value of the color channels
% And detects the difference between a frame and the previous frame.
% Illustrates the use of the VideoReader and VideoWriter classes.
% A Mathworks demo (different than mine) is located here http://www.mathworks.com/help/matlab/examples/convert-between-image-sequences-and-video.html

clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 22;

movieFullFileName = 'rulerdamp.mp4'

try
    videoObject = VideoReader(movieFullFileName)
    % Determine how many frames there are.
    numberOfFrames = videoObject.NumberOfFrames;
    vidHeight = videoObject.Height;
    vidWidth = videoObject.Width;
    
    numberOfFramesWritten = 0;
    % Prepare a figure to show the images in the upper half of the screen.
    figure;
    % 	screenSize = get(0, 'ScreenSize');
    % Enlarge figure to full screen.
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
    
    % Ask user if they want to write the individual frames out to disk.
    promptMessage = sprintf('Do you want to save the individual frames out to individual disk files?');
    button = questdlg(promptMessage, 'Save individual frames?', 'Yes', 'No', 'Yes');
    if strcmp(button, 'Yes')
        writeToDisk = true;
        
        % Extract out the various parts of the filename.
        [folder, baseFileNameNoExt, extentions] = fileparts(movieFullFileName);
        % Make up a special new output subfolder for all the separate
        % movie frames that we're going to extract and save to disk.
        % (Don't worry - windows can handle forward slashes in the folder name.)
        folder = pwd;   % Make it a subfolder of the folder where this m-file lives.
        outputFolder = sprintf('%s/Movie Frames from %s', folder, baseFileNameNoExt);
        % Create the folder if it doesn't exist already.
        if ~exist(outputFolder, 'dir')
            mkdir(outputFolder);
        end
    else
        writeToDisk = false;
    end
    
    % Loop through the movie, writing all frames out.
    % Each frame will be in a separate file with unique name.

    for frame = 1 : numberOfFrames
        % Extract the frame from the movie structure.
        thisFrame = read(videoObject, frame);
        
        % Display it
        hImage = subplot(2, 2, 1);
        image(thisFrame);
        caption = sprintf('Frame %4d of %d.', frame, numberOfFrames);
        title(caption, 'FontSize', fontSize);
        drawnow; % Force it to refresh the window.
        
        % Write the image array to the output file, if requested.
        if writeToDisk
            % Construct an output image file name.
            outputBaseFileName = sprintf('Frame %4.4d.png', frame);
            outputFullFileName = fullfile(outputFolder, outputBaseFileName);
            
            % Stamp the name and frame number onto the image.
            % At this point it's just going into the overlay,
            % not actually getting written into the pixel values.
            text(5, 15, outputBaseFileName, 'FontSize', 20);
            
            % Extract the image with the text "burned into" it.
            frameWithText = getframe(gca);
            % frameWithText.cdata is the image with the text
            % actually written into the pixel values.
            % Write it out to disk.
            imwrite(frameWithText.cdata, outputFullFileName, 'png');
        end
        
        % Update user with the progress.  Display in the command window.
        if writeToDisk
            progressIndication = sprintf('Wrote frame %4d of %d.', frame, numberOfFrames);
        else
            progressIndication = sprintf('Processed frame %4d of %d.', frame, numberOfFrames);
        end
        disp(progressIndication);
        % Increment frame count (should eventually = numberOfFrames
        % unless an error happens).
        numberOfFramesWritten = numberOfFramesWritten + 1;
    end
    
    % Alert user that we're done.
    if writeToDisk
        finishedMessage = sprintf('Done!  It wrote %d frames to folder\n"%s"', numberOfFramesWritten, outputFolder);
    else
        finishedMessage = sprintf('Done!  It processed %d frames of\n"%s"', numberOfFramesWritten, movieFullFileName);
    end
    disp(finishedMessage); % Write to command window.
    uiwait(msgbox(finishedMessage)); % Also pop up a message box.
    
    % Exit if they didn't write any individual frames out to disk.
    if ~writeToDisk
        return;
    end

    msgbox('Done with this demo!');
    fprintf('Done with this demo!\n');
    
catch ME
    % Some error happened if you get here.
    strErrorMessage = sprintf('Error extracting movie frames from:\n\n%s\n\nError: %s\n\n)', movieFullFileName, ME.message);
    uiwait(msgbox(strErrorMessage));
end