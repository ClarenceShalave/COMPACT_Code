function y = maxk(A, k)
A = sort(A);   % No UNIQUE here
y = A(end-k+1:end);
end