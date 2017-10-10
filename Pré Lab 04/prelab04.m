
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

kp = 0.1191;
kd = 0.0093;

% G = (kp + ki/s) * khw / (m1*s^2 + c1*s + (kd*s + kp + ki/s)*khw);

% item 1
ki = 0.5091;
G1 = (kp*s + ki) * khw / (m1*s^3 + (c1+khw*kd)*s^2 + khw*kp*s + khw*ki);
[p1, z1] = pzmap(G1);

% item 2
ki = ki * 2;
G2 = (kp*s + ki) * khw / (m1*s^3 + (c1+khw*kd)*s^2 + khw*kp*s + khw*ki);
[p2, z2] = pzmap(G2);
