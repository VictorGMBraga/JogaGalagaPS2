function num = numVidas(frame)
    vidas = imcrop(frame, [144 445 46 22]);
    vidas = vidas(:,:,1) >= 90;
    [B,L] = bwboundaries(vidas, 'noholes');
    stats = regionprops(L, 'Area');
    qtd_vidas = sum([stats.Area] > 25);
    num = qtd_vidas;
end