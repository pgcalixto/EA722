%%% Pre-relatorio 5%%%
s = tf('s');

% Massa dos carros
mc1 = 0.778; % kg
mc2 = 0.582; % kg

% Massa total dos carros
m1 = mc1 + 4*0.500; % kg
m2 = mc2 + 4*0.500; % kg

% Coeficiente de atrito dos carros
c1 = 3.92; % N/(m/s)
c2 = 2.36; % N/(m/s)

% Constante de mola
k = 338.6; % N/m

% Ganho de hardware
khw = 14732;

% Constantes de ganho proporcional
kp1 = 1.0;
kp2 = 0.05;

% Constantes de ganho derivativa
kd1 = 0.03;
kd2 = 0.01;

% Controladores PD
Gc1 = kp1 + kd1*s;
Gc2 = kp2 + kd2*s;

% Termos de Numerador e Denominador
N1 = m2*s^2 + c2*s + k;
N2 = k;
D = (m1*m2)*s^4 + (c1*m2 + c2*m1)*s^3 + [(m1 + m2)*k + c1*c2]*s^2 + (c1 + c2)*k*s;

%%% Exercicio 1 %%%
% Calculo de funcao de transferencia
X1R_1 = minreal((khw*Gc1*N1)/(D + khw*Gc1*N1));
X2R_1 = minreal((X1R_1*N2)/N1);

X1R_2 = minreal((khw*Gc2*N1)/(D + khw*Gc2*N1));
X2R_2 = minreal((X1R_2*N2)/N1);

% Calculo de polos e zeros das funcoes de transferencia
[p1_1, z1_1] = pzmap(X1R_1);
[p2_1, z2_1] = pzmap(X2R_1);
[p1_2, z1_2] = pzmap(X1R_2);
[p2_2, z2_2] = pzmap(X2R_2);

% Obtencao da resposta ao degrau dos sistemas
[stepX1R_1, t1_1] = step(X1R_1, 2);
[stepX2R_1, t2_1] = step(X2R_1, 2);


figure, plot(t1_1, stepX1R_1, t2_1, stepX2R_1);
grid on;
title('PD1');
legend('x1', 'x2', 'Location', 'northeast');

[stepX1R_2, t1_2] = step(X1R_2, 2);
[stepX2R_2, t2_2] = step(X2R_2, 2);

figure, plot(t1_2, stepX1R_2, t2_2, stepX2R_2);
grid on;
title('PD2');
legend('x1', 'x2', 'Location', 'northeast');

%%% Exercicio 2 %%%
% Funcoes de transferencia de malha aberta
H_1 = (khw*Gc1*N1)/D;
H_2 = (khw*Gc2*N1)/D;
figure, bode(H_1, H_2);
grid on;
legend('PD1', 'PD2');

% Funcoes de transferencia de malha fechada
X1F_1 = N1/(D + N1*khw*Gc1);
X1F_2 = N1/(D + N1*khw*Gc2);
figure, bode(X1F_1, X1F_2);
grid on;
legend('PD1', 'PD2');
