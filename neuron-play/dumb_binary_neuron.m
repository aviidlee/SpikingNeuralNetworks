% A test more than anything else, spikes if the input is greater than 
% a threshold value and does not reset (so essentially mimics the input 
% current.

function mp = dumb_binary_neuron(membranePotential, inputCurrent, modelParams)
    THRESHOLD = modelParams(1);
    if inputCurrent > THRESHOLD
        v = 1;
    else
        v = 0;
    end
    
    mp = v;
end
