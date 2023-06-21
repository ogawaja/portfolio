function [eigvals, eigvecs] = OneDLEs(l,n)
    h = l/n; %spacing
    eignos = 4; %no. of eigenvalues
    y = zeros(n+1, 1);
    x = (0:h:l)'
    M = full(gallery('tridiag', n+1, 1, -2, 1)); % generate the tridiagonal matrix
    f = -(h^2)*ones(n+1, 1);
    y(2:n) = M(2:n, 2:n)\f(2:n); % solves matrix system
    eigvecs = zeros(n+1, eignos); 
    plot(x,y);
    Q = M/-(h^2);
    [eigvecs(:, :),P] = (eigs(Q, eignos, 0));
    eigvals = diag(P);
    disp(eigvals);
    disp(eigvecs);
end
