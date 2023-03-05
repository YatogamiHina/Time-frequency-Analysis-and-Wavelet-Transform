function [x1L, x1H1, x1H2, x1H3] = wavedbc6(x , p)
[g , h , g1 , h1] = DDWT(p);

% fprintf('g[n] = [%s]\n\n', join(string(g), ','))
% fprintf('h[n] = [%s]\n\n', join(string(h), ','))

gT = g';
hT = h';

xg = conv2(g, x);
xgT = xg';
v1L = downsample(xgT, 2)';
xh = conv2(h, x);
xhT = xh';
v1H = downsample(xhT, 2)';

v1Lg = conv2(gT, v1L);
x1L = downsample(v1Lg, 2);
v1Lh = conv2(hT, v1L);
x1H1 = downsample(v1Lh, 2);

v1Hg = conv2(gT, v1H);
x1H2 = downsample(v1Hg, 2);
v1Hh = conv2(hT, v1H);
x1H3 = downsample(v1Hh, 2);