function [Accuracy] = kmeansAcc(FN)
   load("square.mat", "F1234sq");
   load("triangle.mat", "F1234tri");
   n = 30; %no. of squares
   X = [F1234sq; F1234tri];
   x = [X(:,1:FN), X(:,21:20+FN), X(:,(41:40+FN)), X(:,61:60+FN)];

   idx = kmeans(x,2);
   idx_real = [ones(n,1); 2*ones(100-n,1)];
   check = zeros(100,1);

   for i = 1:100
       if idx(i) == idx_real(i)
           check(i) = 1;
       else
           check(i) = 0;
       end
   end
   Accuracy = sum(check == 1)/100;
   disp(Accuracy);
end


