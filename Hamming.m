classdef Hamming
  methods(Static)
    
    function pot(signal, label)
      window = 511; %tamaño de la muestra -1
      padding = 170; %distancia entre muestras
      ini = 1;
      fin = ini + window;
      maxFin = length(signal);
      i = 1;
      potencia = [];
      while fin < maxFin
        muestra = signal(ini:fin);
        potencia(i) = rms(muestra)^2;
        ini = ini + padding;
        fin = ini + window;
        i = i + 1;
      end
      figure
      plot(potencia)
      title(label)
      xlabel('Bloque')
      ylabel('Potencia')
    end
    
    
    function plotBlocks(blocks, label)
      figure
      hold on
      [frec, signal_w] = spectre(blocks(5,:), 16000);
      plot(frec, signal_w)
      [frec, signal_w] = spectre(blocks(2,:), 16000);
      plot(frec, signal_w)
      [frec, signal_w] = spectre(blocks(3,:), 16000);
      plot(frec, signal_w)
      title(label)
      xlabel('f (Hz)')
      ylabel('|a(f)|')
    end
    
    
    
    function [frec, signal_w] = spectre(signal_t, Fs) %Recibe señal y frecuencia de muestreo
      double_w = fft(signal_t); %Conserva el tamaño del vector
      tam = length(double_w);
      double_w = abs(double_w);
      signal_w = double_w(1:tam/2+1); %Obtiene solo las frecuencias (izquierdas)
      frec = Fs*(0:(tam/2))/tam; %Fs determina la precisión (vector 0 a 1)*Fs
      signal_w(1)=0;
    end
    
    
    function plotSignalT(blocks,signal,label,i)
      tam = length(blocks(1,:));
      ini = 1 + 170*(i-1);
      fin = ini + 511;
      tiempo = [0:tam - 1]/16000;
      figure
      tiledlayout(1,2)
      nexttile
      plot(tiempo,blocks(i,:))
      title(strcat('Señal de audio ',label, ' con ventana de Hamming'));
      xlabel('t (s)')
      
      nexttile
      plot (tiempo, signal(ini:fin));
      title(strcat('Señal de audio ',label,' (preénfasis)'));
      xlabel('t (s)')
    end
    
    function blocks = getBlocks(signal)
      window = 511; %tamaño de la muestra -1
      padding = 170; %distancia entre muestras
      ini = 1;
      fin = ini + window;
      h = hamming(512); %Ventana de hamming, periodic añadir
      maxFin = length(signal);
      i = 1;
      blocks = [];
      while fin < maxFin
        blocks(i,:) = signal(ini:fin).*h;
        ini = ini + padding;
        fin = ini + window;
        i = i + 1;
      end
    end
  end
end