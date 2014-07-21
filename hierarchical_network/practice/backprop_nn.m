% Toy backprop code, adapted from Python implementation in 
% http://arctrix.com/nas/python/bpnn.py
% Yes we are learning XOR. Sigh.

% Made a mistake somewhere, the darn thing doesn't seem to learn!

pattern = [0, 0, 0;
    0, 1, 1;
    1, 0, 1;
    1, 1, 0];

patternT = pattern';

% number of iterations 
it = 1000;
% learning factor
n = 0.5;
% momentum factor?!
m = 0.1;

% number of inputs; 2 for actual input, 1 for bias
ni = 3;
no = 1;
% num hidden
nh = 2;
% activation
ai = ones(1, ni);
ah = ones(1, nh);
ao = ones(1, no);

% weights
wi = rand(ni, nh);
wo = rand(nh, no);

% change in weights for momentum...?
ci = rand(ni, nh);
co = rand(nh, no);

for i = 1:it
    error = 0.0;
    for p = patternT
        inputs = p(1:2);
        targets = p(3);
        
        %---- Update neural network.
        
        % Input.
        % Recall we reserved one input for bias term.
        for j = 1:ni-1
            ai(1) = inputs(1);
        
        end
        
        % hidden activations 
        % for each hidden neuron
        for t = 1:nh
            % sum all the inputs from its input neurons.
            sum = 0;
            % This is a dumb way, very slow. Use matrix ops instead!
            for s = 1:ni
                sum = sum + ai(s)*wi(s, t);
            end
            ah(t) = tanh(sum);
        end 
        
        % output activations 
        for k = 1:no
            sum = 0;
            for l = 1:nh
                sum = sum + ah(l)*wo(l, k);
            end
            % tanh is our sigmoid.
            ao(k) = tanh(sum);
        end
        
        %---- Find errors
        % errors for output 
        error = targets - ao;
        outputDeltas = (1 - ao.^2).*error;
        
        % errors for hidden
        hiddenDeltas = ones(1, nh);
        for u = 1:nh
            error = 0;
            for v = 1:no
                error = error + outputDeltas(v)*wo(u,v);
            end 
            hiddenDeltas(u) = (1-ah(u)^2)*error;
        end
        
        % update output weights 
        for j = 1:nh
            for k = 1:no
                change = outputDeltas(k)*ah(j);
                wo(j, k) = wo(j, k) + n*change + m*co(j, k);
                co(j, k) = change;
            end
        end
        
        for j = 1:ni
            for k = 1:nh
                change = hiddenDeltas(k)*ai(j);
                wi(j, k) = wi(j, k) + n*change + m*ci(j, k);
                ci(j, k) = change;
            end
        end
        
        % print error 
        disp(targets-ao)
    end
    
end
        
        
