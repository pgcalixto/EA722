
% PARAMETROS
mc1 = 0.778;
mw1 = 4*0.500;
m1 = mc1 + mw1;

c1 = 2.94;

kp = 0.1191;
kd = 0.0017;

khw = 14732;

% CALCULOS
wn = sqrt(khw * kp / m1);
xi = (c1 + khw * kd)/(2 * m1 * wn);

wr = wn * sqrt(1 - 2 * xi^2);

% PZMAP DO PD E P&D
s = tf('s');

Gpd =  (kp * khw) / (m1 * s^2 + (c1 + khw*kd) * s + khw*kp);
Gped = (kd * khw * s + kp * khw) / (m1 * s^2 + (c1 + khw*kd) * s + khw*kp);

opts = bodeoptions('cstprefs');
opts.FreqUnits = 'Hz';

bodeplot(Gpd, opts)

% item 1
%ki = 0;
%G1 = (kp*s + ki) * khw / (m1*s^3 + (c1+khw*kd)*s^2 + khw*kp*s + khw*ki);
%[p1, z1] = pzmap(G1);



% item 2
%ki = ki * 2;
%G2 = (kp*s + ki) * khw / (m1*s^3 + (c1+khw*kd)*s^2 + khw*kp*s + khw*ki);
%[p2, z2] = pzmap(G2);

