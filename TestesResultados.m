%{
%==================  100 vezes salvando todas as redes=======%
net = feedforwardnet(440);
net.trainFcn = 'trainscg';
net.divideFcn = '';
net.trainParam.showWindow = false;
net = configure(net,A,B);
net.trainParam.epochs = 1;

treina = 1;
frameTime = 0.067;
gamma = 0.7;
%exps = experience;
estado = [];
prox_estado = [];
i = 1;
k = 1;
e = 0.1;
m = 1;
acao = 1;
pause(5);
pontuacao = zeros(100);

frame = screencapture(0,[2,202,640,480]);
frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
frame_nave = imcrop(frame,[145 419 352 26]);
estado = double(vertcat(estado,reshape(frame_preproc,[],1)));
tic;

while(k < 4)    
    if(toc > frameTime)
        frame = screencapture(0,[2,202,640,480]);
        frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
        frame_nave = imcrop(frame,[145 419 352 26]);
        estado = double(vertcat(estado,reshape(frame_preproc,[],1)));        
        k = k + 1;
        tic;
    end
end
numVidasEstado = numVidas(frame);
placarAnt = CalculaPlacar(frame);
k = k + 1;
while m < 100
    frame = screencapture(0,[2,202,640,480]);
    frame_nave = imcrop(frame,[145 419 352 26]);
    se_menu = abs(double(frame(400,100,3)) - 127);

    if(se_menu < 10)
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
            save(strcat('100VezesNet',num2str(m),'.mat'),'net'); 
            pontuacao(m) = CalculaPlacar(frame);
            m = m + 1;
            i = 1;
        end
        atira();
    elseif(max(max(frame_nave(:,:,1))) > 200)
        if(acao <= 3)
            atira();
        end
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
                case 2
                    atira();
                    andaEsq();
                case 3
                    atira();
                    andaDir();
                case 4
                    andaEsq();
                case 5
                    andaDir();
            end
            prox_estado = [];
            frame_prox_estado= [];
            tic;
        end

        if(toc > frameTime)
            frame = screencapture(0,[2,202,640,480]);
            frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
            %set(im,'CData', frame_preproc);
            %drawnow;
            frame_nave = imcrop(frame,[145 419 352 26]);
            %frame_prox_nave(k) = frame_nave;
            prox_estado = double(vertcat(prox_estado,reshape(frame_preproc,[],1)));
            k = k + 1;
            tic;
            if(k == 5)
                if(treina)
                    penalidade = 0;
                    numVidasProxEstado = numVidas(frame); 
                    if(numVidasProxEstado < numVidasEstado)
                        penalidade = 1000;
                    end
                    numVidasEstado = numVidasProxEstado;
                    recompensa = CalculaPlacar(frame) - placarAnt - penalidade;
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
save('100VezesPontuacao.mat','pontuacao');
%========================================================================================================





% =============50 vezes jogando 10 vezes por treino ======================%

net = feedforwardnet(440);
net.trainFcn = 'trainscg';
net.divideFcn = '';
net.trainParam.showWindow = false;
net = configure(net,A,B);
net.trainParam.epochs = 1;


treina = 1;
frameTime = 0.067;
gamma = 0.7;
estado = [];
prox_estado = [];
i = 1;
k = 1;
e = 0.1;
pause(5);
pontuacao = zeros(100);
n = 1;
m = 1;
frame = screencapture(0,[2,202,640,480]);
frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
frame_nave = imcrop(frame,[145 419 352 26]);
estado = double(vertcat(estado,reshape(frame_preproc,[],1)));
tic;

while(k < 4)    
    if(toc > frameTime)
        frame = screencapture(0,[2,202,640,480]);
        frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
        frame_nave = imcrop(frame,[145 419 352 26]);
        estado = double(vertcat(estado,reshape(frame_preproc,[],1)));        k = k + 1;
        tic;
    end
end
numVidasEstado = numVidas(frame);
placarAnt = CalculaPlacar(frame);
k = k + 1;
while m < 50
    frame = screencapture(0,[2,202,640,480]);
    frame_nave = imcrop(frame,[145 419 352 26]);
    se_menu = abs(double(frame(400,100,3)) - 127);

    if(se_menu < 10)
        n = n + 1; 
        if(treina && n > 10)
            n = 1;
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
            save(strcat('10JogosPorVezNet',num2str(m),'.mat'),'net'); 
            pontuacao(m) = CalculaPlacar(frame);
            m = m + 1;
            i = 1;
        end
        atira();
    elseif(max(max(frame_nave(:,:,1))) > 200)
        if(acao <= 3)
            atira();
        end
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
                case 2
                    atira();
                    andaEsq();
                case 3
                    atira();
                    andaDir();
                case 4
                    andaEsq();
                case 5
                    andaDir();
            end
            prox_estado = [];
            tic;
        end

        if(toc > frameTime)
            frame = screencapture(0,[2,202,640,480]);
            frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
            prox_estado = double(vertcat(prox_estado,reshape(frame_preproc,[],1)));
            k = k + 1;
            tic;
            if(k == 5)
                if(treina)
                    penalidade = 0;
                    numVidasProxEstado = numVidas(frame); 
                    if(numVidasProxEstado < numVidasEstado)
                        penalidade = 1000;
                    end
                    numVidasEstado = numVidasProxEstado;
                    recompensa = CalculaPlacar(frame) - placarAnt - penalidade;
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
save('10JogosPorVezPontuacao.mat','pontuacao');

% =========================================================================

%=============== 100 vezes mudando o frameskiping ========================
net = feedforwardnet(440)
net.trainFcn = 'trainscg'
net.divideFcn = ''
net.trainParam.showWindow = false
net = configure(net,A,B)
net.trainParam.epochs = 1

treina = 1;
frameTime = 0.067;
gamma = 0.7;
estado = [];
prox_estado = [];
i = 1;
k = 1;
e = 0.1;
pause(5);
pontuacao = zeros(100);
n = 1;
m = 1;
frame = screencapture(0,[2,202,640,480]);
frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
frame_nave = imcrop(frame,[145 419 352 26]);
estado = double(vertcat(estado,reshape(frame_preproc,[],1)));
tic;

while(k < 4)    
    if(toc > frameTime)
        frame = screencapture(0,[2,202,640,480]);
        frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
        frame_nave = imcrop(frame,[145 419 352 26]);
        estado = double(vertcat(estado,reshape(frame_preproc,[],1)));        k = k + 1;
        tic;
    end
end
numVidasEstado = numVidas(frame);
placarAnt = CalculaPlacar(frame);
k = k + 1;
for n = 1:4
    frameTime = 0.017* n;
    while m < 100
        frame = screencapture(0,[2,202,640,480]);
        frame_nave = imcrop(frame,[145 419 352 26]);
        se_menu = abs(double(frame(400,100,3)) - 127);

        if(se_menu < 10)
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
                save(strcat('100VezesNet',num2str(m),'Frameskipping',num2str(n),'.mat'),'net'); 
                pontuacao(m) = CalculaPlacar(frame);
                m = m + 1;
                i = 1;
            end
            atira();
        elseif(max(max(frame_nave(:,:,1))) > 200)
            if(acao <= 3)
                atira();
            end
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
                    case 2
                        atira();
                        andaEsq();
                    case 3
                        atira();
                        andaDir();
                    case 4
                        andaEsq();
                    case 5
                        andaDir();
                end
                prox_estado = [];
                tic;
            end

            if(toc > frameTime)
                frame = screencapture(0,[2,202,640,480]);
                frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
                prox_estado = double(vertcat(prox_estado,reshape(frame_preproc,[],1)));
                k = k + 1;
                tic;
                if(treina)
                    penalidade = 0;
                    numVidasProxEstado = numVidas(frame); 
                    if(numVidasProxEstado < numVidasEstado)
                        penalidade = 1000;
                    end
                    numVidasEstado = numVidasProxEstado;
                    recompensa = CalculaPlacar(frame) - placarAnt - penalidade;
                    placarAnt = CalculaPlacar(frame);
                    exps(i) = experience;
                    exps(i).store(estado, acao, recompensa,prox_estado);
                    i = i + 1;
                end
            end
        end
    end
    save(strcat('100VezesFrameSkipping',num2str(n),'.mat'),'pontuacao');
end

%=========================================================================
% Mudando o numero de neuronios intermediarios
net = feedforwardnet(440);
net.trainFcn = 'trainscg';
net.divideFcn = '';
net.trainParam.showWindow = false;
net = configure(net,A,B);
net.trainParam.epochs = 1;

treina = 1;
frameTime = 0.067;
gamma = 0.7;
estado = [];
prox_estado = [];
i = 1;
k = 1;
e = 0.1;
pause(5);
pontuacao = zeros(100);
n = 1;
m = 1;
frame = screencapture(0,[2,202,640,480]);
frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
frame_nave = imcrop(frame,[145 419 352 26]);
estado = double(vertcat(estado,reshape(frame_preproc,[],1)));
tic;

while(k < 4)    
    if(toc > frameTime)
        frame = screencapture(0,[2,202,640,480]);
        frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
        frame_nave = imcrop(frame,[145 419 352 26]);
        estado = double(vertcat(estado,reshape(frame_preproc,[],1)));        k = k + 1;
        tic;
    end
end
numVidasEstado = numVidas(frame);
placarAnt = CalculaPlacar(frame);
k = k + 1;
for n = 1:4
    net = feedforwardnet(300 + 60*n);
    net.trainFcn = 'trainscg';
    net.divideFcn = '';
    net.trainParam.showWindow = false;
    net = configure(net,A,B);
    net.trainParam.epochs = 1;
    while m < 100
        frame = screencapture(0,[2,202,640,480]);
        frame_nave = imcrop(frame,[145 419 352 26]);
        se_menu = abs(double(frame(400,100,3)) - 127);

        if(se_menu < 10)
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
                save(strcat('RedeCom',num2str(n),'Neuronios',num2str(m),'.mat'),'net'); 
                pontuacao(m) = CalculaPlacar(frame);
                m = m + 1;
                i = 1;
            end
            atira();
        elseif(max(max(frame_nave(:,:,1))) > 200)
            if(acao <= 3)
                atira();
            end
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
                    case 2
                        atira();
                        andaEsq();
                    case 3
                        atira();
                        andaDir();
                    case 4
                        andaEsq();
                    case 5
                        andaDir();
                end
                prox_estado = [];
                tic;
            end

            if(toc > frameTime)
                frame = screencapture(0,[2,202,640,480]);
                frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
                prox_estado = double(vertcat(prox_estado,reshape(frame_preproc,[],1)));
                k = k + 1;
                tic;
                if(k == 5)
                    if(treina)
                        penalidade = 0;
                        numVidasProxEstado = numVidas(frame); 
                        if(numVidasProxEstado < numVidasEstado)
                            penalidade = 1000;
                        end
                        numVidasEstado = numVidasProxEstado;
                        recompensa = CalculaPlacar(frame) - placarAnt - penalidade;
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
    save(strcat('RedeCom',num2str(300 + 60*n),'NeuroniosPlacar.mat'),'pontuacao');
end
%}
%=========================================================================
% 1000 com frame reduzido pela metade
net = feedforwardnet(440);
net.trainFcn = 'trainscg';
net.divideFcn = '';
net.trainParam.showWindow = false;
net = configure(net,A,B);
net.trainParam.epochs = 1;

