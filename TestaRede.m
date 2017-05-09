frameTime = 0.067;
gamma = 0.7;
estado = [];
prox_estado = [];
k = 1;
acao = 1;
pause(5);
n = 1;

for n = 38:length(direc)
    m = 1;

    load(strcat('redes/',direc(n).name));
    atira();

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

    while m <= 10
        frame = screencapture(0,[2,202,640,480]);
        frame_preproc = rgb2gray(imresize(imcrop(frame,[144 72 351 372]),0.5));
        frame_nave = imcrop(frame,[145 419 352 26]);
        se_menu = abs(double(frame(400,100,3)) - 127);
        
        if(se_menu < 10)
            pontuacao(n-2,m) = CalculaPlacar(frame);
            save('pontuacoes.mat','pontuacao');
            soltaBotoes();
            atira();
            pause(3);
            m = m + 1;
        elseif(max(max(frame_nave(:,:,1))) > 200)
            if(acao <= 3)
                atira();
            end
            if(k == 5)
                aux = net(estado);
                acao = find(aux ==  max(aux));
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
                        %fdisp('DIR');
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
                    numVidasProxEstado = numVidas(frame);
                    estado = prox_estado;
                    numVidasEstado = numVidasProxEstado;
                end
            end
        end
    end
end