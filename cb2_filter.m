function [] = cb2_filter() %切比雪夫II型低通滤波器
clear;close all;clc;
 
As=10; %dB
Ap=1;
ws=0.4 * pi; %rad/s
wp=0.1 * pi;
wc=ws;
 
epsilon = epsilonCalulate(As); % 计算epsilon
N = order(Ap,epsilon,ws,wp); % 计算阶数N
 
fprintf('epsilon = %d\r\n',epsilon);
fprintf('N = %d\r\n',N);
fprintf('wc = %0.4f\r\n',wc);
 
S = pole(N,epsilon) % 计算极点
Hs = sysFunc(S,N,epsilon); % 计算系统函数
digits(4); %减少小数位数
pretty(expand(vpa(Hs,2))) % 化简系统函数
 
b = [1]; %系统函数分子
a = [1 1.47 1.581]; %系统函数分母
sys = tf(b,a)
subplot(211);
pzmap(sys)
 
w = 0.01:0.01:2*pi;
Gw = gainFunc(N,wc,w,epsilon);
subplot(212);
plot(w,Gw); % 计算增益曲线图
 
wsValue = gainFunc(N,wc,ws,epsilon); %标记ws,wp
wpValue = gainFunc(N,wc,wp,epsilon);
text(ws,wsValue,'o','color','r')
text(wp,wpValue,'o','color','b')
text(ws,-20,['(ws=',num2str(ws,'%0.1f'),',G=',num2str(wsValue,'%0.1f'),'dB)'],'color','r')
text(wp,-3,['(wp=',num2str(wp,'%0.1f'),',G=',num2str(wpValue,'%0.1f'),'dB)'],'color','b')
 
function N = order(Ap,epsilon,ws,wp) % 计算阶数N
	n = acosh(1/(epsilon * sqrt( (10^(0.1*Ap)) - 1 ) ));
	m = acosh(ws/wp);
	N = ceil(n/m);
 
function epsilon = epsilonCalulate(As) % 计算epsilon
	epsilon = 1/(sqrt((10 ^ (0.1*As)) - 1));
 
function S = pole(N,epsilon) % 计算极点
	beta = asinh(1/epsilon) / N;
	for k=1:N
		sita = -sinh(beta)*sin( (2*k-1)*pi/(2*N) );
		omiga = -cosh(beta)*cos( (2*k-1)*pi/(2*N) );
		S(k) = sita + i*omiga;
	end
 
function Hs = sysFunc(S,N,epsilon) % 计算系统函数
	N = length(S);
	Hs = 1;
	h0 = 1; % wc>0 && epsilon>0, H0=1
	syms s
	for k=1:N
		Hs = Hs * (h0 / ( s-S(k) ));
	end
 
function CNx = cnxFunc(N,x) % 计算CN(x)函数
	for i=1:length(x)
		if abs(x(i)) <= 1
			CNx(i) = cos(N*acos(x(i)));
		else
			CNx(i) = cosh(N*acosh(x(i)));
		end
	end
 
function Gw = gainFunc(N,wc,w,epsilon) % 增益函数 Gw=-Aw
	n = (epsilon^2) * (cnxFunc(N,wc./w).^2);
	m = 1+n;
	Gw = 10*log10(n./m);
 