treina = 1;
frameTime = 0.016;
gamma = 0.7;
estado = [];
prox_estado = [];
i = 1;
k = 1;
e = 0.1;
pause(5);
pontuacao = zeros(100);
n = 1;
m = 1;
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
numVidasEstado = numVidas(frame);
placarAnt = CalculaPlacar(frame);
k = k + 1;

while m <= 1000
    frame = screencapture(0,[2,202,640,480]);
    frame_nave = imcrop(frame,[145 419 352 26]);
    se_menu = abs(double(frame(400,100,3)) - 127);

    if(se_menu < 10)
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
            if(mod(m,10) == 0)
                save(strcat('1000VezesNet1Frame',num2str(m),'.mat'),'net'); 
            end
            pontuacao(m) = CalculaPlacar(frame);
            m = m + 1;
            i = 1;
        end
        atira();
    elseif(max(max(frame_nave(:,:,1))) > 200)
        if(acao <= 3)
            atira();
        end
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
                case 2
                    atira();
                    andaEsq();
                case 3
                    atira();
                    andaDir();
                case 4
                    andaEsq();
                case 5
                    andaDir();
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
                    penalidade = 0;
                    numVidasProxEstado = numVidas(frame); 
                    if(numVidasProxEstado < numVidasEstado)
                        penalidade = 1000;
                    end
                    numVidasEstado = numVidasProxEstado;
                    recompensa = CalculaPlacar(frame) - placarAnt - penalidade;
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
save(strcat('1000VezesNetPlacar1Frame.mat'),'pontuacao');