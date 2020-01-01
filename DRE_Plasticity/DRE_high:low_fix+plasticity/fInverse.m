function y=fInverse(x,neuronType)
%inverse of the activation function f: Arctanh(x) or identity or
%custom-made according to your chosen f
% y = x;

switch(neuronType)
    case 'sigmoid'
        y = 1/1*(log(x)-log(1-x))+0.5;
    case 'relu'
        y = x;
        y(y < 0) = 0;
    case 'tanh'
        y=atanh(x);
    case 'linear'
        y = x;
    otherwise
        error(['Unknown Neuron Type' neuronType]);
end