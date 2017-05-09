pause(5);
pontuacao = zeros(249);

%for n = 3:length(dir)
%    load(strcat('redes/',dir(n).name));
    load('100VezesNet99.mat');
    %disp(dir(n).name);
    frameTime = 0.067;
    gamma = 0.7;
    estado = [];
    prox_estado = [];
    i = 1;
    k = 1;
    e = 0;
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
            estado = double(vertcat(estado,reshape(frame_preproc,[],1)));        
            k = k + 1;
            tic;
        end
    end

    k = k + 1;

    while m < 5
        frame = screencapture(0,[2,202,640,480]);
        frame_nave = imcrop(frame,[145 419 352 26]);
        se_menu = abs(double(frame(400,100,3)) - 127);

        if(se_menu < 10)
            m = m + 1;
            if(pontuacao(n) < CalculaPlacar(frame))
                pontuacao(n) = CalculaPlacar(frame);
            end
            atira();
            disp(m);
            pause(3);
        elseif(max(max(frame_nave(:,:,1))) > 200)
            placarAnt = CalculaPlacar(frame);
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
            if(acao <= 3)
                atira();
            end
            if(toc > frameTime)
                frame = screencapture(0,[2,202,640,480]);
                frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.25));
                prox_estado = double(vertcat(prox_estado,reshape(frame_preproc,[],1)));
                k = k + 1;
                tic;
                if(k == 5)
                    estado = prox_estado;
                end
            end
        end
    end
%end
