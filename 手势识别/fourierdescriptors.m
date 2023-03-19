function FD = fourierdescriptors(pic)
% numcoeffs: The number of coefficients to be returned in each
% fourier descriptor. (Defaults to six).
  numcoeffs = 7; %自定义前6个系数
  q = fft2(pic);    % Transform to frequency domain.
  % Truncate to the first six coeffs (skipping the first---translation).
  normalizationfactor = abs(q(1)); %提取轮廓图像变换后的直流分量
  q = q(2:1+numcoeffs); %只提取前2-8个系数
  % Take the magnitude (throwaway the phase information).
  q = abs(q);
  % Return q as the fourier descriptor for this image after
  % normalizing to get rid of any scaling constant.
  FD = q/normalizationfactor; %归一化处理
end
