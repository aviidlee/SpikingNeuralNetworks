% divide visual field into gridSize x gridSize grid.
% To make things nice, keep these as powers of 2, since DVS 128 x 128.
% Each neuron is sensitive to input in one grid cell. 
gridSize = 16;

% Find the boundaries of the grid
bounds = 1:(128/gridSize):128;

% grab some events. 
events = getEvents();
% Tranpose events. 
eventsT = events';

% Set up membrane potentials 
MP = zeros(gridSize);
% Set up thresholds; for now all their thresholds are the same 
THRESH = 20;
thresholds = ones(gridSize);
thresholds = thresholds*THRESH;
% What to add to membrane potential when event falls into visual field of 
% a particular neuron. 
ADD = 1;
% Decay constant. 
DECAY = 0.5;
% Resting potential.
RESTING = 0;
% Matrix for storing the index and time that a neuron fired.
% Need to extend it in the loop so initialise in the correct format with
% bogus data. 
firings = [-1, -1, -1];

% Hidden neuron 

for event = eventsT
    % find "x coordinate" of grid cell. 
    xRight = find(bounds >= event(1), 1);
    xRight = xRight-1;
    % find y coordinate of grid cell.
    yBottom = find(bounds >= event(2));
    yBottom = yBottom-1;
    % increase the mp of the appropriate neuron. 
    MP(yBottom, xRight) = MP(yBottom, xRight) + ADD;
    
    % Neurons leaks a little if it's above resting potential: 
    if MP(yBottom, xRight) > RESTING
        MP(yBottom, xRight) = MP(yBottom, xRight) - DECAY;
    end
    
    % Check if neuron fires. 
    if MP(yBottom, xRight) >= THRESHOLD
        MP(yBottom, xRight) = RESTING;
        % store the location of the neuron and the firing time. 
        firings = [firings; yBottom, xRight, event(4)]; %#ok<*AGROW>
    end 
    
    
    
end 

% Get rid of the bogus first firing. 
firings = firings(2, :);