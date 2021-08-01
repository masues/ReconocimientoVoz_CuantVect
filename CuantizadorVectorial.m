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


    %{
    Obtiene la distancia de una señal (vectores de autocorrelación)
    a un cuantizador vectorial.
    :param   data:
      Matriz que contiene a los vectores de autocorrelación de una señal. Su 
      tamaño es mxn con m es el número de vectores, n el orden del vector
      de autocorrelación.
    :param   centroidesCuantizador:
      Matriz que contiene a los centroides del cuantizador vectorial.
      Su tamaño es de oxn, con o el número de centroides, n el orden del vector
      de autocorrelación.
    %}
    function distGlobal = distCuantizador(data, centroidesCuantizador)
      distancias = CuantizadorVectorial.pdistItakuraSaito(data,centroidesCuantizador);
      distMenor = min(distancias, [ ], 2);
      distGlobal = sum(distMenor);
    end

    %{
    Clasifica a una señal de voz utilizando los cuantizadores de entrada
    :param   data:
      Matriz que contiene a los vectores de autocorrelación de una señal.
      Su tamaño es mxn con m es el número de vectores, n el orden del vector
      de autocorrelación.
    :param   cuantizadores:
      Cell array que representa a los cuantizadores vectoriales.
      La primer dimensión corresponde al cuantizador de la señal iésima
      La segunda dimensión corresponde a
        1 -> Índice del grupo en el que se agrupó cada vector de autocorrelación
        2 -> Centroides del cuantizador vectorial
    %}
    function indx = clasificador(data, cuantizadores)
      % Obtiene el número de cuantizadores
      numCuantizadores = length(cuantizadores);
      % Inicializa la distancia de la señal a cada cuantizador
      distCuantizadores = zeros(1,numCuantizadores);
      for i=1:numCuantizadores
        distCuantizadores(i) = CuantizadorVectorial.distCuantizador(data,cuantizadores{i}{2});
      end
      [~,indx] = min(distCuantizadores);
    end
    
  end
end
