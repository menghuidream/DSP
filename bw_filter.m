function [] = bw_filter() %巴特沃斯低通滤波器
clear;close all;clc;
 
As=10; %dB
Ap=1;
ws=0.4 * pi; %rad/s
wp=0.1 * pi;
 
N = order(As,Ap,ws,wp);
fprintf('N = %d\r\n',N);
[wc1,wc2] = cutFreq(As,Ap,ws,wp,N);
fprintf('wc = [%0.4f , %0.4f]\r\n',wc1,wc2);
 
syms s wc
S = pole(N);
Hs = sysFunc(S);
pretty(expand(Hs)) % 计算系统函数
 
wcc = wc1; %代入wc计算零极点分布图
b = [wcc^2]; %系统函数分子
a = [1 sqrt(2)*wcc wcc^2]; %系统函数分母
sys = tf(b,a)
subplot(211);
pzmap(sys)
 
w = 0:0.01:2*pi;
wc = wc2;
Gw = gainFunc(N,wc,w);
subplot(212);
plot(w,Gw); % 计算增益曲线图
 
wsValue = gainFunc(N,wc,ws); %标记ws,wp
wpValue = gainFunc(N,wc,wp);
text(ws,wsValue,'o','color','r')
text(wp,wpValue,'o','color','b')
text(ws,-5,['(ws=',num2str(ws,'%0.1f'),',G=',num2str(wsValue,'%0.1f'),'dB)'],'color','r')
text(wp,-22,['(wp=',num2str(wp,'%0.1f'),',G=',num2str(wpValue,'%0.1f'),'dB)'],'color','b')
 
function N = order(As,Ap,ws,wp) % 计算阶数N
	n = log10( (10^(0.1*As) - 1) / (10^(0.1*Ap) - 1) );
	m = 2*log10(ws/wp);
	N = ceil(n/m);
 
function [wc1,wc2] = cutFreq(As,Ap,ws,wp,N) % 计算截止频率 wc1 <= wc <= wc2
	wc1 = wp / ((10^(0.1*Ap) - 1)^(1/(2*N)));
	wc2 = ws / ((10^(0.1*As) - 1)^(1/(2*N)));
 
function S = pole(N) % 计算极点
	syms wc
	for k=1:N
		S(k) = wc * exp(i*pi*(1/2 + (2*k-1)/(2*N) ));
	end
 
function Hs = sysFunc(S) % 计算系统函数
	N = length(S);
	Hs = 1;
	syms s wc
	for k=1:N
		Hs = Hs * ( (-S(k)) / ( s - S(k) ));
	end
 
function Gw = gainFunc(N,wc,w) % 增益函数 Gw=-Aw
	Gw = -10*log10(1 + ((w'/wc) .^ (2*N)));