function xoverKids  = crossovertwobits(parents,options,GenomeLength,~,~,thisPopulation)
%CROSSOVERTWOBITS Two bits crossover function.

% How many children to produce?
nKids = length(parents)/2;
% Extract information about linear constraints, if any
linCon = options.LinearConstr;
constr = ~isequal(linCon.type,'unconstrained');
% Allocate space for the kids
xoverKids = zeros(nKids,GenomeLength);

% To move through the parents twice as fast as thekids are
% being produced, a separate index for the parents is needed
index = 1;

% for each kid...
for i=1:nKids
    % get parents
    r1 = parents(index);
    index = index + 1;
    r2 = parents(index);
    index = index + 1;
    % Randomly select half of the genes from each parent
    % This loop may seem like brute force, but it is twice as fast as the
    % vectorized version, because it does no allocation.
    for j = 1:(GenomeLength/2)
        if(rand > 0.5)
            xoverKids(i,((j-1)*2+1):(2*j)) = thisPopulation(r1,((j-1)*2+1):(2*j));
        else
            xoverKids(i,((j-1)*2+1):(2*j)) = thisPopulation(r2,((j-1)*2+1):(2*j));
        end
    end
    % Make sure that offspring are feasible w.r.t. linear constraints
    if constr
        feasible = isTrialFeasible(xoverKids(i,:)',linCon.Aineq,linCon.bineq,linCon.Aeq, ...
                            linCon.beq,linCon.lb,linCon.ub,options.TolCon);
        if ~feasible % Kid is not feasible
            % Children are arithmetic mean of two parents (feasible w.r.t
            % linear constraints)
            alpha = rand;
            xoverKids(i,:) = alpha*thisPopulation(r1,:) + ...
                (1-alpha)*thisPopulation(r2,:);
        end
    end

end