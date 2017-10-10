
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

% calculo de kp e kd dados os wn e eAmort
wn = 8*pi;
eAmortArr = [0.2, 1.0, 2.0];

for eAmort = eAmortArr
    kp = m1 / khw * wn^2;
    kd = (2 * m1 * eAmort * wn - c1) / khw;

    display([kp, kd]);
end

