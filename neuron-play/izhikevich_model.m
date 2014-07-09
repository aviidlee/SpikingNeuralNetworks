% The neuron model used by Izhikevich in his 2003 paper
% "Which model to use for cortical spiking neurons?" 
% found at: http://www.izhikevich.org/publications/whichmod.htm#izhikevich
%
% Parameters: 
%     initialMP - the starting membrane potential (or rather, the membrane
%     potential now. The function simulates a single timestep. 
%     
%     inputCurrent - the current injected into this neuron.
%     
%     modelParams - the parameters for this model, in the format 
%     [a b c d].

function mp = izhikevich_model(initialMP, inputCurrent, modelParams)

    % Membrane potential
    v = initialMP;

    % Stuff to handle reset of membrane potential 
    u = -20;

    % Time step. Should really be passed in as param.
    tau = 0.2;

    I = inputCurrent;

    % Params in Izhikevich's model
    a = modelParams(1);
    b = modelParams(2);
    c = modelParams(3);
    d = modelParams(4);
    v = v+tau*(0.04*v^2+5*v+140-u+I);
    u = u+tau*a*(b*v-u);

    if v>30
           v=c;
           u=u+d;
           VU(1,1)=31;
    end;

    mp = v;
end