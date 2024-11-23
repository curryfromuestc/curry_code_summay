%% Two HH Neurons Coupled via Gap Junctions
% Based on Basic Hodgkin-Huxley Implementation
clc;
clear all;

dt = 0.02;
t = 0:dt:200;

% Nernst Potentials
Ena = 115;
Ek = -12;
El = 10;

% Maximum Conductances
gna = 120;
gk = 36;
gl = 0.3;

% Membrane Capacitance
C = 1;

% Rate Functions
an = @(u) (0.1-0.01*u)/(exp(1-0.1*u)-1);
am = @(u) (2.5-0.1*u)/(exp(2.5-0.1*u)-1);
ah = @(u) 0.07*exp(-u/20);

bn = @(u) 0.125*exp(-u/80);
bm = @(u) 4*exp(-u/18);
bh = @(u) 1/(exp(3-0.1*u)+1);

% INITIALIZE STATE VARIABLES FOR NEURON 1
m1 = zeros(1,length(t));
n1 = zeros(1,length(t));
h1 = zeros(1,length(t));
v1 = -65*ones(1,length(t));

% INITIALIZE STATE VARIABLES FOR NEURON 2
m2 = zeros(1,length(t));
n2 = zeros(1,length(t));
h2 = zeros(1,length(t));
v2 = -65*ones(1,length(t));

% DEFINE STIMULUS FOR NEURON 1
tSTIM_START = 5;
tSTIM_DUR = 1;
STIM_STRENGTH = 10;

% DEFINE GAP JUNCTION CONDUCTANCE
g_gap = 0.1; % Adjust coupling strength as needed

% DEFINE MISC
inRange = @(x,a,b) (x>=a) & (x<b);

% MAIN LOOP
for i = 1:length(t)-1
    % Neuron 1
    u1 = v1(i);
    % Ionic Currents for Neuron 1
    Ik1 = gk * n1(i)^4 * (u1 - Ek);
    Ina1 = gna * m1(i)^3 * h1(i) * (u1 - Ena);
    Il1 = gl * (u1 - El);
    Imem1 = Ik1 + Ina1 + Il1;
    
    % Stimulus Current for Neuron 1
    % 输入是一个 sin 函数
    Istim1 = STIM_STRENGTH * sin(2 * pi * 0.05 * t(i));
    if inRange( t(i) , tSTIM_START , tSTIM_START+tSTIM_DUR)
        Istim1 = STIM_STRENGTH;
    end
    
    % Neuron 2
    u2 = v2(i);
    % Ionic Currents for Neuron 2
    Ik2 = gk * n2(i)^4 * (u2 - Ek);
    Ina2 = gna * m2(i)^3 * h2(i) * (u2 - Ena);
    Il2 = gl * (u2 - El);
    Imem2 = Ik2 + Ina2 + Il2;
    
    % Stimulus Current for Neuron 2 (no external stimulus)
    Istim2 = 0;
    
    % Coupling Current
    Icouple1 = g_gap * (u2 - u1);
    Icouple2 = g_gap * (u1 - u2);
    
    % State Variable Derivatives for Neuron 1
    dv1 = (Istim1 - Imem1 + Icouple1) / C;
    dm1 = am(u1)*(1 - m1(i)) - bm(u1)*m1(i);
    dh1 = ah(u1)*(1 - h1(i)) - bh(u1)*h1(i);
    dn1 = an(u1)*(1 - n1(i)) - bn(u1)*n1(i);
    
    % State Variable Derivatives for Neuron 2
    dv2 = (Istim2 - Imem2 + Icouple2) / C;
    dm2 = am(u2)*(1 - m2(i)) - bm(u2)*m2(i);
    dh2 = ah(u2)*(1 - h2(i)) - bh(u2)*h2(i);
    dn2 = an(u2)*(1 - n2(i)) - bn(u2)*n2(i);
    
    % Update State Variables using Forward Euler Method
    v1(i+1) = v1(i) + dv1 * dt;
    m1(i+1) = m1(i) + dm1 * dt;
    h1(i+1) = h1(i) + dh1 * dt;
    n1(i+1) = n1(i) + dn1 * dt;
    
    v2(i+1) = v2(i) + dv2 * dt;
    m2(i+1) = m2(i) + dm2 * dt;
    h2(i+1) = h2(i) + dh2 * dt;
    n2(i+1) = n2(i) + dn2 * dt;
end
Kp = 5;
Tmax = 1;
T = Tmax./(1+exp(-(v1-60)/Kp));

% Plot the results
figure;
subplot(2,1,1);
plot(t, v1 - 65, 'b');
xlabel('Time (ms)');
ylabel('V_1 (mV)');
title('Neuron 1 Membrane Potential');

subplot(2,1,2);
plot(t, v2 - 65, 'r');
xlabel('Time (ms)');
ylabel('V_2 (mV)');
title('Neuron 2 Membrane Potential');

subplot(2,1,1);
plot(t, T, 'b');
xlabel('Time (ms)');
ylabel('T (ms)');
title('Neuron 1 Membrane Potential');