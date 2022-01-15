% policyEvaluationExample.m
% Iterative policy evaluation example. 
% Last edit: HKAF, 11.3.2012

clear all
close all
clc

markovTransitionTables = zeros(2,2,2);
markovTransitionTables(1,:,:) = [0.9 0.3;0.1 0.7];
markovTransitionTables(2,:,:) = [0.1 0.1; 0.9 0.9];

markovTransitionCosts = zeros(2,2,2);
markovTransitionCosts(1,:,:) = [700 1700;400 1000];
markovTransitionCosts(2,:,:) = [700 1700;400 1000];

nInputs = 2;
nStates = 2;

controlPolicy = [1;2];

discountFactor = 0.9;

tolerance = 0.1;

initialEstimate = [0;0];

valueFunction = iterativePolicyEvaluation(markovTransitionTables, markovTransitionCosts,nInputs,nStates,controlPolicy,discountFactor,tolerance,initialEstimate);

