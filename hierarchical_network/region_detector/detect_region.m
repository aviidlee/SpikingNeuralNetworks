% Simple test with one neuron.
% This is terribly, terribly inefficient. This is only an
% inertia-dissolver.
% 
% @param events - DVS events in the form [x; y; pol; t]
% @return firingTimes - row vector of DVS timestamps when neuron fired.
%         MP - row vector of membrane potentials at each timestamp.
% TODO
%     plot the firing times 
%     display firing together with dvs video
%     abstract out components so they can be changed and switched out.
function [firingTimes, MP] = detect_region(events)
    threshold = 10;
    resting = 0;
    mp = 0;
    increaseBy = 0.5;
    % Matrix of membrane potentials 
    MP = resting;

    % Choose a region of interest; for now, hard-coded to be some small
    % rectangle.
    xmin = 40;
    xmax = 60;
    ymin = 0;
    ymax = 40;
    
    % Store the firing times (in terms of dvs timestamp) of this neuron.
    firingTimes = [];

    % Loop through events
    for t = events
        % if something pops up in ROI, increase MP,
        % amount of MP increase depends on similarity to
        % what it was trained on.
        % events is otf [x; y; pol; t]
        if xmin < t(1) && xmax > t(1) && ymin < t(2) && ymax > t(2)
            mp = mp + increaseBy;
        end
        
        % Currently, no MP decay.
        % If MP > threshold, fire.
        if mp > threshold
            % Add the timestamp to firingTimes
            % Hard to preallocate firingTimes, what to do?
            firingTimes = [firingTimes, t(4)];
            % Reset MP 
            mp = resting;
        end
        
        MP = [MP, mp];
    end 
end 
