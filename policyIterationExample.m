% policyIterationExample.m
% Iterative policy improvement example. 
% Last edit: HKAF, 11.4.2012

clear all
close all
clc

markovTransitionTables = zeros(2,2,2);
markovTransitionTables(1,:,:) = [0.9 0.9;0.1 0.1];
markovTransitionTables(2,:,:) = [0.1 0.1; 0.9 0.9];

markovTransitionCosts = zeros(2,2,2);
markovTransitionCosts(1,:,:) = [1000 300;800 200];
markovTransitionCosts(2,:,:) = [1000 300;800 200];

nInputs = 2;
nStates = 2;

discountFactor = 0.9;

optimalPolicy = policyIteration(markovTransitionTables,markovTransitionCosts,nInputs,nStates,discountFactor);

