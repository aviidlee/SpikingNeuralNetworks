% Integrate and fire, as described in Izhikevich(2003)
% Uses fixed-step first-order Euler method: 
% x(t + tau) = x(t) + tau*f(x(t))
% 
%   Parameters 
%     initialMP - the starting membrane potential (or rather, the membrane
%     potential now. The function simulates a single timestep. 
%     
%     inputCurrent - the current injected into this neuron.
%   
%     modelParams - parameters for model in the format 
%     [a b c threshold tau] where c is resting potential
%      and tau is the timestep (used for euler method)
%   
%   Returns 
%     mp, the membrane potential for this time step.
    
function mp = integrate_fire(initialMP, inputCurrent, modelParams)
    v = initialMP;
    I = inputCurrent;

    a = modelParams(1);
    b = modelParams(2);
    c = modelParams(3);
    threshold = modelParams(4);
    tau = modelParams(5);
    
    v = v + tau*(I + a - b*v);
    
    if v >= threshold
        v = c;
    end
    
    mp = v;
end
        
    

