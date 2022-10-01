clear
N = 320;
Fs = 500;
T = 1/Fs;
t = 0:T:(N-1)*T;
x = sin(2*pi*10*t)+sin(2*pi*20*t)+sin(2*pi*30*t+sin(2*pi*40*t));
subplot(2,1,1)
stem(t,x,'.')
wc = 18*2/Fs;
Bt = 6*2/Fs;
N = ceil(1.8/Bt);
N = N+mod(N+1,2);
h = fir1(N-1,wc,'low',boxcar(N));
y = conv(h,x);
subplot(2,1,2)
stem(y,'.');