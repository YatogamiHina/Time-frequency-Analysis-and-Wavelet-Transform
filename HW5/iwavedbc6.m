function x = iwavedbc6(x1L, x1H1, x1H2, x1H3 , p)
[g , h , g1 , h1] = DDWT(p);
% 
% fprintf('g1[n] = [%s]\n\n', join(string(g1), ','))
% fprintf('h1[n] = [%s]\n\n', join(string(h1), ','))

g1T = g1';
h1T = h1'; 

X1L = upsample(x1L,2);
X1H1 = upsample(x1H1,2);
x0 = conv2(X1L, g1T) + conv2(X1H1,h1T);

X1H2 = upsample(x1H2,2);
X1H3 = upsample(x1H3,2);
x1 = conv2(X1H2,g1T) + conv2(X1H3,h1T);

x0T = x0';
X0 = upsample(x0T,2)';
x1T = x1';
X1 = upsample(x1T,2)';
x_result = conv2(X0,g1) + conv2(X1,h1); 

x = x_result(p:end-p,p:end-p);