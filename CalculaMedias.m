for i = 1:50
     media = 0;
    for j = 1:10
    	media = media + pontuacao(i,j);
    end
    media = media / 10;
    pontuacao(i,11) = media;
end