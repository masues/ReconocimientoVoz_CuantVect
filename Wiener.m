classdef Wiener
  
  properties (Constant)
    Orden = 12
  end

  methods(Static)
    
    %Calcula los coefientes a a partir de una matriz de correlación, cada
    %renglón de la matriz representa la correlación de un bloque.
    function predictors = centPredictors(corr)
      n = size(corr);
      predictors = zeros(n(1),n(2));
      for i = 1:n(1)
        predictors(i,:) = [1 -Wiener.pedictor(corr(i,:))'];
      end
    end
    
    
    %Calcula el predictor de Wiener utilizando un vector de correlaciones,
    %si el vector es de tamaño N devuelve un predictor de tamaño N-1
    function W = pedictor(rx)
      Rx = Wiener.matCorre(rx(1:end-1));
      W = Rx \ rx(2:end)'; % Rx^-1 * rx(2:end)'
    end
    
    
    %Crea la matriz simétrica de correlaciones.
    function matriz = matCorre(rx)
      n = length(rx);
      matriz = zeros(n);
      for i = 1:n
        for j = 1:n
          matriz(i,j) = rx(abs(i-j)+1);
        end
      end
    end
    
    
  end
end
