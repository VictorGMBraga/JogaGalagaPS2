function retorno = CalculaPlacar (frame)
    num0 = imcrop(frame,[208 26 10 10]);
    num1 = imcrop(frame,[195 26 10 10]);
    num2 = imcrop(frame,[182 26 10 10]);
    num3 = imcrop(frame,[169 26 10 10]);
    num4 = imcrop(frame,[156 26 10 10]);
    num5 = imcrop(frame,[143 26 10 10]);
    num6 = imcrop(frame,[130 26 10 10]);
    num7 = imcrop(frame,[117 26 10 10]);
    
    dig(8) = menorDistancia(num0);
    dig(7) = menorDistancia(num1);
    dig(6) = menorDistancia(num2);
    dig(5) = menorDistancia(num3);
    dig(4) = menorDistancia(num4);
    dig(3) = menorDistancia(num5);
    dig(2) = menorDistancia(num6);
    dig(1) = menorDistancia(num7);
    
    retorno = sum(10.^(length(dig)-1:-1:0).*dig);
end