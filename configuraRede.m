net = feedforwardnet(440)
net.trainFcn = 'trainscg'
net.divideFcn = ''
net.trainParam.showWindow = false
net = configure(net,A,B)
net.trainParam.epochs = 1