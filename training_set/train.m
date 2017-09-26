load('input108.mat');
load('target650.mat');

inputs = input108';
targets = target650';
hiddenLayerSize = 39;

net = patternnet(hiddenLayerSize);

net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};

net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

net.trainFcn = 'trainscg';  % Scaled conjugate gradient % LM

net.performFcn = 'mse';  % Mean squared error %Performance Function

net.efficiency.memoryReduction = 100;
net.trainParam.max_fail = 6;
net.trainParam.min_grad=1e-6;
net.trainParam.show=25;
net.trainParam.lr=0.9;
net.trainParam.epochs=1000;
net.trainParam.goal=0.00;

% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);

% Recalculate Training and Test Performance
trainTargets = targets .* tr.trainMask{1};

testTargets = targets  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,outputs);

testPerformance = perform(net,testTargets,outputs);

% View the Network
view(net)

disp('after training')

save   C:\Users\User\Desktop\hand\training_set\net net;


%net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
% 'plotregression', 'plotfit'};
% Plots
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, plotconfusion(targets,outputs)
%figure, plotroc(targets,outputs)
%figure, ploterrhist(errors)