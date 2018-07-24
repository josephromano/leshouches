function C = correlate(tau, x, y, norm)
%
% calculate correlation C(tau) for two time-series x, y,
% doing the calculation in the frequency domain.
%
% norm - normalization factor 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% extract relevant time-domain quantities
deltaT = x(2,1)-x(1,1);
N = length(x(:,1));
deltaF = 1/(N*deltaT);

% calculate discrete frequencies 
fNyq = 1/(2*deltaT);
if ( mod(N,2)== 0 )
  numFreqs = N/2 - 1;
else
  numFreqs = (N-1)/2;
end

% discrete positive frequencies
fp = deltaF*[1:1:numFreqs]';

% discrete frequencies (including zero and negative frequencies
if ( mod(N,2)== 0 )
  f = [0; fp; -fNyq; flipud(-fp)];
else
  f = [0; fp; flipud(-fp)];
end

% fourier transform time series
xtilde = deltaT * fft(x(:,2));
ytilde = deltaT * fft(y(:,2));

% calculate correlation C(tau)
phase= exp(sqrt(-1)*2*pi*f*tau);
C = sum(deltaF * phase .* xtilde.*conj(ytilde));
C = real(C); % take real part to avoid imag component from round-off
C = norm*C;  % normalize

return
