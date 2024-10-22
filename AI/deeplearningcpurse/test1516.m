X = zeros(5, 5, 5); 
X(:, :, 1) = [1 0 0 0 1; 0 1 0 1 0; 0 0 1 0 0; 0 1 0 1 0; 1 0 0 0 1]; % 第1个输入样本
X(:, :, 2) = [0 1 1 1 0; 1 0 0 0 1; 1 0 0 0 1; 1 0 0 0 1; 0 1 1 1 0]; % 第2个输入样本
X(:, :, 3) = [1 1 1 1 1; 0 0 0 0 1; 1 1 1 1 1; 1 0 0 0 0; 1 1 1 1 1]; % 第3个输入样本
X(:, :, 4) = [1 1 1 1 1; 1 0 0 0 0; 1 1 1 1 1; 0 0 0 0 1; 1 1 1 1 1]; % 第4个输入样本
X(:, :, 5) = [1 0 0 0 1; 0 1 0 1 0; 0 0 1 0 0; 0 1 0 1 0; 1 0 0 0 1]; % 第5个输入样本


D = [1 0 0 0 0; 
     0 1 0 0 0; 
     0 0 1 0 0; 
     0 0 0 1 0; 
     0 0 0 0 1]; 


W1 = 2 * rand(20, 25) - 1; 
W2 = 2 * rand(20, 20) - 1; 
W3 = 2 * rand(20, 20) - 1; 
W4 = 2 * rand(5, 20) - 1;  
% 训练1万轮
for epoch = 1:10000
    [W1, W2, W3, W4] = DeepDropoutReLU(W1, W2, W3, W4, X, D);
end

% 计算训练后的输出
for k = 1:5
    x = reshape(X(:, :, k), 25, 1);
    y1 = ReLU(W1 * x);       
    y1 = y1 .* Dropout(y1, 0.2); 
    y2 = ReLU(W2 * y1);      
    y2 = y2 .* Dropout(y2, 0.2); 
    y3 = ReLU(W3 * y2);      
    y = Softmax(W4 * y3);   
    disp(['Sample ', num2str(k), ': ', num2str(y')]);
end

% ReLU激活函数
function y = ReLU(x)
    y = max(0, x);
end

% DeepDropoutReLU主函数，更新权值
function [W1, W2, W3, W4] = DeepDropoutReLU(W1, W2, W3, W4, X, D)
    alpha = 0.05;
    for k = 1:5
        x = reshape(X(:, :, k), 25, 1);
        v1 = W1 * x;    y1 = ReLU(v1); 
        y1 = y1 .* Dropout(y1, 0.2); 
        v2 = W2 * y1;   y2 = ReLU(v2); 
        y2 = y2 .* Dropout(y2, 0.2); 
        v3 = W3 * y2;   y3 = ReLU(v3); 
        v = W4 * y3;    y = Softmax(v); 
        
        d = D(k, :)';   e = d - y;     
        delta = e;     
        
        e3 = W4' * delta;  delta3 = (v3 > 0) .* e3;
        e2 = W3' * delta3; delta2 = (v2 > 0) .* e2;
        e1 = W2' * delta2; delta1 = (v1 > 0) .* e1;
        W1 = W1 + alpha * delta1 * x';
        W2 = W2 + alpha * delta2 * y1';
        W3 = W3 + alpha * delta3 * y2';
        W4 = W4 + alpha * delta * y3';
    end
end

% Softmax函数
function y = Softmax(x)
    exp_x = exp(x - max(x)); 
    y = exp_x / sum(exp_x);
end

% Dropout函数
function y = Dropout(y, ratio)
    mask = rand(size(y)) > ratio;
    y = y .* mask;
end
