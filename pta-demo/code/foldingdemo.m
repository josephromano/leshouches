% script for illustrating data folding

close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
randn('state', 31415)

% discrete times
Fs = 100;
deltaT = 1/Fs;
T = 8;
N = floor(T/deltaT);
t = linspace(0, T-deltaT, N);

% calculate profile (cosine guassian)

% profile from -1 sec to 1 sec
tp = linspace(-1,1,Fs*2);
T0 = 0.2; % period for cosine
p = cos(2*pi*tp/T0).*exp(-(tp/0.15).^2);
norm = 1/sum(deltaT*p.^2);

% template for zero-padded data from 0 to 10 sec
template = cos(2*pi*t/T0).*exp(-(t/0.15).^2) ...
         + cos(2*pi*(t-T)/T0).*exp(-((t-T)/0.15).^2);

% signal is pulse centered at t1 and t2
% data = signal + noise (white noise)
t1 = 1.5;
t2 = 3.5;
t3 = 5.5;
t4 = 7.5;
s1 = cos(2*pi*(t-t1)/T0).*exp(-((t-t1)/0.15).^2);
s2 = cos(2*pi*(t-t2)/T0).*exp(-((t-t2)/0.15).^2);
s3 = cos(2*pi*(t-t3)/T0).*exp(-((t-t3)/0.15).^2);
s4 = cos(2*pi*(t-t4)/T0).*exp(-((t-t4)/0.15).^2);
s = s1 + s2 + s3 + s4;
n = 0.3*randn(size(s));
d = s+n;

% plot data
figure(1)
subplot(4,1,1)
plot(t, d, '-b', 'linewidth', 2)
ylim([-2 2])
xlabel('time (s)', 'fontsize', 14)
ylabel('data', 'fontsize', 14)
grid on
print -depsc2 foldeddata_original.eps

% break data into chunks  
Tp = 1.6;
Np = Tp*Fs;
tf1 = linspace(0, (Np-1)*deltaT, Np);
tf2 = linspace(Np*deltaT, (2*Np-1)*deltaT, Np);
tf3 = linspace(2*Np*deltaT, (3*Np-1)*deltaT, Np);
tf4 = linspace(3*Np*deltaT, (4*Np-1)*deltaT, Np);
tf5 = linspace(4*Np*deltaT, (5*Np-1)*deltaT, Np);
d1 = d(1:Np);
d2 = d(Np+1:2*Np);
d3 = d(2*Np+1:3*Np);
d4 = d(3*Np+1:4*Np);
d5 = d(4*Np+1:5*Np);
foldedavg = (1/5)* (d1+d2+d3+d4+d5);

figure(2)
subplot(5,1,1)
plot(tf1, d1, '-b', 'linewidth', 2)
xlim([tf1(1) tf1(end)])
ylim([-2 2])
ylabel('data', 'fontsize', 14)
subplot(5,1,2)
plot(tf2, d2, '-b', 'linewidth', 2)
xlim([tf2(1) tf2(end)])
ylim([-2 2])
ylabel('data', 'fontsize', 14)
subplot(5,1,3)
plot(tf3, d3, '-b', 'linewidth', 2)
xlim([tf3(1) tf3(end)])
ylim([-2 2])
ylabel('data', 'fontsize', 14)
subplot(5,1,4)
plot(tf4, d4, '-b', 'linewidth', 2)
xlim([tf4(1) tf4(end)])
ylim([-2 2])
ylabel('data', 'fontsize', 14)
subplot(5,1,5)
plot(tf5, d5, '-b', 'linewidth', 2)
xlim([tf5(1) tf5(end)])
ylim([-2 2])
ylabel('data', 'fontsize', 14)
xlabel('time (s)', 'fontsize', 14)
ylabel('data', 'fontsize', 14)
print -depsc2 foldeddata_incorrect_all.eps

figure(3)
subplot(4,1,1)
plot(tf1, foldedavg, '-r', 'linewidth', 2)
xlim([tf1(1) tf1(end)])
ylim([-1.2 1.2])
xlabel('time (s)', 'fontsize', 14)
ylabel('folded data', 'fontsize', 14)
grid on
print -depsc2 foldeddata_incorrect_avg.eps

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% break data into chunks  
Tp = 2;
Np = Tp*Fs;
tf1 = linspace(0, (Np-1)*deltaT, Np);
tf2 = linspace(Np*deltaT, (2*Np-1)*deltaT, Np);
tf3 = linspace(2*Np*deltaT, (3*Np-1)*deltaT, Np);
tf4 = linspace(3*Np*deltaT, (4*Np-1)*deltaT, Np);
d1 = d(1:Np);
d2 = d(Np+1:2*Np);
d3 = d(2*Np+1:3*Np);
d4 = d(3*Np+1:4*Np);
foldedavg = (1/4)*(d1+d2+d3+d4);

figure(4)
subplot(4,1,1)
plot(tf1, d1, '-b', 'linewidth', 2)
xlim([tf1(1) tf1(end)])
ylim([-2 2])
ylabel('data', 'fontsize', 14)
subplot(4,1,2)
plot(tf2, d2, '-b', 'linewidth', 2)
xlim([tf2(1) tf2(end)])
ylim([-2 2])
ylabel('data', 'fontsize', 14)
subplot(4,1,3)
plot(tf3, d3, '-b', 'linewidth', 2)
xlim([tf3(1) tf3(end)])
ylim([-2 2])
ylabel('data', 'fontsize', 14)
subplot(4,1,4)
plot(tf4, d4, '-b', 'linewidth', 2)
xlim([tf4(1) tf4(end)])
ylim([-2 2])
xlabel('time (s)', 'fontsize', 14)
ylabel('data', 'fontsize', 14)
print -depsc2 foldeddata_correct_all.eps

figure(5)
subplot(4,1,1)
plot(tf1, foldedavg, '-r', 'linewidth', 2)
xlim([tf1(1) tf1(end)])
ylim([-1.2 1.2])
xlabel('time (s)', 'fontsize', 14)
ylabel('folded data', 'fontsize', 14)
grid on
print -depsc2 foldeddata_correct_avg.eps

return


