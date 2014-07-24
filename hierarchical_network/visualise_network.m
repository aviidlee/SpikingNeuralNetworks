% GUI for displaying DVS image side-by-side with neural network activity,
% and for modifying network parameters dynamically. 
% 
% @param events - the DVS events itf [x, y, pol, timestamp]
% @param speed - the number of seconds to pause on each iteration of the 
%                loop so that it doesn't go too fast. 
%
% What is current does: 
%     It can't do any param adjustments dynamically because neural activity
%     is pre-generated with all the dvs data then displayed. 
%     
%       Displays Rob's DVS video and a neuron's membrane potential side-by-side.
%       Currently it's too fast to see anything 
%       
%   TODO 
%       Make play speed adjustable.
% What it should eventually do: 
%     Show a video of the DVS images.
%     Show a graph or some sort of visualisation of the neurons in the network
%     which change colour when they fire.
%     Allow user to change parameters of network dynamically.
%     Show the membrane potential trace or other activity of some representative
%     neuron.
% 
% Credit:
%     Cobbling by Alex Lee.
%     Some code may have been taken from Izhikevich (2003) Which neuron model
%     Some code may have been taken from Robert Quinn's DVS work, in particular
%     displayingdata.m
function visualise_network(events, speed, HMP)
    if nargin == 0, % no events matrix provided
        % Load DVS events into matrix otf [x, y, pol, t]
        events = getEvents();
    end
    
    % only events provided
    if nargin == 1
        speed = 0.01;
    end 
    
    % The amount of time between each frame? Hard-coded to 10000 microseconds
    % in Rob's original code.
    FRAMETIME = 10000;
    
    % --- Set up for DVS video -----------------------------------------------
    %get dimensions of events matrix
    [xsize, ysize] = size(events);
    %set figure properties
    video = figure('color','white');
    % set(video, 'Name', 'Visualise Network', 'Units','normalized', ...
    %    'Position', [0.05, 0.45, 0.5, 0.5]); 
    %find out the starting timestamp (in microseconds)
    plottime = events(1,4)

    %set entire events matrix to int32
    % Not sure why this is necessary.
    events = int32(events);

    %set figure to grayscale
    colormap(gray)
    dvs = subplot(2, 2, 1);
    % set(background, 'Units', 'normalized', 'Position', [0.05 0.45 0.5 0.5]);
    axis equal
    
    %---- Set up for neuron firing plot --------------------------------------
    neuron = subplot(2, 2, 3);
    % set(neuron, 'Position', [0.05 0.1 0.4 0.4]);
    % Get the membrane potentials of Input and hidden neurons 
    if nargin < 3
        [IMP, HMP] = sandbox(events);
    end 
    % Line for plotting membrane potential 
    vtrace=line('color','k','LineStyle','-','erase','background', ...
        'xdata',[],'ydata',[],'zdata',[]);
    title('membrane potential, v')
    xlabel('timestamp');
    MP = HMP(:,2);
    % Maximum membrane potential, for setting axes.
    maxMP = max(MP);
    minMP = min(MP);
    minTime = 0;
    maxTime = FRAMETIME;
    axis([minTime maxTime minMP maxMP]);
    
    % Gaussian blur filter; default sigma is 0.5
    gfilter = fspecial('gaussian', 128);
    
    for j = 1:xsize
        % Break data into FRAMETIME microsecond blocks
        ind = find(events(:,4) >= plottime & events(:,4)<=plottime+FRAMETIME);
        
        % Update "current time"
        plottime = plottime + FRAMETIME;
        
        % Switch to the correct subplot...
        subplot(2, 2, 1);
        %set up the background for the matrix to display
        background = zeros(128,128);

       %for each set of FRAMETIME microsecond blocks of data, adjust the zeros
       %matrix to account for the changed events in that time block (-1 or 1)
       %and finally adjust to values between 0 and 255 (grayscale values)
       for k = ind(1,1):ind(size(ind),1)
           background(events(k,2)+1, events(k,1)+1) = events(k,3);
       end
      
        %end
        %set the size of the image
        xlim([0, 128])
        ylim([0, 128])

        %flip the images the correct way around again
        background = flipud(background);
        %actually display the images at the speed of the for loop
        imagesc(background);
        
        %=========== Plot neuron ========================
        subplot(2, 2, 3);
        % times = events(ind, 4);
        times = 1:size(ind);
        plot(times, MP(ind));
        
        % set(vtrace, 'xdata', times, 'ydata', MP(ind));
        % set up the escape root for the for loop (I need to change this)
        if plottime > events(xsize,4)
            break;
        end
        
        % ========= Plot blurred ================
        
        %display the stuff in real time (not sure if necessary yet)
        drawnow;
        pause(speed);
    end
end