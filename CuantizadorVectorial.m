classdef CuantizadorVectorial
  methods(Static)
    
    
    function [indx,centroides] = estabilizador(centroides, data)
      
      sizeCent = size(centroides);
     
      display('La primera distancia: ')
      distances = CuantizadorVectorial.pdistItakuraSaito(data,centroides)
      [distMenor,indx] = min(distances, [ ], 2);
      distGAnterior = 0; 
      distGActual = sum(distMenor);
      
      %Número de muestras asociadas por centroide
      samplesPerCent = zeros(sizeCent(1),1);
      
      while abs(distGActual - distGAnterior) > 0.01
        for i = 1:sizeCent(1)
          ind = indx==i;
          dataGroup = data(ind,:);
          sizeDG = size(dataGroup);
          centroides(i,:) = (1/sizeDG(1)) * sum (dataGroup);
          samplesPerCent(i) = sizeDG(1);
        end
        display('El número de muestras por grupo')
        samplesPerCent
        distances = CuantizadorVectorial.pdistItakuraSaito(data,centroides)
        [distMenor,indx] = min(distances, [ ], 2);
        distGAnterior = distGActual;
        distGActual = sum(distMenor);
      end
    end
    
    
    function  [indx,centroides] = LindeBuzoGray(centroides, nCuant, data)
      e1 = (rand([1,13])-0.5)*0.00000018; %Entre -0.000005 y 0.000005
      e2 = (rand([1,13])-0.5)*0.00000017;
      nCentroides = [centroides + e1; centroides + e2]
      [indx,centroides] = CuantizadorVectorial.estabilizador(nCentroides, data);
      sizeC = size(centroides);
      if sizeC(1) < nCuant
        [indx,centroides] = CuantizadorVectorial.LindeBuzoGray(centroides, nCuant, data);
      end
    end
    
    
    %vecor distC1, distC2, ...
    %La correlación debe ser en uno más grande a lso indices de Wienner
    function distances = pdistItakuraSaito(data,centroides)
      sizeC = size(centroides);
      distances = zeros(length(data),sizeC(1));
      centroides_a = Wienner.centPredictors(centroides);
      ra = Correlation.ACorrelation(centroides_a,Wienner.Orden);
      for i = 1:length(data)
        for j = 1:sizeC(1)
          distances(i,j) = data(i,1)*ra(j,1) + 2 *dot(data(i,2:end-1), ra(j,2:end));
        end
      end
    end
    
  end
end