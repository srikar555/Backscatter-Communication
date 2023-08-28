clc
clear
close all
global num_inst ;
num_inst = 1e3;
num_iter = 10;
mse_chn_coef = 100; % #channel coefficient to consider for MSE
M=3; %num antennas
h_var = 1;
f_var = 1;
g_var = 1;
%noise_var = 1;
snr = 10; % dB
SNR = -20:5:20;
t1 = 1*randsrc(1,1,[1,1j,-1,-1j]); % QPSK SYMBOLS
s1 = 1;
t2 = 1*randsrc(1,1,[1,1j,-1,-1j]);
s2 =-1;
eta=1;
mse_vec_a = zeros(1,num_iter);
mse_vec_h = mse_vec_a;
mse_vec_Q = mse_vec_a;
mse_vec_G = mse_vec_a;
mse_snr_a=zeros(1,length(SNR));
mse_snr_h = mse_snr_a;
mse_snr_Q = mse_snr_h;
mse_snr_G = mse_snr_Q;
h = sqrt(h_var/2).*randn(M,num_inst)+1j.*sqrt(h_var/2).*randn(M,num_inst);
f = sqrt(f_var/2).*randn(1,num_inst)+1j.*sqrt(f_var/2).*randn(1,num_inst);
g = sqrt(g_var/2).*randn(M,num_inst)+1j.*sqrt(g_var/2).*randn(M,num_inst);
%w1 = sqrt(noise_var/2).*randn(M,num_inst)+1j.*sqrt(noise_var/2).*randn(M,num_inst);
%w2 = sqrt(noise_var/2).*randn(M,num_inst)+1j.*sqrt(noise_var/2).*randn(M,num_inst);
a=f.*g  ;
y1 = awgn(h.*t1 + eta*s1*t1.*a,snr);
y2 = awgn(h.*t2 + eta*s2*t2.*a,snr);
a_hat = MMSE(y1,a); % a_hat FROM SINGLE PILOT
h_hat = MMSE(y1,h); % h_hat FROM SINGLE PILOT
mse_vec_a(1) = MSE(a(:,1:mse_chn_coef),a_hat(:,1:mse_chn_coef)); 
mse_vec_h(1) = MSE(h(:,1:mse_chn_coef),h_hat(:,1:mse_chn_coef)); 
y21 = t1*y2 - t2*y1; % LINEAR COMBINATION
a_hat = MMSE(y21,a); % a_hat FROM LINEAR COMBINATION
mse_vec_a(2) = MSE(a(:,1:mse_chn_coef),a_hat(:,1:mse_chn_coef));
tempy1 = y1 - eta*s1*t1.*a_hat; % USING a_hat TO ESTIMATE h_hat
h_hat = MMSE(tempy1,h);
mse_vec_h(2) = MSE(h(:,1:mse_chn_coef),h_hat(:,1:mse_chn_coef));
 for jj=3:length(mse_vec_h)
    tempy1 = y1 - t1.*h_hat;
    a_hat = MMSE(tempy1,a);
    tempy1 = y1 - eta*s1*t1.*a_hat;
    h_hat = MMSE(tempy1,h);
    mse_vec_a(jj) = MSE(a(:,1:mse_chn_coef),a_hat(:,1:mse_chn_coef));
    mse_vec_h(jj) = MSE(h(:,1:mse_chn_coef),h_hat(:,1:mse_chn_coef));
 end
figure(1)
semilogy(1:length(mse_vec_h),mse_vec_a);
hold on
semilogy(1:length(mse_vec_h),mse_vec_h);




