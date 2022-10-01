**1、GUI界面设计**

图形用户界面（GUI）是指由窗口、菜单、图标、按键、对话框和文本等各种图像对象组成的用户界面。在Matlab中最常用Guide和App designer两种工具设计GUI，在这里选择设计简单、功能较多且面向对象的App designer。App designer组件库提供了大多数UI组件，可以直接拖放到画布上进行布局，然后再组件的回调函数中进行代码的编写。每个组件就是UI对象的属性，而回调函数就是UI中的方法。对于每个组件，都有其特定的对象名和属性，可以通过更改对象名来进行调用该组件，更改属性值来改变组件的外观、初值、以及一些组件自带的功能。

**2、信号生成**

（1）多频正弦（测试信号）

多频正弦信号使用如下的for循环生成，方便控制生成的频率成分，可输入采样频率Fs和采样点数N，默认分别为100Hz和256。

（2）数字音频

以voice.wav做默认的音频输入源，通过audioread()函数读取音频信号，分别用以下if else语句判断是否加入白噪声、单频噪声、高斯噪声、多频噪声，使用audiowrite()可以将加入噪声后的信号写入音频文件voice1.wav，方便后续播放（使用sound()函数）加噪后的音频。

**3、频谱分析**

将信号做快速傅里叶变换,调用方式为Y=fft(X,N),尽量选用N为2的幂次，计算速度会显著变快。然后作出Y的幅频特性曲线和相频特性曲线，对信号做频域的分析。

**4、滤波器设计**

**（1）巴特沃斯低通模拟滤波器设计原理**

巴特沃斯低通模拟滤波器的幅度平方函数$\left| H_{a}(j\Omega) \right|^{2}$用下式表示：

$$
\left| H_{a}(j\Omega) \right|^{2} = \frac{1}{1 + \left( \frac{\Omega}{\Omega_{c}} \right)^{2N}}
$$

式中，N称为滤波器的阶数，$\Omega_{c}$是3dB截止频率。

阶数N的大小主要影响通带幅频特性的平坦程度和过渡带、阻带的幅度下降速度，它由技术指标$\Omega_{p}$、$\alpha_{p}$、$\Omega_{s}$、$\alpha_{s}$确定，则N表示为：

$$
N = \frac{\lg\left( \frac{10^{\frac{\alpha}{10}} - 1}{10^{\frac{\alpha}{10}} - 1} \right)}{2lg\left( \frac{\Omega_{s}}{\Omega_{p}} \right)}
$$

用上式求出的N可能有小数部分，应取大于或等于N的最小整数。关于3dB截止频率$\Omega_{c}$，如果技术指标没有给出，可以按照下式求出：

$$
\Omega_{c} = \Omega_{p}\left( 10^{0.1\alpha_{p}} - 1 \right)^{- \frac{1}{2N}}
$$

或

$$
\Omega_{c} = \Omega_{s}\left( 10^{0.1\alpha_{s}} - 1 \right)^{- \frac{1}{2N}}
$$

以s替换$j\Omega$，将幅度平方函数$\left| H_{a}(j\Omega) \right|^{2}$写成s的函数：

$$
H_{a}(s)H_{a}( - s) = \frac{1}{1 + \left( \frac{s}{{j\Omega}_{c}} \right)^{2N}}
$$

复变量$s = \sigma + j\Omega$，此式表明幅度平方函数有2N个极点，极点$s_{k}$用下式表示：

$$
s_{k} = ( - 1)^{\frac{1}{2N}}\left( {j\Omega}_{c} \right) = \Omega_{c}e^{j\pi\left( \frac{1}{2} + \frac{2k + 1}{2N} \right)}
$$

式中，k=0,1,2，…，2N-1。

为形成因果稳定的滤波器，2N个极点中只取s平面左半平面的N个极点构成$ H_{a}(s) $，$ H_{a}(s) $的表达式为：

$$
H_{a}(s) = \frac{\Omega_{c}^{N}}{\prod_{k = 0}^{N - 1}\left( s - s_{k} \right)}
$$

从s平面变换到z平面

$$
s = \frac{2}{T}\frac{1 - z^{- 1}}{1 + z^{- 1}}
$$

得

$$
H(z) = H_{a}(s)\left. \  \right|_{s = \frac{2}{T}\frac{1 - z^{- 1}}{1 + z^{- 1}}}
$$

然后根据差分方程计算滤波结果

$$
y(n) = \sum_{k = 0}^{\infty}{h(k)x(n - k)} = - \sum_{k = 1}^{M}a_{k}y(n - k) + \sum_{k = 0}^{N}b_{k}x(n - k)
$$

**（2）用到的Matlab工具箱函数：**

- \[N,wc\]=buttord(wp,ws,ap,as)

计算巴特沃斯数字滤波器的阶数N和3dB截止频率wc。调用参数wp和ws分别为数字滤波器的通带边界频率和阻带边界频率的归一化值，要求0≤wp≤1，0≤ws≤1,1表示数字频率π（对应模拟频率Fs/2，Fs表示采样频率）。N和wc作为butter函数的调用参数。

- \[B,A\]=butter(N,wc,’ftype’)

计算N阶巴特沃斯数字滤波器系统函数分子和分母多项式的系数向量B和A。ftype=high时，设计3dB截止频率为wc的高通滤波器。ftype=low时，设计3dB截止频率为wc的低通滤波器，缺省默认低通滤波器。ftype=stop时，设计3dB截止频率为wc的带阻滤波器，此时wc为二元向量\[wcl,wcu\]，wcl和wcu分别为带阻滤波器的通带3dB下截止频率和上截止频率。缺省时设计带通滤波器，通带为频率区间wcl\<w\<wcu。

- \[N,wso\]=cheb2ord(wp,ws,ap,as)

- \[B,A\]=cheby2(N,as,wso,’ftype’)

- \[N,wpo\]=ellipord(wp,ws,ap,as)

- \[B,A\]=ellip(N,ap,wpo,’ftype’)

- Hn=fir1(M,wc,’ftype’,window)

可以指定窗函数向量window，缺省则默认哈明窗hamming(M+1)，可选矩形窗boxcar(M+1)、三角窗bartlett(M+1)、汉宁窗hanning(M+1)、布莱克曼窗blackman(M+1)、凯赛——贝塞尔窗kaiser(M+1,beta)。

**5、输出信号分析**

通过设计的滤波器对信号进行滤波，展示其时域波形、幅频特性、相频特性，同时对于音频信号**支持播放处理后的音频**。
