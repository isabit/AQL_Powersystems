function [steadyP, steadyQ] = get_steady_PQ(typeid, statetable, transtable)
% Given a character id for a DER type alongside a table of states and
% transitions in the Markov chain for that type, returns steady state
% expectation P and Q for the given DER type

% Set up useful variables (for indexing)
stateindices = find(ismember(statetable.for_type, typeid));
ids = str2double(statetable.id(stateindices));
idstorownums = containers.Map(ids,1:length(ids));

% Construct infinitesimal stochastic matrix for the given DER type
% Assumes that input contains at most 1 transition from a given input
% to another with 0 transitions between an input to itself
ISmat = zeros(length(stateindices));
for col = 1:length(stateindices)
    for transindex = 1:height(transtable)
        if transtable.from_state{transindex} == statetable.id{stateindices(col)}
            row = idstorownums(str2double(transtable.to_state{transindex}));
            ISmat(row,col) = str2double(transtable.rate{transindex});
        end
    end
    ISmat(col,col) = -sum(ISmat(:,col));
end

% Compute steady state of the Markov chain
% dim Ker ISmat == 1 should be guaranteed by Perron-Frobenius
nullvec = null(ISmat);
% Check to make sure this is a single eigenvector
if size(nullvec, 2) ~= 1
    error('Dimension of kernel of infinitesimal stochastic matrix is not 1.');
end
% Check to make sure all entries have the same sign
% Passing the check implies that the sum of the entries is nonzero
% (since null won't return a zero vector)
if all(abs(nullvec) ~= nullvec) && all(abs(nullvec) ~= -nullvec)
    error('Steady state vector cannot be made positive.');
end
steadystate = nullvec / sum(nullvec);

% Calculate steady state <P> & <Q> and store values
Pvec = str2double(statetable.P(stateindices));
steadyP = dot(Pvec, steadystate);
Qvec = str2double(statetable.Q(stateindices));
steadyQ = dot(Qvec, steadystate);
end