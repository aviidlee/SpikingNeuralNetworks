% Simple test with one neuron.
% This is terribly, terribly inefficient. This is only an
% inertia-dissolver.
% 
% TODO
%     plot the firing times 
%     display firing together with dvs video
%     abstract out components so they can be changed and switched out.

threshold = 10;
resting = 0;
mp = 0;
increaseBy = 0.5;

% Choose a region of interest; for now, hard-coded to be some small
% rectangle.
xmin = 40;
xmax = 60;
ymin = 0;
ymax = 40;

% Transpose events so that an event is a column.
eventT = events';

% Loop through events
for t = eventT
    % if something pops up in ROI, increase MP,
    % amount of MP increase depends on similarity to
    % what it was trained on.
    if xmin < t(1) && xmax > t(1) && ymin < t(2) && ymax > t(2)
        mp = mp + increaseBy;
    end
    % Currently, no MP decay.
    % If MP > threshold, fire.
    if mp > threshold
        disp('Firing!')
        % Reset MP 
        mp = resting;
    end
    
end 
