function [] = freq_conv() %模拟频率转换
clear;close all;clc;
 
wp1 = 10; wp2 = 30; ws1 = 19; ws2 = 21;
[lpws,lpwp] = bs2lp(ws1,ws2,wp1,wp2)
 
wp1 = 6; wp2 = 8; ws1 = 4; ws2 = 11;
[lpws,lpwp] = bp2lp(ws1,ws2,wp1,wp2)
 
function [lpws,lpwp] = hp2lp(hpws,hpwp) % 高通到低通
	lpws = 1/hpws;
	lpwp = 1/hpwp;
 
function [lpws,lpwp] = bp2lp(bpws1,bpws2,bpwp1,bpwp2) % 低通到带通
	B = abs( bpwp2 - bpwp1 );
	w0_2 = bpwp1 * bpwp2;
	ws1_ = (bpws1^2 - w0_2) / (B * bpws1);
	ws2_ = (bpws2^2 - w0_2) / (B * bpws2);
	lpws = min(abs(ws1_),abs(ws2_));
	lpwp = 1;
 
function [lpws,lpwp] = bs2lp(bsws1,bsws2,bswp1,bswp2) % 带阻到低通
	B = abs( bsws2 - bsws1 );
	w0_2 = bsws1 * bsws2;
	wp1_ = (B * bswp1) / (-(bswp1^2) + w0_2) ;
	wp2_ = (B * bswp2) / (-(bswp2^2) + w0_2) ;
	lpwp = max(abs(wp1_),abs(wp2_));
	lpws = 1;