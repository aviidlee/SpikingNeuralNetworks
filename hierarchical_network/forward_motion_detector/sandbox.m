function [mpHist, hiddenHist] = sandbox(events)
    % divide visual field into gridSize x gridSize grid.
    % To make things nice, keep these as powers of 2, since DVS 128 x 128.
    % Each neuron is sensitive to input in one grid cell.
    gridSize = 16;

    % Find the boundaries of the grid
    bounds = 1:(128/gridSize):129;
    
    if(nargin == 0)
        % grab some events.
        events = getEvents();
    end
    
    % Tranpose events.
    eventsT = events';
    [numEvents throwOut] = size(events);

    % Set up membrane potentials
    MP = zeros(gridSize);
    % The last time a neuron saw an input.
    lastInput = zeros(gridSize);
    % Weights from input neurons to hidden neuron
    W = randn(gridSize);
    wInit = [W];
    % Little bit to add/take from weight if neurons fire close in time.
    wCONST = 0.01;
    % How much in time to look backwards for STDP
    tBACK = 500;
    tFORWARD = 500;
    % Cap weight 
    maxW = 1;
    minW = -1;
    
    % Set up thresholds; for now all their thresholds are the same
    THRESHOLD = 20;
    thresholds = ones(gridSize);
    thresholds = thresholds*THRESHOLD;
    % What to add to membrane potential when event falls into visual field of
    % a particular neuron.
    ADD = 5;
    % Decay constant.
    DECAY = 0.05;
    % Resting potential.
    RESTING = 0;
    SPIKE = 1;
    % Matrix for storing the index and time that a neuron fired.
    % Need to extend it in the loop so initialise in the correct format with
    % bogus data.
    firings = [-1, -1, -1];
    % History of membrane potential updates, itf 
    % [rowIndex, colIndex, timestamp, mp]
    mpHist = zeros(numEvents, 4);
    
    % Hidden neuron which learns by STDP; initially starts out being connected
    % to all neurons then prunes them. Start with one neuron.
    hiddenFirings = 0;
    % Need conduction delays?
    hiddenThresh = 2;
    hiddenDecay = 0.01;
    hiddenResting = 0;
    hiddenMP = hiddenResting;
    hiddenFirings = -1;
    % the last time at which the hidden neuron received a spike
    hiddenInput = 0;
    % Membrane potential history of hidden neuron
    % itf [timestamp, mp]
    hiddenHist = zeros(numEvents, 2);
    
    eventNo = 1;
    for event = eventsT
        % Minor ickiness due to DVS pixel locations being zero-based and 
        % Matlab indices starting at 1. 
        
        % find "x coordinate" of grid cell.
        xRight = find(bounds > event(1)+1, 1);
        xRight = xRight-1;
        
        % find y coordinate of grid cell.
        yBottom = find(bounds > event(2)+1, 1);
        yBottom = yBottom-1;
        
        if xRight == 0
            disp('xRight was zero')
            disp(event(1))
        end 
        if yBottom == 0
            disp('yBottom was zero')
            disp(event(2))
        end 
        timeNow = double(event(4));

        % Neurons leak a little if it's above resting potential
        if MP(yBottom, xRight) > RESTING
            % Check how much time has passed between the last input and
            % current time, decay appropriately.
            decay = (timeNow - lastInput(yBottom, xRight))*DECAY;
            MP(yBottom, xRight) = max(RESTING, MP(yBottom, xRight) - decay);
        end
        
        % Leak hidden neuron.
%         if hiddenMP > hiddenResting
%             % Check how much time has passed between the last input and
%             % current time, decay appropriately.
%             decay = (timeNow - hiddenInput)*hiddenDecay;
%             hiddenMP = max(hiddenResting, hiddenMP - decay);
%         end

        % Update the last time the neuron saw an input.
        lastInput(yBottom, xRight) = timeNow;

        % Now input and hidden neurons are up to date to just before the latest event.

        % increase the mp of the appropriate neuron.
        MP(yBottom, xRight) = MP(yBottom, xRight) + ADD;
        % add to history of membrane potentials. 
        mpHist(eventNo, :) = [yBottom, xRight, event(4), MP(yBottom, xRight)];
        % Check if neuron fires.
        if MP(yBottom, xRight) >= THRESHOLD
            MP(yBottom, xRight) = RESTING;
            % store the location of the neuron and the firing time.
            firings = [firings; yBottom, xRight, event(4)]; %#ok<*AGROW>
            % update hidden neuron
            hiddenMP = hiddenMP + SPIKE;
            
            % Check if the hidden neuron fired in the recent past
            if hiddenFirings(end) >= timeNow - tBACK
                W(yBottom, xRight) = max(minW, W(yBottom, xRight) - wCONST);
            end
%             ind = find(hiddenFirings >= (timeNow - tBACK));
%             timeNow-tBack
%             if ~isempty(ind)
%                 disp('Something fired recently');
%                 % Adjust the weight of connection from this input neuron to the
%                 % hidden neuron down.
%                 W(yBottom, xRight) = W(yBottom, xRight) - wCONST;
%             end
        end
        
        % It is now forever recorded in history.
        hiddenHist(eventNo, :) = [event(4), hiddenMP];

        % Check if hidden neuron fires
        if hiddenMP >= hiddenThresh
            % disp('Hidden neuron fired');
            hiddenMP = hiddenResting;
            hiddenFirings = [hiddenFirings; event(4)];
            % Update weights; which neurons caused the hidden one to fire?
            [r c] = find(firings(:,3) > (timeNow - tFORWARD));
            if ~isempty(r)
                for i = size(r)
                    % Get the yBottom and xRight (indices) out.
                    row = firings(r(i), 1);
                    col = firings(r(i), 2);
                    % Update weight.
                    W(row, col) = max(maxW, W(row, col) + wCONST);
                end
            end
        end
        
        % For index into membrane potential history matrix. 
        eventNo = eventNo + 1;

    end

    % Get rid of the bogus first firings.
    [r c] = size(firings);
    if r > 1
       firings = firings(2, :);
    else 
        disp('Input neurons never fired!');
    end 
    
    [r c] = size(hiddenFirings);
    if r > 1
        hiddenFirings = hiddenFirings(2:end, :);
    else 
        disp('Hidden neurons never fired!');
    end 
    
    disp('Weight changes: W - wInit');
    weightChange = W - wInit
    imshow(W);
    
end