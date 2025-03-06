clc;
L1 = 0.08; %arm length
L2 = 0.08;
Lc1 = L1/2;  %mass center length
Lc2 = L2/2;
g = 9.81;
m1 = 0.004;  %mass of arm
m2 = 0.004;
m3 = 0.003;  %mass of led
m4 = 0.065;  %mass of motor2
F = 1;  %extra force
q1 = -30;   %angle of motor
q2 = -30;
a1 = (90 + q1) * pi / 180;
a2 = (q2 - 90) * pi / 180;
tor2 = m2 * g * Lc2 * cos(a1 + a2) + m3 * g * L2 * cos(a1 + a2) - F * L2 * cos(a1 + a2);  %torque 1 and 2
tor1 = tor2 + cos(a1) * (m1 * g * Lc1 + L1 * m2 * g) + m4 * g * L1 * cos(a1 + a2);

disp(['tor1: ', num2str(tor1), 'Nm']);
disp(['tor2: ', num2str(tor2), 'Nm']);