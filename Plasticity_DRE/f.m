function y = f(x,neuronType)
%activation function for neuron activation update, set to Tanh(x)or
%identity or any other invertible sigmoid you want

switch(neuronType)
    case 'sigmoid'
        y = sigmf(x,[1 0.5]);
    case 'relu'
        y = x;
        y(y < 0) = 0;
    case 'tanh'
        y = tanh(x);
    case 'linear'
        y = x;
    otherwise
        error(['Unknown Neuron Type' neuronType]);
end
