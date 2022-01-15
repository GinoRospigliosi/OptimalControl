% policyIteration.m
% Optimizes the control policy in a stochastic dynamic programming problem
% using the policy iteration approach. 
% Output: optimalPolicy: optimal control input as a function of state
% Inputs: 
%       markovTransitionTables: set of all Markov transition tables, for
%       all control inputs
%       markovTransitionCosts: set of all transition costs, for all values
%       of the control input
%       nInputs: number of inputs
%       nStates: number of states
%       discountFactor: discount factor
% Last edit: HKAF, 11.4.2012

function optimalPolicy = policyIteration(markovTransitionTables,markovTransitionCosts,nInputs,nStates,discountFactor)

% Begin by choosing an arbitrary control policy

currentPolicy = ones(nStates,1);
previousPolicy = currentPolicy;

% Next, choose an arbitary initial guesstimate for the value function

valueFunction = zeros(nStates,1);

% Next, perform the policy iteration as follows: for every control policy,
% calculate the value function using value iteration. Then, keeping that
% value function FIXED, go through the set of states, go through the set of
% control inputs for each state, and use Bellman's equation to calculate
% a new value function for each state-control combination. Find the
% cheapest control input for each state. This is now your new control
% policy. If your new control policy is identical to the previous policy,
% then you're done. You make this convergence decision based on a
% "policy error": the difference between the two policies. This policy
% error needs to be set to an arbitrarily large number before you start the
% optimization loop. 

policyError = 10;       % Difference in control actions between two consecutively optimized control policies

while policyError > 0.5     % Need policy error to eventually hit zero 
    valueFunction = iterativePolicyEvaluation(markovTransitionTables, markovTransitionCosts,nInputs,nStates,currentPolicy,discountFactor,0.1,valueFunction);
    bestValueFunction = valueFunction; 
    for currentStateIndex = 1:nStates
        for controlIndex = 1:nInputs
            currentValueFunction = 0;
            for nextStateIndex = 1:nStates
                currentValueFunction = currentValueFunction + discountFactor*markovTransitionTables(controlIndex,nextStateIndex,currentStateIndex)*(valueFunction(nextStateIndex)+markovTransitionCosts(controlIndex,nextStateIndex,currentStateIndex));
            end;
            if currentValueFunction < bestValueFunction(currentStateIndex)
                bestValueFunction(currentStateIndex) = currentValueFunction;
                currentPolicy(currentStateIndex) = controlIndex;
            end;
        end;
    end;
    policyError = sum(abs(currentPolicy-previousPolicy));
    previousPolicy = currentPolicy;
end; 

optimalPolicy = currentPolicy;