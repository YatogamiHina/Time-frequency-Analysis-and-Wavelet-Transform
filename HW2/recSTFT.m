function y =recSTFT(x,t,f,B)
dt = t(2) - t(1);
df = f(2) - f(1);

N = round(1/(dt*df));
n = round(t./dt); 
t_len = length(n);

m = round(f./df); 
f_len = length(m);

Q = round(B/dt);

X = zeros(t_len,f_len);
t_s = zeros(1,t_len);
f_s = zeros(1,f_len);
x = [x,0];

zeropad= zeros(1, N-2*Q-1);
q = [0:2*Q];

for a = 1:t_len 
    P = round(n(a) - Q + q); 
    P(P < 1) = t_len + 1; 
    P(P > t_len) = t_len + 1;

    x1 = [x(P),zeropad];   
    X1 = fft(x1, N);

    for b = 1:f_len
        m_temp = mod(m(b),N)+1;
        X2(a,b) = X1(1,m_temp) * exp(i * 2 * pi * (Q-n(a)) * m(b) / N) * dt;
    end
end

t_s(1,:) = n * dt;
f_s(1,:) = m * df;
y = X2';

image(t_s, f_s, abs(y)/max(max(abs(y)))*400);
colormap(gray(256));
set(gca, 'Ydir', 'normal');