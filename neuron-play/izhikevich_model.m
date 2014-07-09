function mp = izhikevich_model(initialMP, inputCurrent)

v = initialMP;
u = -20;
tau = 0.2;
I = inputCurrent;
a = 0.02;
b = 0.2
c = -65
d = 6
v = v+tau*(0.04*v^2+5*v+140-u+I);
u = u+tau*a*(b*v-u);

if v>30
       v=c;
       u=u+d;
       VU(1,1)=31;
end;

mp = v;