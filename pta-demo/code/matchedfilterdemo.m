% script for illustrating matched filtering

close all

% Prepare the new file.
vidObj = VideoWriter('matchedfilterdemo.avi');

% Set and view the frame rate (frames/sec)
vidObj.FrameRate = 4;

open(vidObj);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
randn('state', 31415)

% discrete times
Fs = 64;
deltaT = 1/Fs;
T = 4;
N = floor(T/deltaT);
t = linspace(0, T, N);
% for zero-padded data
Tz = 2*T;
Nz = 2*N;
tz = linspace(0, Tz, Nz);

% calculate profile (cosine guassian)

% profile from -1 sec to 1 sec
tp = linspace(-1,1,Fs*2);
T0 = 0.2; % period for cosine
p = cos(2*pi*tp/T0).*exp(-(tp/0.15).^2);
norm = 1/sum(deltaT*p.^2);

% template for zero-padded data from 0 to 10 sec
template = cos(2*pi*tz/T0).*exp(-(tz/0.15).^2) ...
         + cos(2*pi*(tz-Tz)/T0).*exp(-((tz-Tz)/0.15).^2);

% signal is pulse centered at t1 and t2
% data = signal + noise (white noise)
t1 = 1.5;
t2 = 3.5;
s1 = cos(2*pi*(t-t1)/T0).*exp(-((t-t1)/0.15).^2);
s2 = cos(2*pi*(t-t2)/T0).*exp(-((t-t2)/0.15).^2);
s = s1 + s2;
n = 0.3*randn(size(s));
d = s+n;

% correlate zero-padded data (correlate routine takes time-series)
C = zeros(N,1);
x(:,1) = tz;
x(:,2) = [d zeros(1,N)];
y(:,1) = tz;
y(:,2) = template;

for ii=1:N
   timeshiftedtemplate{ii} = [template(Nz-ii+1:Nz) template(1:Nz-ii)];
   C(ii) = correlate(t(ii), x, y, norm);
end

% make plots
figure(1)
subplot(2,1,1)
plot(t,d,'-b','linewidth',2)
ylim([-1.5 1.5])
xlabel('time (s)', 'fontsize', 14)
ylabel('data', 'fontsize', 14)
subplot(2,1,2)
plot(tp,p,'-r','linewidth',2)
xlabel('time (s)', 'fontsize', 14)
ylabel('profile', 'fontsize', 14)
print -depsc2 profile_data.eps

for ii=1:floor(N/5)+1
  figure(2)
  subplot(2,1,1)
  plot(t,d,'-b', t,timeshiftedtemplate{5*(ii-1)+1}(1:N), '-r','linewidth',2)
  xlabel('time (s)', 'fontsize', 14)
  ylim([-1.5 1.5])
  legend('data', 'time-shifted template', 'location', 'southeast')
  subplot(2,1,2)
  plot(t(1:5*(ii-1)+1), C(1:5*(ii-1)+1), '-r','linewidth',2)
  xlim([0,T])
  ylim([-1 1])
  xlabel('time shift (s)', 'fontsize', 14)
  ylabel('correlation', 'fontsize', 14)

  pause(0.2);
  currFrame = getframe(gcf);
  writeVideo(vidObj,currFrame);

end

% Close the file.
close(vidObj);

