classdef Correlation
  methods(Static)
   
    
    %Calcula la autocorrelación para cada una las señales contenidas en la 
    %matriz signal, cada renglón representa una señal, N representa el
    %número de elementos requeridos de la correlación.
    function corr = ACorrelation (signal, N)
      sizeS = size(signal);
      corr = zeros(sizeS(1),N);
      for k = 1:sizeS(1)
        for i = 1:N
          simetric = [signal(k,i:end) zeros(1,i-1)]; %Señal desplazada a la izquierda con cada iteración 
          signal(k,:);
          corr(k,i) = dot(signal(k,:), simetric)/N;
        end
        
      end
    end
  end
end