classdef CuantizadorVectorial
  methods(Static)
    
    
    function [indx,centroides] = estabilizador(centroides, data)
      
      sizeCent = size(centroides);
      %display('La primera distancia: ')
      distances = CuantizadorVectorial.pdistItakuraSaito(data,centroides);
      [distMenor,indx] = min(distances, [ ], 2);
      distGAnterior = 0; 
      distGActual = sum(distMenor);
      
      %Número de muestras asociadas por centroide
      %samplesPerCent = zeros(sizeCent(1),1);
      
      while abs(distGActual - distGAnterior) > 1.0
        for i = 1:sizeCent(1)
          ind = indx==i;
          dataGroup = data(ind,:);
          sizeDG = size(dataGroup)
          centroides(i,:) = (1/sizeDG(1)) * sum (dataGroup);
          %samplesPerCent(i) = sizeDG(1);
        end
        %display('El número de muestras por grupo')
        %samplesPerCent
        distances = CuantizadorVectorial.pdistItakuraSaito(data,centroides);
        [distMenor,indx] = min(distances, [ ], 2);
        distGAnterior = distGActual;
        distGActual = sum(distMenor);
      end
    end
    
    
    
    function  [indx,centroides] = LindeBuzoGray(centroides, nCuant, data)
      e1 = (rand([1,13])-0.5)*0.00000000018; %Entre -0.000005 y 0.000005
      e2 = (rand([1,13])-0.5)*0.0000000001768;
      %e1 = [0.0001,-0.0001,0.0001,-0.0001,0.0001,-0.0001, 0.00001,0.0001,0.0001,-0.0001,0.001,-0.0001,0.001];
      %e2 = [0.0001,-0.0001,0.0001,0.0001,-0.0001,0.0001, 0.00001,-0.0001,-0.001,0.001,0.001,-0.0001,-0.0001];
      nCentroides = [centroides + e1; centroides + e2]; %Nuevos centroides
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
      distances = zeros(length(data),sizeC(1)); %Crea matriz, cada renglón corresponde a un bloque y cada columna la distancia a un centroide
      centroides_a = Wienner.centPredictors(centroides); %Calcula los coeficientes 'a'
      ra = Correlation.ACorrelation(centroides_a,Wienner.Orden); %Calcula la correlación corta de los coeficientes a
      for i = 1:length(data)
        for j = 1:sizeC(1)
          distances(i,j) = data(i,1)*ra(j,1) + 2 *dot(data(i,2:end-1), ra(j,2:end));
          %Utiliza solo 12 coeficientes de correlación ya que solo tenemos
          %12 coeficintes de 'a'
        end
      end
    end
    
  end
end