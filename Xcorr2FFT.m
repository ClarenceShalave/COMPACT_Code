%% 
%Author£ºXiaYiming
%Using fft2 to accelerate Xcorr2 :the same input as Xcorr2()
function Result = Xcorr2FFT(A,B)
AT = rot90(A,2);
[AX,AY] = size(A);
[BX,BY] = size(B);
AT(AX+BX-1,AY+BY-1)=0;
B(AX+BX-1,AY+BY-1)=0;
CO = ifft2(ifftshift(fftshift(fft2(AT)).*fftshift(fft2(B))));
R = CO;
MAX = max(max(max(R)));
MIN = min(min(min(R)));
for i=1:AX
    for j =1:AY
        if abs(R(i,j)/MAX)<1e-15||abs(R(i,j)/MIN)<1e-15
           R(i,j) = 0;
        end
    end
end
Out = rot90(R,2);

Result = Out;