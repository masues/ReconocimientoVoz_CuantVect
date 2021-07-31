classdef CuantizadorVectorial
  methods(Static)
    
    
    function [indx,centroides] = estabilizador(centroides, data)
      
      sizeCent = size(centroides);
      distances = CuantizadorVectorial.pdistItakuraSaito(data,centroides);
      [distMenor,indx] = min(distances, [ ], 2);
      distGAnterior = 0; 
      distGActual = sum(distMenor);
      
      while abs(distGActual - distGAnterior) > 1.0
        for i = 1:sizeCent(1)
          ind = indx==i;
          dataGroup = data(ind,:);
          sizeDG = size(dataGroup);
          centroides(i,:) = (1/sizeDG(1)) * sum (dataGroup);
        end
        distances = CuantizadorVectorial.pdistItakuraSaito(data,centroides);
        [distMenor,indx] = min(distances, [ ], 2);
        distGAnterior = distGActual;
        distGActual = sum(distMenor);
      end
    end
    
    
    
    function  [indx,centroides] = LindeBuzoGray(centroides, nCuant, data)
      nCentroides = [centroides * 0.9999; centroides * 1.0001]; %Nuevos centroides
      [indx,centroides] = CuantizadorVectorial.estabilizador(nCentroides, data);
      sizeC = size(centroides);
      if sizeC(1) < nCuant
        [indx,centroides] = CuantizadorVectorial.LindeBuzoGray(centroides, nCuant, data);
      end
    end
    

    
    function distances = pdistItakuraSaito(data,centroides)
      sizeC = size(centroides); % Número de centroides
      sizeD = size(data,1); % Número de muestras de datos
      distances = zeros(sizeD,sizeC(1)); %Crea matriz, cada renglón corresponde a un bloque y cada columna la distancia a un centroide
      centroides_a = Wiener.centPredictors(centroides); %Calcula los coeficientes 'a'
      ra = Correlation.ACorrelation(centroides_a, sizeC(2)); %Calcula la correlación corta de los coeficientes a
      for i = 1:sizeD
        for j = 1:sizeC(1)
          distances(i,j) = data(i,1)*ra(j,1) + 2 *dot(data(i,2:end), ra(j,2:end));
        end
      end
    end
    
  end
end