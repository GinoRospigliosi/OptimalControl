% SDPExample.m
% Simple stochastic dynamic programming example.
% Last edit: HKAF, 11.4.2012

clear all
close all
clc

% Begin by loading a time series representing power demand history as a
% function of time. 

load powerDemandHistory; 

% Plot the power demand history to see what it looks like

plot(1:1:1000,demandHistory); 
title('Power Demand Time Series - Raw Data');
xlabel('Time, hours');
ylabel('Power Demand, MW');

% Obtain and plot the power demand auto-correlation to see what it looks
% like

figure
autocorr(demandHistory,20);
title('Auto-Correlation for Power Demand History');
xlabel('Delay')
ylabel('Auto-Correlation')
grid

% Obtain and plot a zero-order Markov "histogram" as well as a zero-order 
% Markov "CDF" of the raw data
whiteHistogramCenterPoints = 0:1:3;
[whiteHistogram,whiteCDF] = zeroOrderMarkovFit(demandHistory,whiteHistogramCenterPoints);
figure
plot(whiteHistogramCenterPoints,whiteHistogram);
title('Histogram of Power Demand')
xlabel('Value of Power Demand')
ylabel('Discretized PDF')
figure
plot(whiteHistogramCenterPoints,whiteCDF);
title('CDF of Power Demand')
xlabel('Value of Power Demand')
ylabel('Discretized CDF')

% Perform "one step ahead" simulation of the zero-order Markov chain and
% compute the residual of this fit
[whiteNoiseFit,whiteNoiseResidual]=zeroOrderMarkovSim(demandHistory,whiteHistogramCenterPoints,whiteCDF);
figure
plot(1:1:1000,demandHistory,'r');
hold
plot(1:1:1000,whiteNoiseFit,'b');
title('Demand History: Simulation vs. Truth');
xlabel('Time');
ylabel('Power Demand History (red) and Zero-Order Markov Fit (blue)')
figure
plot(1:1:1000,whiteNoiseResidual);
title('Residual from Zero-Order Markov Fit');
xlabel('Time');
ylabel('Residual')

% Check to see if the residual of this Markov fit is truly "white"
figure
autocorr(whiteNoiseResidual,20);
title('Auto-Correlation for Zero-Order Markov Fit Residual');
xlabel('Delay')
ylabel('Auto-Correlation')

% Now try to fit a first-order Markov chain to this power demand history
[filteredMarkovTransitionTable,filteredMarkovCumulativeTransitionTable] = firstOrderMarkovFit(demandHistory,whiteHistogramCenterPoints);
figure
bar3(filteredMarkovTransitionTable);
figure
bar3(filteredMarkovCumulativeTransitionTable);

% Compute a one step-ahead simulation of the first-order Markov chain and
% plot both the fit and the residual
[filteredFirstOrderMarkovFit,filteredFirstOrderMarkovResidual]=firstOrderMarkovSim(demandHistory,whiteHistogramCenterPoints,filteredMarkovCumulativeTransitionTable);
figure
plot(1:1:1000,demandHistory,'r');
hold
plot(1:1:1000,filteredFirstOrderMarkovFit,'b');
title('Power Demand: First-Order Markov Simulation vs. Truth');
xlabel('Time');
ylabel('Power Demand (red) and First-Order Markov Fit (blue)')
figure
plot(1:1:1000,filteredFirstOrderMarkovResidual);
title('Residual from First-Order Markov Fit of Power Demand');
xlabel('Time');
ylabel('Residual')

% Finally, compute the auto-correlation and power spectral density of the
% residual and assess whether this residual is "white"
figure
autocorr(filteredFirstOrderMarkovResidual,20);
title('Auto-Correlation for Residual of First-Order Markov Fit of Power Demand');
xlabel('Delay')
ylabel('Auto-Correlation')

% Now construct the SDP problem tables and discount factor

discountFactor = 0.9;
[markovTransitionTables,transitionCostTables] = buildSDPTables(filteredMarkovTransitionTable');
figure
bar3(squeeze(markovTransitionTables(1,:,:)));
title('Markov Transition Probability Table, Control Input = 1');
figure
bar3(squeeze(markovTransitionTables(2,:,:)));
title('Markov Transition Probability Table, Control Input = 2');
figure
bar3(squeeze(markovTransitionTables(3,:,:)));
title('Markov Transition Probability Table, Control Input = 3');
figure
bar3(squeeze(transitionCostTables(1,:,:)));
title('Markov Transition Cost Table, Control Input = 1');
figure
bar3(squeeze(transitionCostTables(2,:,:)));
title('Markov Transition Cost Table, Control Input = 2');
figure
bar3(squeeze(transitionCostTables(3,:,:)));
title('Markov Transition Cost Table, Control Input = 1');

% Now finally perform SDP value/policy iteration! 

optimalPolicy = policyIteration(markovTransitionTables,transitionCostTables,3,24,discountFactor);
postProcess(optimalPolicy);