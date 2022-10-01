N = 256;
Fs = 100;
T = 1/Fs;
t = 0:T:(N-1)*T;
y = 100*sin(2*pi*5*t);
for f = 10:5:40
    y = 100*sin(2*pi*f*t)+y;
end
subplot(2,1,1);
stem(t,y,'.');
% 技术指标
as = 30;
ap = 1;
wp =12*2*pi;
ws =16*2*pi;
% 阶数N1
N1 = ceil(log10((10^(0.1*as)-1) / (10^(0.1*ap)-1)) / (2*log10(ws/wp)));
% 截止频率
wc1 = wp / ((10^(0.1*ap)-1)^(1/(2*N1)));
wc2 = wp / ((10^(0.1*as)-1)^(1/(2*N1)));
% 极点
wc = wc1;
for k=1:N1
    S(k) = wc * exp(i*pi*(1/2+(2*k-1)/(2*N1)));
end
syms s
% 系统函数分母
Hs = 1;
for k=1:length(S)
    Hs = Hs * (s-S(k));
end
B = wc^N1;
A = real(sym2poly(Hs));
[B,A] = bilinear(B,A,Fs);
y = filter(B,A,y);
subplot(2,1,2);
stem(t,y,'.');