Fs = 50;
N = 256;
wp = 2*pi*10/Fs;
ws = 2*pi*20/Fs;
ap = 1;
as = 30;
t = 1:1/Fs:N/Fs;
y = sin(2*pi*10*t)+sin(2*pi*15*t)+sin(2*pi*5*t)+sin(2*pi*20*t);
subplot(2,2,1)
stem(y,'.');
subplot(2,2,2)
stem(abs(fft(y)),'.');
wc = (wp+ws)/2;
Bt = ws-wp;
N1 = ceil(6.2*pi/Bt);
a = (N1-1)/2;
n = 1:N1+1;
wn = hanning(N1+1)';
hn = sin(wc*(n-a))./(pi*(n-a)).*wn;
y = conv(y,hn);
subplot(2,2,3)
stem(y,'.');
subplot(2,2,4)
stem(abs(fft(y)),'.');