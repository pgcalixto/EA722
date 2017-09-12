
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

kp = 0.08;
kd = 0.01;

% funcao de transferencia da planta
Gp = khw / (m1*s^2 + (c1+khw*kv)*s + k1);

% controlador PD
Hpd = (kp+kd*s)*Gp / (1 + (kp+kd*s)*Gp);

% controlador P&D
Hped = kp*Gp / (1 + (kp+kd*s)*Gp);

% calculo dos polos e zeros
pzmap(Hpd)
pzmap(Hped)