for ii=1:length(SNR)
y1 = awgn(h.*t1 + eta*s1*t1.*a,SNR(ii));
y2 = awgn(h.*t2 + eta*s2*t2.*a,SNR(ii));  
y21 = t1*y2 - t2*y1; % LINEAR COMBINATION
a_hat = MMSE(y21,a); % a_hat FROM LINEAR COMBINATION
tempy1 = y1 - eta*s1*t1.*a_hat; % USING a_hat TO ESTIMATE h_hat
h_hat = MMSE(tempy1,h);
% tempy1 = y1 - t1.*h_hat;
% a_hat = MMSE(tempy1,a);
% tempy1 = y1 - eta*s1*t1.*a_hat;
% h_hat = MMSE(tempy1,h);
mse_snr_a(ii) = MSE(a(:,1:mse_chn_coef),a_hat(:,1:mse_chn_coef));
%tempy1 = y1 - eta*s1*t1.*a; % USING a_hat TO ESTIMATE h_hat
%h_hat = MMSE(tempy1,h);
mse_snr_h(ii) = MSE(h(:,1:mse_chn_coef),h_hat(:,1:mse_chn_coef));
end
figure(2)
semilogy(SNR,mse_snr_a);
hold on
semilogy(SNR,mse_snr_h);
Q_var =1/3;
Q = sqrt(Q_var/2).*randn(M,M*num_inst) +1j.*sqrt(Q_var/2).*randn(M,M*num_inst);
disp(covar(Q,Q'))
R = [1 0 0 0;0 1 0 0;0 0 1 1];
s = [1 1 1 -1];
G = [];
for ii =1:num_inst
    g = sqrt(g_var/2).*randn(M,1)+1j.*sqrt(g_var/2).*randn(M,1);
    G = [G g*transpose(g)];
end

Q_hat = zeros(size(Q));
G_hat=zeros(size(G));
q1 = Q;
q1 = Q(:,1:M:end); %every 1,4,7 ... col
q2 = Q(:,2:M:end); % every 2,5,8....
q3 = Q(:,3:M:end); %every 3,6,9 ....
g1 = G(:,1:M:end);
g2 = G(:,2:M:end);
g3 = G(:,3:M:end);
y1 = awgn((q1 + eta*s(1).*g1),snr,'measured');
y2 = awgn((q2 + eta*s(2).*g2),snr,'measured');
y3 = awgn((q3 + eta*s(3).*g3),snr,'measured');
y4 = awgn((q3 + eta*s(4).*g3),snr,'measured');
%% first iteration
q1_hat = MMSE(y1,q1);
q2_hat = MMSE(y2,q2);
q3_hat = MMSE(y3,q3);
g3_hat = MMSE(y3,g3);
g33_hat = sqrt(g3(3,:)); % row vector
g22_hat = g3(2,:) ./ g33_hat; %row_vec
g11_hat = g3(1,:) ./ g33_hat; %row_vec
g2_hat = [g11_hat.*g22_hat;g22_hat.^2;g33_hat.*g22_hat];
g1_hat = [g11_hat.^2;g22_hat.*g11_hat;g33_hat.*g11_hat];
G_hat(:,1:M:end) = g1_hat;
G_hat(:,2:M:end) = g2_hat;
G_hat(:,3:M:end) = g3_hat;
Q_hat(:,1:M:end) = q1_hat;
Q_hat(:,2:M:end) = q2_hat;
Q_hat(:,3:M:end) = q3_hat;
mse_vec_Q(1) = MSE(Q,Q_hat);
mse_vec_G(1) = MSE(G,G_hat);
%% second iteration
y3p4 = y3 + y4;
y3m4 = y3 - y4;
q3_hat = MMSE(y3p4,q3);
g3_hat = MMSE(y3m4,g3);
g33_hat = sqrt(g3(3,:)); % row vector
g22_hat = g3(2,:) ./ g33_hat; %row_vec
g11_hat = g3(1,:) ./ g33_hat; %row_vec
g2_hat = [g11_hat.*g22_hat;g22_hat.^2;g33_hat.*g22_hat];
g1_hat = [g11_hat.^2;g22_hat.*g11_hat;g33_hat.*g11_hat];
tempy2 = y2 - eta*s(2).*g2_hat;
q2_hat = MMSE(tempy2,q2);
tempy1 = y1 - eta*s(1).*g1_hat;
q1_hat = MMSE(tempy1,q1);
G_hat(:,1:M:end) = g1_hat;
G_hat(:,2:M:end) = g2_hat;
G_hat(:,3:M:end) = g3_hat;
Q_hat(:,1:M:end) = q1_hat;
Q_hat(:,2:M:end) = q2_hat;
Q_hat(:,3:M:end) = q3_hat;
mse_vec_Q(2) = MSE(Q,Q_hat);
mse_vec_G(2) = MSE(G,G_hat);
%% 3rd 4th .... iterations
for ii=3:num_iter
   
    tempy1 = y1 - q1_hat;
    tempy2 = y2 - q2_hat;
    tempy3 = y3 - q3_hat;
    g1_hat = MMSE(tempy1,g1);
    g2_hat = MMSE(tempy2,g2);
    g3_hat = MMSE(tempy3,g3);
     tempy1 = y1 - eta*s(1).*g1_hat;
    tempy2 = y2 - eta*s(2).*g2_hat;
    tempy3 = y3 - eta*s(3).*g3_hat;
    q1_hat = MMSE(tempy1,q1);
    q2_hat = MMSE(tempy2,q2);
    q3_hat = MMSE(tempy3,q3);
    G_hat(:,1:M:end) = g1_hat;
    G_hat(:,2:M:end) = g2_hat;
    G_hat(:,3:M:end) = g3_hat;
    Q_hat(:,1:M:end) = q1_hat;
    Q_hat(:,2:M:end) = q2_hat;
    Q_hat(:,3:M:end) = q3_hat;
    mse_vec_Q(ii) = MSE(Q,Q_hat);
    mse_vec_G(ii) = MSE(G,G_hat);
end
figure(1)
semilogy(1:num_iter,mse_vec_Q);
semilogy(1:num_iter,mse_vec_G);
legend('a : f * g: LU-BD-AP','h : LU-AP','Q : AP-AP', 'G: AP-BD-AP');
xlabel('iteration index');
ylabel('log (MSE)')
title(string(snr)+" dB SNR")
hold off
%% vs snr
for ii =1:length(SNR)
y1 = awgn((q1 + eta*s(1).*g1),SNR(ii),'measured');
y2 = awgn((q2 + eta*s(2).*g2),SNR(ii),'measured');
y3 = awgn((q3 + eta*s(3).*g3),SNR(ii),'measured');
y4 = awgn((q3 + eta*s(4).*g3),SNR(ii),'measured');
y3m4 = y3 - y4;
q3_hat = MMSE(y3p4,q3);
g3_hat = MMSE(y3m4,g3);
g33_hat = sqrt(g3(3,:)); % row vector
g22_hat = g3(2,:) ./ g33_hat; %row_vec
g11_hat = g3(1,:) ./ g33_hat; %row_vec
g2_hat = [g11_hat.*g22_hat;g22_hat.^2;g33_hat.*g22_hat];
g1_hat = [g11_hat.^2;g22_hat.*g11_hat;g33_hat.*g11_hat];
tempy2 = y2 - eta*s(2).*g2_hat;
q2_hat = MMSE(tempy2,q2);
tempy1 = y1 - eta*s(1).*g1_hat;
q1_hat = MMSE(tempy1,q1);
G_hat(:,1:M:end) = g1_hat;
G_hat(:,2:M:end) = g2_hat;
G_hat(:,3:M:end) = g3_hat;
Q_hat(:,1:M:end) = q1_hat;
Q_hat(:,2:M:end) = q2_hat;
Q_hat(:,3:M:end) = q3_hat;
mse_snr_Q(ii) = MSE(Q,Q_hat);
mse_snr_G(ii) = MSE(G,G_hat);
end
figure(2)
semilogy(SNR,mse_snr_Q);
semilogy(SNR,mse_snr_G);
legend('a','h','Q','G: g*trans(g)');
xlabel('SNR (dB)');
ylabel('log(MSE)');
title("MSE vs SNR");
hold off
function X = covar(A,B)
   global num_inst;
    X = A*B ./num_inst; 
end
function X_hat = MMSE(Y,X)
   X_hat = transpose(mean(transpose(X)))+(covar(X,Y')/(covar(Y,Y')))*(Y-transpose(mean(transpose(Y))));
end

function Z = MSE(X,Y)
temp = abs(X-Y).^2;
temp_mean = transpose(mean(transpose(temp)));
Z = mean(temp_mean) ;
end

