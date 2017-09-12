
% QUESTAO 3
% ITEM a

% parametros iniciais
s = tf('s');

mc1 = 0.778;
mw1 = 4*0.500;
m1 = mc1 + mw1;

c1 = 2.94;
kv = 0.005;
khw = 14732;

k1 = 338.6;
deltak1 = 361.4;

% Gps eh a funcao de transferencia da "planta compensada" para o problema servo
% GpsDelta eh Gps*, a funcao de transferencia para o valor perturbado
Gps = khw / (m1*s^2 + (c1+khw*kv)*s + k1);
GpsDelta = khw / (m1*s^2 + (c1+khw*kv)*s + (k1 + deltak1));

display(tf(Gps));
display(tf(GpsDelta));

% ganhos de baixa frequencia
Gps0 = dcgain(Gps);
Gps0Delta = dcgain(GpsDelta);

display(Gps0);
display(Gps0Delta);

% ITEM b
Gpr = 1 / (m1*s^2 + (c1+khw*kv)*s + k1);
GprDelta = 1 / (m1*s^2 + (c1+khw*kv)*s + (k1 + deltak1));

display(tf(Gpr));
display(tf(GprDelta));

Gpr0 = dcgain(Gpr);
Gpr0Delta = dcgain(GprDelta);

display(Gpr0);
display(Gpr0Delta);

% ITEM c
display(Gps0Delta - Gps0);
display(Gpr0Delta - Gpr0);

% ITEM d
Gpf = 1;
kp = 0.12;

Ga = Gpf * Gps;
GaDelta = Gpf * GpsDelta;

Gf = Gpf * feedback(Gps * kp, 1);
GfDelta = Gpf * feedback(GpsDelta * kp, 1);

display(tf(Ga));
display(tf(GaDelta));
display(tf(Gf));
display(tf(GfDelta));

% ITEM e
Ea = (1 - Ga);
EaDelta = (1 - GaDelta);
Ef = (1 - Gf);
EfDelta = (1 - GfDelta);

eRegA = dcgain(Ea);
eRegADelta = dcgain(EaDelta);
eRegF = dcgain(Ef);
eRegFDelta = dcgain(EfDelta);

display(eRegA);
display(eRegADelta);
display(eRegF);
display(eRegFDelta);

% ITEM f
[stepGa, tA] = step(Ga, 1.2);
[stepGaDelta, tADelta] = step(GaDelta, 1.2);
[stepGf, tF] = step(Gf, 1.2);
[stepGfDelta, tFDelta] = step(GfDelta, 1.2);

degrauA = ones(length(stepGa), 1);
degrauF = ones(length(stepGf), 1);

figure, plot(tA, degrauA, tA, stepGa, tADelta, stepGaDelta);
title('Malha aberta');
legend('degrau', 'k1', 'k1*', 'Location', 'northwest');

figure, plot(tF, degrauF, tF, stepGf, tFDelta, stepGfDelta);
title('Malha fechada');
legend('degrau', 'k1', 'k1*', 'Location', 'southeast');

% QUESTAO 4
% calculo do novo kpf para erro de regime nulo
kpfA = 1 / Gps0;
Ga = kpfA * Gps;

% calculo do novo erro de regime
Ea = (1 - Ga);
eRegA = dcgain(Ea);

display(eRegA);

% QUESTAO 5
% calculo do novo kpf em funcao de kp, para erro de regime nulo
kpfF = (1 + kp * Gps0) / (kp * Gps0);
Gf = kpfF * feedback(Gps * kp, 1);

% calculo do novo erro de regime
Ef = (1 - Gf);
eRegF = dcgain(Ef);

display(eRegF);

% QUESTAO 12
% malha aberta
[tout, ~, yout] = sim('exp01e06_aberta');
figure;
plot(tout, yout);
hold on;
grid on;

k1 = 700;
[tout, ~, yout] = sim('exp01e06_aberta');
plot(tout, yout(:,2));

title('Resposta em malha aberta para diferentes k_1');
legend('Entrada degrau', 'k_1 = 338.6 N/m', 'k_1 = 700 N/m');
hold off;

% malha fechada, k1 constante (700)
k1 = 700;

kpArray = [0.03 0.06 0.12 0.24 0.48 0.96];

kp = kpArray(1);
[tout, ~, yout] = sim('exp01e06_fechada');

figure;
plot(tout, yout);
hold on;
grid on;

for i = 2:length(kpArray)
    kp = kpArray(i);
    [tout, ~, yout] = sim('exp01e06_fechada');
    plot(tout, yout(:,2));
end

legend('Entrada degrau', 'k_p = 0.03', 'k_p = 0.06', 'k_p = 0.12', 'k_p = 0.24')
title('Resposta em malha fechada para k_1 = 700 N/m');
hold off;

% malha fechada, kp constante (0.24)
figure;
kp = 0.24;
k1 = 338.6;
Gps = khw / (m1*s^2 + (c1+khw*kv)*s + k1);
Gps0 = dcgain(Gps);
kpfF = (1 + kp * Gps0) / (kp * Gps0);
[tout, ~, yout] = sim('exp01e06_fechada');
plot(tout, yout);
hold on;

k1 = 700;
[tout, ~, yout] = sim('exp01e06_fechada');
plot(tout, yout(:,2));

grid on;
legend('Entrada degrau', 'k_1 = 338.6 N/m', 'k_1 = 700 N/m');
title('Resposta em malha fechada para k_p = 0.24');
