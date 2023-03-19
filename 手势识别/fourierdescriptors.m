function FD = fourierdescriptors(pic)
% numcoeffs: The number of coefficients to be returned in each
% fourier descriptor. (Defaults to six).
  numcoeffs = 7; %�Զ���ǰ6��ϵ��
  q = fft2(pic);    % Transform to frequency domain.
  % Truncate to the first six coeffs (skipping the first---translation).
  normalizationfactor = abs(q(1)); %��ȡ����ͼ��任���ֱ������
  q = q(2:1+numcoeffs); %ֻ��ȡǰ2-8��ϵ��
  % Take the magnitude (throwaway the phase information).
  q = abs(q);
  % Return q as the fourier descriptor for this image after
  % normalizing to get rid of any scaling constant.
  FD = q/normalizationfactor; %��һ������
end
