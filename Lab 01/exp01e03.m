
% questao 3
% item a
s = tf('s');

mc1 = 0.778;
mw1 = 4*0.500;
m1 = mc1 + mw1;

c1 = 2.94;
kv = 0.005;
khw = 14732;

k1 = 338.6;
deltak1 = 361.4;

Gps = khw / (m1*s^2 + (c1+khw*kv)*s + k1);
GpsDelta = khw / (m1*s^2 + (c1+khw*kv)*s + (k1 + deltak1));

Gps0 = dcgain(Gps);
Gps0Delta = dcgain(GpsDelta);

% item b
Gpr = 1 / (m1*s^2 + (c1+khw*kv)*s + k1);
GprDelta = 1 / (m1*s^2 + (c1+khw*kv)*s + (k1 + deltak1));

Gpr0 = dcgain(Gpr);
Gpr0Delta = dcgain(GprDelta);

display(Gps0);
display(Gps0Delta);

% item d
Gpf = 1;
kp = 0.12;

Ga = Gpf * Gps;
GaDelta = Gpf * GpsDelta;

Gf = Gpf * feedback(Gps * kp, 1);
GfDelta = Gpf * feedback(GpsDelta * kp, 1);

% item e
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

% item f
stepGa = step(Ga);
stepGaDelta = step(GaDelta);
stepGf = step(Gf);
stepGfDelta = step(GfDelta);

% questao 4
kpfA = 1 / Gps0;
GaZeroErr = kpfA * Gps;
EaZeroErr = (1 - GaZeroErr);
eRegAZeroErr = dcgain(EaZeroErr);

display(eRegAZeroErr);

% questao 5
kpfF = (1 + kp * Gps0) / (kp * Gps0);
GfZeroErr = kpfF * feedback(Gps * kp, 1);
EfZeroErr = (1 - GfZeroErr);
eRegFZeroErr = dcgain(EfZeroErr);

display(eRegFZeroErr);
