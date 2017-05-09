function num = menorDistancia( img1 )
    
    temp = img1(:,:,1) >= 90;
    [B,L] = bwboundaries(temp, 'noholes');
    stats = regionprops(L, 'Area');
    qtd_num = sum([stats.Area] > 10);
    
    if(qtd_num ~= 0)
        load('matrizes.mat');
        menor = inf;

        for i = 1:10
            diff = distanciaEuclidiana(img1,reshape(matrizes(i,6,1,:,:,:),[11,11,3]));
            if diff < menor
                numero = i;
                menor = diff;
            end
        end

        if numero == 10
            num = 0;
        else
            num = numero;
        end
    else
        num = 0;
    end;
end