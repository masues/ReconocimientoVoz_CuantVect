classdef Wienner
  
  properties (Constant)
    Orden = 12
  end

  methods(Static)
    
    function predictors = centPredictors(corr)
      n = size(corr);
      predictors = zeros(n(1),Wienner.Orden);
      for i = 1:n(1)
        predictors(i,:) = Wienner.pedictor(corr(i,:))';
      end
    end
    
    
    
    function W = pedictor(rx)
      Rx = Wienner.matCorre(rx(1:end-1));
      Rx_inv = inv(Rx);
      W = Rx_inv *rx(2:end).';
    end
    
    
    
    function matriz = matCorre(rx)
      n = length(rx);
      matriz = zeros(Wienner.Orden,Wienner.Orden);
      for i = 1:n
        for j = 1:n
          matriz(i,j) = rx(abs(i-j)+1);
        end
      end
    end
    
    
  end
end
