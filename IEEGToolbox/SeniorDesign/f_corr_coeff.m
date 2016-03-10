function output = f_corr_coeff(data, startIndex, endIndex,fs)
  paramsFunction = @(x) (corrcoef(x));
  [x,y] = size(data); 


  % filter then normalize each channel by std of entire data block
  data = high_pass_filter(data, fs);
  data = low_pass_filter(data, fs);
  
 %featureOut = paramsFunction(data(startIndex:endIndex, :));

 if endIndex > x
     featureOut = paramsFunction(data(startIndex:x,:));
 else
     featureOut = paramsFunction(data(startIndex:endIndex,:));
 end 

  
  manipFeature = tril(featureOut,-1);
  manipFeature = reshape(manipFeature,1,[]);
  manipFeature = manipFeature(manipFeature~=0);
  output = manipFeature; 
  
end

function y = low_pass_filter(x,Fs)
  % MATLAB Code
  % Generated by MATLAB(R) 8.2 and the DSP System Toolbox 8.5.
  % Generated on: 09-Mar-2015 11:44:09

  persistent Hd;

  if isempty(Hd)

    N     = 4;     % Order
    F3dB  = 50;    % 3-dB Frequency
    Apass = 1;     % Passband Ripple (dB)

    h = fdesign.lowpass('n,f3db,ap', N, F3dB, Apass, Fs);

    Hd = design(h, 'cheby1', ...
      'SOSScaleNorm', 'Linf');

    set(Hd,'PersistentMemory',true);

  end

  y = filtfilt(Hd.sosMatrix, Hd.ScaleValues, x);
%  y = filter(Hd,x);
end

function y = high_pass_filter(x, Fs)
  % MATLAB Code
  % Generated by MATLAB(R) 8.2 and the DSP System Toolbox 8.5.
  % Generated on: 04-Mar-2015 10:14:48

  persistent Hd;

  if isempty(Hd)

    N     = 3;    % Order
    F3dB  = 4;     % 3-dB Frequency
    Apass = 1;     % Passband Ripple (dB)

    h = fdesign.highpass('n,f3db,ap', N, F3dB, Apass, Fs);

    Hd = design(h, 'cheby1', ...
      'SOSScaleNorm', 'Linf');

    set(Hd,'PersistentMemory',true);

  end
  
  y = filtfilt(Hd.sosMatrix, Hd.ScaleValues, x);
%   y = filtfilt(h,x);
end
    
