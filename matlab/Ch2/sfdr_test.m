%% sfdr_test.m
% Must run section by section

%% Specify plot parameters
txtsize=10;
ltxtsize=9;
pwidth=4;
pheight=4;
pxoffset=0.65;
pyoffset=0.5;
markersize=5;

%% Double Precision
deltat = 1e-8;
fs = 1/deltat;
t = 0:deltat:1e-5-deltat;
fundamental=3959297;
x = 10e-3*sin(2*pi*fundamental*t);
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);
pause;

%% 12-bit Scaled Floating Point
bits=2^11;
x = round(10e-3*bits*sin(2*pi*fundamental*t))/bits;
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);
pause;

%% 12-bit Scaled Fixed Point 1k points
bits=2^9;
x = round(bits*sin(2*pi*fundamental*t))/bits;
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);
pause;

%% 12-bit Scaled Fixed Point 10k points
t = 0:deltat:1e-4-deltat;
x = round(bits*sin(2*pi*fundamental*t))/bits;
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);
pause;

%% 12-bit scaled Fixed Point without Dither
fundamental=4000000;
x = round(bits*sin(2*pi*fundamental*t))/bits;
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);
pause;

%% 12-bit scaled Fixed Point with Dither
ran = rand(1,length(t)) - 0.5;
x = round(bits*sin(2*pi*fundamental*t) + ran)/bits;
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);
pause;

%%
fundamental=3959297;  % Prime number
x = round(bits*sin(2*pi*fundamental*t) + ran)/bits;
r = sfdr(x,fs)
f1=figure(1);
sfdr(x,fs);
ylim([-400 10]);
f2=figure(2);
plot(t*10e6,x);
xlabel('time (us)');ylabel('Amplitude');
ylim([-1.1 1.1]);

