function net = proj6_part2_cnn_init(varargin)
% Retrain imagenet-vgg-f model for binary classification of 
% pedestrians. First, restructure network.

opts.piecewise = 1;
opts.modelPath = fullfile('imagenet-vgg-f.mat');
opts = vl_argparse(opts, varargin) ;
display(opts) ;

net = load(opts.modelPath);

net.layers = net.layers(1:end-2);
f=1/100; 

% Add dropout layers
fc6p = find(cellfun(@(a) strcmp(a.name, 'fc6'), net.layers)==1);
fc7p = find(cellfun(@(a) strcmp(a.name, 'fc7'), net.layers)==1);

drop6 = struct('type', 'dropout', 'rate', 0.5, 'name', 'drop6');
drop7 = struct('type', 'dropout', 'rate', 0.5, 'name', 'drop7');
net.layers = [net.layers(1:fc6p) drop6 net.layers(fc6p+1:fc7p) drop7 net.layers(fc7p+1:end)];

% fc8 layer
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(1,1,10,2, 'single'), zeros(1, 15, 'single')}}, ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'name', 'fc8') ;
                      
% Loss layer
net.layers{end+1} = struct('type', 'softmaxloss', 'name', 'softmaxloss') ;

% Fill in rest
net = vl_simplenn_tidy(net);

vl_simplenn_display(net, 'inputSize', [64 64 1 50])
