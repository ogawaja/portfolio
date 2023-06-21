function [F1, F2, F3, F4] = EigFeatures(Omega)
   lx = 4;
   ly = 6;
   n = 40;
   m = 60;
   k = 36;   
   eignos = 22;
   if strcmp(Omega, "Rectangle") == 1
       vertices = [0, lx, lx, 0, 0;
                   0, 0, ly, ly, 0];
   elseif strcmp(Omega, "Triangle") == 1
       vertices = [0, lx, lx/2, 0;
                   0, 0, ly, 0];
   elseif strcmp(Omega, "Diamond") == 1
       vertices = [lx/2, lx, lx/2, 0, lx/2;
                   0, ly/2, ly, ly/2, 0];
   elseif strcmp(Omega, "Square") == 1
       ly = lx;
       vertices = [0, lx, lx, 0, 0;
                   0, 0, lx, lx, 0];
   elseif strcmp(Omega, "Disk") == 1
       vertices = zeros(2,k+1);
       for i = 1:k + 1
           vertices(1,i) = lx/2*cos(2*i*pi/k);
           vertices(2,i) = lx/2*sin(2*i*pi/k);
       end
       vertices = vertices + lx/2*ones(2,k+1);
       ly = lx;
   end
   hx = lx/n; %subdivision of x-dim
   hy = ly/m; %subdivision of y-dim

   %% Normal calculations
   %const. throughout; also considers inversion of mesh dims when turned
   [x,y] = meshgrid(0:hx:lx, 0:hy:ly);
   [in,on] = inpolygon(x,y,vertices(1,:),vertices(2,:));
   in = xor(in,on);
   inmat = double(in); %converts logical to double
   inpoints = sum(inmat(:) == 1); %counts no. of inner points
   %blank template of eigvals matrices 
   
   %% Unit Disk Calcs
   
   diskvert = zeros(2,37);
   for i = 1:37
       diskvert(1,i) = cos(2*i*pi/36);
       diskvert(2,i) = sin(2*i*pi/36);
   end
   diskvert = diskvert + ones(2,37); 
   [xd,yd] = meshgrid(0:hx:lx, 0:hy:ly);
   [ind,ond] = inpolygon(xd,yd,diskvert(1,:),diskvert(2,:));
   ind = xor(ind,ond);
   inmatd = double(ind); 
   inpointd = sum(inmatd(:) == 1); 
   Gd = double(ind);
   pd = find(Gd);
   Gd(pd) = (1:length(pd))';
   Ad = delsq(Gd)/(hx*hy);
   d = eigs(Ad,eignos-1,0);
   %% Numbering of interior points; also matrix G
   G = double(in);
   p = find(G);
   G(p) = (1:length(p))';

   %% Solve eigenvalues
   % The discrete Laplacian
   A = delsq(G)/(hx*hy);
   % Sparse matrix eigenvalues and vectors.
   eigvals = eigs(A,eignos,0);
 
   %% Features
   F1 = zeros(eignos - 1, 1);
   F2 = zeros(eignos - 1, 1);
   F3 = zeros(eignos - 1, 1);
   F4 = zeros(eignos - 1, 1);

   for i = 1:eignos - 1
       j = i + 1;
       F1(i) = eigvals(1)/eigvals(j);
   end

   for i = 1:eignos - 1
       j = i + 1;
       F2(i) = eigvals(i)/eigvals(j);
   end

   for i = 1:eignos - 1
       j = i + 1;
       F3(i) = (eigvals(1)/eigvals(j)) - (d(1)/d(j));
   end

   for i = 1:eignos - 1
       j = i + 1;
       F4(i) = eigvals(j)/(i*(eigvals(1)));
   end

   disp(F1);
   disp(F2);
   disp(F3);
   disp(F4);

end