treina = 1;
frameTime = 0.067;
gamma = 0.7;
estado = [];
prox_estado = [];
i = 1;
k = 1;
e = 0;
placarAnt = 0;
m = 1;
acao = 1;
pause(5);

iniciaJogo();

frame = screencapture(0,[2,202,640,480]);
frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.5));
frame_nave = imcrop(frame,[145 419 352 26]);
estado = double(vertcat(estado,reshape(frame_preproc,[],1)));
tic;

while(k < 4)    
    if(toc > frameTime)
        frame = screencapture(0,[2,202,640,480]);
        frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.5));
        frame_nave = imcrop(frame,[145 419 352 26]);
        estado = double(vertcat(estado,reshape(frame_preproc,[],1)));
        k = k + 1;
        tic;
    end
end

k = k + 1;

while true
    frame = screencapture(0,[2,202,640,480]);
    frame_nave = imcrop(frame,[145 419 352 26]);
    %se_menu = abs(double(frame(400,100,3)) - 127);
    if(max(max(frame_nave(:,:,1))) < 200)
        if(treina)
            numExps = length(exps);
            for l = 1:numExps
                random = randi(length(exps));
                trainSample = exps(random).get();
                disp(length(exps));
                exps(random) = [];

                retornoRedeEstado = net(trainSample.estado);
                retornoRedeProxEstado = net(trainSample.prox_estado);

                retornoRedeEstado(trainSample.acao) = trainSample.recompensa + gamma * max(retornoRedeProxEstado);

                net = train(net, trainSample.estado,retornoRedeEstado);
            end
            m = m + 1;
            if(mod(m,10) == 0)
                %save(strcat('500VezesNet',num2str(m),'.mat'),'net');
            end
            i = 1;
        end
        placarAnt = 0;
        iniciaJogo();
    elseif(max(max(frame_nave(:,:,1))) > 200)
        if(acao <= 3)
            atira();
        end
        %placarAnt = CalculaPlacar(frame);
        if(k == 5)
            if(rand < e)
                acao = randi(6);
            else
                aux = net(estado);
                acao = find(aux ==  max(aux));
            end
            k = 1;
            soltaBotoes();
            switch(acao)
                case 1
                    atira();
                    %disp('ATIRA');
                case 2
                    atira();
                    andaEsq();
                    %disp('ATIRA E ESQ');
                case 3
                    atira();
                    andaDir();
                    %disp('ATIRA E DIR');
                case 4
                    andaEsq();
                    %disp('ESQ');
                case 5
                    andaDir();
                    %disp('DIR');
            end
            prox_estado = [];
            tic;
        end

        if(toc > frameTime)
            frame = screencapture(0,[2,202,640,480]);
            frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.5));
            prox_estado = double(vertcat(prox_estado,reshape(frame_preproc,[],1)));
            k = k + 1;
            tic;
            if(k == 5)
                if(treina)
                    %{
                    penalidade = 0;
                    numVidasProxEstado = numVidas(frame); 
                    for z = 1:4
                       frame_aux = reshape(prox_estado((((z-1)*32912)+1:z*32912)),187,[]);
                       frame_nave = imcrop(frame_aux,[0 175 176 12]);
                       disp(max(max(frame_nave)));
                       if(max(max(frame_nave)) < 190)
                           penalidade = 1000;
                           break;
                       end
                    end
                    %}
                    %if(numVidasProxEstado < numVidasEstado)
                        %penalidade = 1000;
                    %end
                    %numVidasEstado = numVidasProxEstado;
                    recompensa = CalculaPlacar(frame) - placarAnt;% - penalidade;
                    %disp(recompensa);
                    placarAnt = CalculaPlacar(frame);
                    exps(i) = experience;
                    exps(i).store(estado, acao, recompensa,prox_estado);
                    i = i + 1;
                end
                estado = prox_estado;
            end
        end
    end
end