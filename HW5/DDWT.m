function [g,h,g1,h1] = DDWT(p)
p = p/2; % 2p-point
%% step 1: P(y)
P_y = zeros(2,p);
polynomial = ''; % 用於多項式檢查

% P(y)
for k = 0:p-1
    C = factorial(p-1+k) / factorial(k) / factorial(p-1);
    P_y(1,k+1) = C; % y係數C(p-1+k k)
    P_y(2,k+1) = k; % y冪次k
    % 多項式檢查
%     if k == 0
%         polynomial = [num2str(C), 'y^',num2str(k)];
%     else
%         polynomial = [polynomial , ' + ' , num2str(C), 'y^',num2str(k)];
%     end
end

%% Step 2: P1(y)
P1 = [-.25, .5, -.25; %係數 -0.25z^-1 + 0.5z^0 - 0.25z^1
       -1 , 0 , 1];   %冪次     -1         0         1         

P1_temp = P1(1,:);
P1_list = zeros(p,2*p-1); % 0矩陣 對齊各冪次產生的多項式

middle = int8(floor(length(P1_temp)/2)); % 常數項位置 位在list正中央
P1_list(2,p-middle:p+middle) = P1_temp; % 填入0矩陣 達到多的部分補0的效果


if p-1 > 1 %確認是否有次方 避免二次方多做一次卷積
    for k = 2:p-1 % k-1次方
        P1_temp = conv(P1(1,:),P1_temp);
        middle = int8(floor(length(P1_temp)/2)); % 修正常數項位置
        P1_list(k+1,p-middle:p+middle) = P1_temp; % 填入0矩陣 達到多的部分補0的效果
    end    
end

P1_list(1,int8(length(P1_list)/2)) = 1; % 正中央為1 用於對齊常數項 以便後續可與係數直接相乘
ploy_len = length(P1_list); % 用於多項式檢查

% 乘上P(y)係數
for i = 1:length(P_y)
    P1_list(i,:) = P1_list(i,:) * P_y(1,i);
end

% 各冪次相加 得到P1(z)
P1_sum = sum(P1_list);

% 多項式檢查
% P1_result = '';
% for i = 1:ploy_len 
%     P1_result = [P1_result, num2str(P1_sum(1,i)) , 'z^' , num2str(i-p), ' + ' ];
% end
% 
% P1_result = P1_result(1:end-3); 

%% Step 3: root
r = roots(P1_sum); % 求z^k×P1(z)解 以係數解即可
r_list = [];

%% step 4: P2(z)
for i = 1:length(r)
    if abs(r(i)) < 1 % 絕對值小於1 才存入根列表
        r_list = [r_list,r(i)];
    end
end

% P2(z)的(z-z1)(z-z2)...形式
for i = 1:length(r_list)
    g_z(i,1) = 1;
    g_z(i,2) = -1 * r_list(i);
    
end

% P2(z)展開
P2 = g_z(1,:);
if length(g_z(:,1)) >= 2 % 避免只有1個根的狀況進行多項式乘法運算
    for i = 2:length(g_z(:,1))
        P2 = conv(g_z(i,:),P2);
    end
end

%% step 5: g0[n]
G_z = [1 1];
G_z_tmep = G_z;

% 求(1+z)^p的係數
for k = 1:p-1 
    G_z_tmep = conv(G_z,G_z_tmep);
end
G_z_result = G_z_tmep;

% (1+z)^p × P2(z)
g0 = conv(G_z_result,P2); 

%% step 6: Normalization
g1 = real(g0 / norm(g0));

%% step 7: Time reverse 
g = flip(g1); % g[n] = g1[-n]

% h[n] = (-1)^n × g[2p-1-n]
for i = 0:length(g)-1
    h(i+1) = (-1)^i * g(length(g) - i);
end

h1 = flip(h); % h1[n] = h[-n]
Daubechies_wavelet_list = [g; h; g1; h1];
% fprintf('g[n] = [%s]\n\n', join(string(g), ','))
% fprintf('h[n] = [%s]\n\n', join(string(h), ','))
% fprintf('g1[n] = [%s]\n\n', join(string(g1), ','))
% fprintf('h1[n] = [%s]\n\n', join(string(h1), ','))