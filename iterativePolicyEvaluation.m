% iterativePolicyEvaluation.m
% Evalutes a given control policy using value iteration. 
% Output: valueFunction: value function for each state
% Inputs: 
%       markovTransitionTables: set of all Markov transition tables, for
%       all control inputs
%       markovTransitionCosts: set of all transition costs, for all values
%       of the control input
%       nInputs: number of inputs
%       nStates: number of states
%       controlPolicy = control policy, i.e., choice of control input for
%       each state
%       discountFactor: discount factor
%       tolerance: tolerance for evaluating value function, L2 %
%       initialEstimate: initial estimate of value function
% Last edit: HKAF, 11.3.2012

function valueFunction = iterativePolicyEvaluation(markovTransitionTables, markovTransitionCosts,nInputs,nStates,controlPolicy,discountFactor,tolerance,initialEstimate)

% Begin by setting initial estimate for value function

valueFunction = initialEstimate; 
newValueFunction = valueFunction;

% Next, construct the overall Markov transition probability table, and
% overall Markov transition cost table

overallMarkovTransitionTable = zeros(nStates,nStates);
overallMarkovTransitionCostTable = zeros(nStates,nStates);

for stateIndex = 1:nStates
    controlIndex = controlPolicy(stateIndex);
    overallMarkovTransitionTable(:,stateIndex) = squeeze(markovTransitionTables(controlIndex,:,stateIndex));
    overallMarkovTransitionCostTable(:,stateIndex) = squeeze(markovTransitionCosts(controlIndex,:,stateIndex));
end;

% Next, perform value iteration

valueError = 10*tolerance;

while valueError > tolerance
    for k = 1:nStates
        newValueFunction(k) = 0;
        for i = 1:nStates
            newValueFunction(k) = newValueFunction(k) + discountFactor*overallMarkovTransitionTable(i,k)*(valueFunction(i)+overallMarkovTransitionCostTable(i,k));
        end;
    end; 
    valueError = (sqrt(sum((newValueFunction-valueFunction).^2))/sqrt(sum(valueFunction.^2)))*100;
    valueFunction = newValueFunction;
end; 