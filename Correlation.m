classdef Correlation
  methods(Static)
    
    function acorrSamples = AutoCorrs(samples, elems) 
      N = length(samples);
      acorrSamples = zeros(N,elems);
      parfor i = [1:N]
        acorrSamples(i,:) = Correlation.ACorrelation(samples(i,:),elems);
      end
    end
   
    
    %Obtiene los primeros N terminos de la autocorrelación de una señal
    %(vector renglón)
    function corr = ACorrelation (signal, N)
      sizeS = size(signal);
      corr = zeros(sizeS(1),N);
      for k = 1:sizeS(1)
        for i = 1:N
          simetric = [signal(k,i:end) zeros(1,i-1)];
          corr(k,i) = dot(signal(k,:), simetric)/N;
        end
        
      end
    end
  end
end