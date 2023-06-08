clear; clc; close all
hold on
%% Creating charge 1
value = -10e-6;        % Valor carga negativa
position=[1 -1 0];     % Posicion inicial carga negativa
q1=value; r1=position; % Carga negativa del dipolo
colors={[255,87,51]/255,[93,173,226]/255};  % Color azul para la carga
% because q1<0;
c1=2;     
%% Creating charge 2
value=-q1;             % Valor carga positiva
position=[-1 1 0];     % Posicion inicial carga positiva
q2=value; r2=position; % Carga positiva del dipolo
% because q2>0;
c2=1;
%% Plotting charges
plotq1 = plot3(r1(1),r1(2),r1(3),'.','MarkerSize',30,'Color',colors{c1}); % Mostrar carga negativa
plotq2 = plot3(r2(1),r2(2),r2(3),'.','MarkerSize',30,'Color',colors{c2}); % Mostrar carga positiva
xlim([-5 5]);    % Limite campo eje x
ylim([-5 5]);    % Limite campo eje y
text(r2(1),r2(2),r2(3),[num2str(q2*1e6,'%.2f'),' \muC']);   % Mostrar en el gráfico el valor de la carga positiva
text(r1(1),r1(2),r1(3),[num2str(q1*1e6,'%.2f'),' \muC']);   % Mostrar en el gráfico el valor de la carga negativa

%% Torque
for t = 0:0.5:20      % La amplitud y duración de la onda 
    if t>0         % Eliminar el campo anterior
        delete(field)
    end
    qs(1)= 1; % Valor de la carga, utilizamos valores 1 en vez de un valor 
              % inferior para que tenga más fuerza el campo
    rs(2,:) = 1e3*[1 cos(t) 0];  % La trayectoria de la carga positiva
                                 % La distancia en x tiene que ser constante 
                                 % porque sino el campo electrico va a ir
                                 % disminuyendo a medida que la distancia va creciendo.          
    qs(2)= (-1);
    rs(1,:) = 1e3*[-1 cos(t+(pi/2)) 0];  % La trayectoria de la carga negativa
                                         % Pi/2 indica el desfase de la
                                         % carga negativa para que empiece
                                         % a oscilar
    
    % Electric field
    [X,Y]= meshgrid (linspace(-5,5,95));
    d= 0.001;   % Distancia al origen 
    Z= d*ones(size(X));
    R= [X(:) Y(:) Z(:)];
    Et= zeros(size(R));
    for i=1:length(qs)   % Crear el campo electrico
        Et= Et + electricField(rs(i,:),R,qs(i));
    end
    Ex=reshape(Et(:,1), size(X));
    Ey=reshape(Et(:,2), size(X));
    field = streamslice(X,Y,Ex,Ey); axis tight
    view(2)    % Ver en 2D el plano
    
    amount_mov = 100;   % Determinamos un valor inicial para que empiece el bucle
    while abs(amount_mov) > 1e-4    % Utilizamos el valor absoluto del torque 
                                    % para que reitere hasta que disminuya
                                    % y el dipolo quede apreciablemente
                                    % inmóvil
        p = (r2 - r1);   % Vector posición
        E=Et(1,:);      % Campo eléctrico actualizado en cada reiteración
        torque = cross(p, E);  % Calcular el torque a partir de la posición
                               % y el campo
        direction_r1 = [p(2), -p(1), 0];    % Dirección de la carga
        d_r1 = direction_r1 / norm(direction_r1); % Normalizar el vector 
                                                  % dirección
        amount_mov = torque(3);  % Debido al producto vectorial trabajaremos
                                 % con el valor en z 
        % Representar el movimiento en cada paso
          % La carga positiva se aleja del campo eléctrico (en nuestra
          % representación se observa que la partícula positiva se sitúa en
          % el extremo de la flecha). Mientras que la carga negativa se atrae (y
          % se sitúa en el orígen). 
        plotq1.XData = plotq1.XData + amount_mov* d_r1(1);
        plotq1.YData = plotq1.YData + amount_mov* d_r1(2);
        plotq2.XData = plotq2.XData - amount_mov* d_r1(1);
        plotq2.YData = plotq2.YData - amount_mov* d_r1(2);
        % Actualizar la posición del dipolo
        r1(1) = plotq1.XData;
        r1(2) = plotq1.YData;
        r2(1) = plotq2.XData;
        r2(2) = plotq2.YData;
        % Añadimos pequeñas pausas para apreciar mejor el recorrido de las
        % cargas
        pause(1e-6)
    end
end




