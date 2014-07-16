% Neuron simulation sandbox. Some code copied/modified from 
% Izhikevich.m
% 
% Parameters
%   model - the neuron model to use. If the specified model does not
%   exist, default is Izhikevich's 2003 model.
%   
%   modelParams - a matrix of the parameters used by the model.
%     this is just passed straight to the model so the model is responsible
%     for checking the parameters make sense etc. Model may or may not
%     throw a fit and die.
%
% Current issues: 
%   Trying to set up something neat to handle the UI but 
%   hard to call different neuron models with lots of different 
%   params, guess some sort of parameter matrix is needed.
%
% Future extensions:
%   Plot multiple membrane potentials from different models on same plot.
%   Add UI controls to dynamically change input current and model params

function neuron_handle(model, modelParams)
    quit = 0;

    % The model we are currently using 

    % Starting value of membrane potential
    DEFAULT_MP = -65; 

    % Current membrane potential 
    mp = DEFAULT_MP;

    % Default input current 
    DEFAULT_INPUT = 10;

    % The current input current
    input = DEFAULT_INPUT;

    % the time increment (so we have graph displaying in ms instead of 
    % in integer intervals. 
    tau = 0.2;

    % Number of time steps we will store.
    L = 500;

    % matrix to store membrane potentials
    MP = [mp]*ones(1,L);

    % Set up UI stuff here ----------------------------------------------------
    figNumber = figure(1);
    %clear current figure window
    clf;
    set(figNumber,'NumberTitle','off','doublebuffer','on',...
            'Name','Neuron sandbox',...
            'Units','normalized','toolbar','figure',...
            'Position',[0.05 0.1 0.9 0.8]);
    h1=subplot(4,2,1);
    set(h1,'Position',[0.05 0.75 0.27 0.2])

    % Membrane potential trace
    vtrace=line('color','k','LineStyle','-','erase','background','xdata',[],'ydata',[],'zdata',[]);
    axis([0 100 -100 30])
    title('membrane potential, v')
    xlabel('time (ms)');

    % time, for the sake of periodic inputs
    time = 0;

    while quit == 0
        input = cos(time*tau*0.05);
        time = time + 1;
        if(time > 100)
            time = 0;
        end
        

        % Use appropriate model to get membrane potential
        switch model
            case 'izhikevich'
               mp = izhikevich_model(MP(1,1), input, modelParams);
            case 'dumb_binary'
               mp = dumb_binary_neuron(MP(1,1), input, modelParams);
            case 'integrate_fire'
               mp = integrate_fire(MP(1,1), input, modelParams);
            otherwise
               mp = izhikevich_model(MP(1,1), input, modelParams);
        end
        
        % Put the latest potential in our history of membrane potentials
        MP = [mp, MP(1, 1:L-1)];
        
        % check if mp will fit
        
        % Draw the potential!!
        
        set(vtrace,'xdata',tau*(L:-1:1),'ydata',MP(1,:));
        drawnow;
    end
end
    
