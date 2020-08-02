clear all;
format long

% ******************************************** Datos de Entrada *******************************************

% amin:	Semieje mayor medio del planeta - Delta en semieje mayor
% diva:	Divisiones en semieje mayor
% Npl:		Numero de planetas
% paso:	Tiempo de paso en anhos
% text1:	Ruta al archivo que contiene las salidas filtradas, incluyendo el nombre del archivo
% text3:	Extension del archivo anterior

amin=1.892606292092181; 
diva=0.002083368888889;
Npl=3;
paso=1000.0/365.25; % para Kepler-9
%paso=10000.0/365.25; % para Kepler-56
text1='/media/jessi/TOSHIBA EXT/Analise_do_cluster/Kepler56_com_troianos_CI2_d_follow/follow_filtrado_sim';
text3='.txt';

% *********************************************************************************************************

for i=1:100

    if i<10
    
        text2='00';
        
    elseif i>=10 && i< 100
    
        text2='0';
        
    else
     
        text2='';
        
    end
    
    text=strcat(text1, text2, int2str(i), text3);
    disp(text)
    
    % Lectura del archivo 'i'-esimo
    
    m=load(text); 
    
    for tp=1:100
    
        emax(tp,i)=-1.0;
        N(tp,i)=0;
        w(tp,i)=0.0;
        w2(tp,i)=0.0;
        tesc(tp,i)=0.0;
        
    end
       
    % Barrido de la matriz (archivo i-esimo)
    
    for j=1:length(m)
    
        for tp=1:100
        
            if m(j,1)==tp  
                
                % Calcula la excentricidad máxima para cada tp y lo ordena en un vector columna i:
                
                if m(j,3)>emax(tp,i)
                
                    emax(tp,i)=m(j,3);
                    
                end         
                
                % Calcula la varianza de 'a' y 'e' para cada tp y lo ordena en un vector columna i:
                
                if j>(100+Npl)
                
                    % para 'a'	
                
                    z(tp,i)=(m(j,2)-m(tp+Npl,2)).^2; 
                    w(tp,i)=w(tp,i)+z(tp,i); 
                    
                    % para 'e'
                    
                    z2(tp,i)=(m(j,3)-m(tp+Npl,3)).^2; 
                    w2(tp,i)=w2(tp,i)+z2(tp,i);
                    
                    N(tp,i)=N(tp,i)+1;
                    
                    % Calcula el tiempo de escape en anhos:
                    
                    tesc(tp,i)=tesc(tp,i)+paso;
                     
                end 
                
                break;
                
            end
            
        end
        
    end
    
    for tp=1:100
    
        if N(tp,i)==0 || N(tp,i)==1
        
           % Cambiar los valores negativos a un valor adecuado dependiendo de las divisiones del colormap
           
            emax(tp,i)=-1.0;
            varianzaa(tp,i)=-200.0;
            varianzae(tp,i)=-0.2;
            
        else
        
            varianzaa(tp,i)=sqrt(w(tp,i)./(N(tp,i)-1));
            varianzae(tp,i)=sqrt(w2(tp,i)./(N(tp,i)-1));
            
        end
        
    end 
     
end

% Creando rejilla 2D

for l=1:100

    for k=1:100
    
        if k==1
        
            eini(k,l)=0.0;
            aini(l,k)=amin;        
            
        end
        
        if k>1
        
            eini(k,l)=eini(k-1,l)+0.5/99.0;
            aini(l,k)=aini(l,k-1)+diva;
            
        end 
            
    end
    
end

% Graficos

h=figure;
set(h,'Position',[100,100,700,1400])
subplot(4,1,1), pcolor(aini, eini, tesc); set(gca,'YDir','normal');
%shading flat;
shading interp;
xlabel('a_{ini} (au)');
ylabel('e_{ini}');
axis('tight')
c=colorbar;
hL = ylabel(c, 'time (yr)');
set(hL,'Rotation',90);

subplot(4,1,2), %pcolor(aini, eini, emax); set(gca,'YDir','normal');
surf(aini, eini, emax), shading interp;
xlabel('a_{ini} (au)');
ylabel('e_{ini}');
axis('tight')
view(2) 
c=colorbar;
hL = ylabel(c, 'e_{max}');
set(hL,'Rotation',90);

subplot(4,1,3), %pcolor(aini, eini, varianzaa); set(gca,'YDir','normal');
surf(aini, eini, varianzaa), shading interp;
xlabel('a_{ini} (au)');
ylabel('e_{ini}');
axis('tight')
view(2)
c=colorbar;
hL = ylabel(c, '\sigma_{a}');
set(hL,'Rotation',90);

subplot(4,1,4), %pcolor(aini, eini, varianzae); set(gca,'YDir','normal');
surf(aini,eini,varianzae), shading interp;
xlabel('a_{ini} (au)');
ylabel('e_{ini}');
axis('tight')
view(2)
c=colorbar;
hL = ylabel(c, '\sigma_{e}');
set(hL,'Rotation',90);
