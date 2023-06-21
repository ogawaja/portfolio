function [eigvals, eigvecs] = TwoDLEs(lx,ly,lxx,lyy,n,m, BCs, theta, turn)
   %% Coordinates of vertices

   eignos = 4;
   if lxx == 0 || lyy == 0 
       if strcmp(turn, 'Right') == 1
       vertices = [0, lx, lx, 0, 0;
                   0, 0, ly, ly, 0];
       elseif strcmp(turn, 'Left') == 1
           vertices = [0, ly, ly, 0, 0;
                       0, 0, lx, lx, 0];
       end
   else 
       if strcmp(turn, 'Right') == 1
            vertices = [0, lx, lx, lx - lxx, lx - lxx, 0, 0;
                        0, 0,  ly - lyy, ly - lyy, ly, ly, 0];
       elseif strcmp(turn, 'Left') == 1
            vertices = [ly, ly, 0, 0, lyy, lyy, ly;
                        0, lx, lx, lxx, lxx, 0, 0];
       end 
   end 

   %% Vert. and Horiz. Translations 
   vertsize = size(vertices,2);
   if strcmp(turn, "Right") == 1
       if theta == 90
           vertices = vertices - lx*[ones(1,vertsize);zeros(1,vertsize)];
       elseif theta == 180
           vertices = vertices - [lx*ones(1,vertsize);ly*ones(1,vertsize)];
       elseif theta == 270
           vertices = vertices - ly*[zeros(1,vertsize);ones(1,vertsize)];
       end
   elseif strcmp(turn, "Left") == 1
       if theta == 90
           vertices = vertices - ly*[ones(1,vertsize);zeros(1,vertsize)];
       elseif theta == 180
           vertices = vertices - [ly*ones(1,vertsize);lx*ones(1,vertsize)];
       elseif theta == 270
           vertices = vertices - lx*[zeros(1,vertsize);ones(1,vertsize)];
       end
   end

   %% Rotations
   rad = deg2rad(theta);
   Mrot = [cos(rad), sin(rad)
           -sin(rad), cos(rad)];
   vertices = round(Mrot*vertices, 2);
   
   %% Mesh Grid Creation
   hx = lx/n; %subdivision of x-dim
   hy = ly/m; %subdivision of y-dim
   [x,y] = meshgrid(0:hx:lx, 0:hy:ly); 
   if strcmp(turn, 'Right') == 1 && (theta == 90 || theta == 270) 
           [x,y] = meshgrid(0:hx:ly, 0:hy:lx);
   elseif strcmp(turn, 'Left') == 1 && (theta == 0 || theta == 180)
           [x,y] = meshgrid(0:hx:ly, 0:hy:lx);
   end %inverses mesh dimensions when 90/270 degree change: to ensure hx and hy
   %const. throughout; also considers inversion of mesh dims when turned
   [in,on] = inpolygon(x,y,vertices(1,:),vertices(2,:));
   in = xor(in,on);
   inmat = double(in); %converts logical to double
   inpoints = sum(inmat(:) == 1); %counts no. of inner points
   %blank template of eigvecs and eigvals matrices
   eigvecs = zeros(inpoints, eignos); 
   eigvals = zeros(eignos, 2);

   %% Numbering of interior points; also matrix G
   G = double(in);
   p = find(G);
   G(p) = (1:length(p))';
   if strcmp(BCs, 'Neumann BCs')
       G(:,1) = G(:,2);
       G(:,size(G,2)) = G(:,(size(G,2)-1));
       G = [zeros(size(G,1),1), G, zeros(size(G,1),1)];
       G(1,:) = G(2,:);
       G(size(G,1),:) = G(size(G,1)-1,:);
       G = [zeros(1,size(G,2)); G; zeros(1,size(G,2))];
   end %repeats 1st and last non-zero columns to the zero columns next to them;
   %also expands size of G to ensure indices match up

   %% Solve eigenvalues
   % The discrete Laplacian
   A = delsq(G)/(hx*hy);

   % Sparse matrix eigenvalues and vectors.
   [eigvecs(:,:),E] = eigs(A,eignos,0);
   eigvals = diag(E);
   disp(eigvals);
   disp(eigvecs);
end