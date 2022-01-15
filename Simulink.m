% Mass of cart (kg)
M = 2.4;
% Mass of sphere (kg)
m = 0.23;
% Gravity (m/s^2)
g = 9.81;
% Pole length (m)
l = 0.4;
A = [0 1 0 0;
    (M+m)*g/(M*l) 0 0 0;
     0 0 0 1;
    -m*g/M  0 0 0];
B = [0; 1/(M*l); 0; 1/M];
rank(ctrb(A,B))
Q = [1 0 0 0; 
    0 0 0 0; 
    0 0 10 0;
    0 0 0 100];
R = 1;
[K, S, CLP] = lqr(A, B, Q, R)

