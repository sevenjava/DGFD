% Return the k nearest neighbors of a set of query vectors
%
% Usage: [idx,dis] = knnDist (X, Q, k, distype)
%   X                the dataset to be searched (one vector per column)
%   Q                the set of queries (one query per column)
%   k  (default:1)   the number of nearest neigbors we want
%   distype          the type of distance metric
% Returned values
%   idx         the vector index of the nearest neighbors
%   dis         the corresponding distances

function [idx, dis] = knnDist (X, Q, k, distype)

if ~exist('k'), k = 1; end
if ~exist('distype'), distype = 2; end 
assert (size (X, 1) == size (Q, 1));

switch distype
    case {1,'L1'}
        sim = zeros(size(X,2),size(Q,2));
        for i=1:size(Q,2)
            sim(:, i) = sum(abs(bsxfun(@minus, X, Q(:,i))));
        end
        if k == 1
            [dis, idx] = min (sim, [], 1);
        else  
            [dis, idx] = sort (sim, 1);
            dis = dis (1:k, :);
            idx = idx (1:k, :);
        end        
    case {2,'L2'}
      % Compute half square norm
      X_nr = sum (X.^2) / 2;
      Q_nr = sum (Q.^2) / 2;
    
      sim = bsxfun (@plus, Q_nr', bsxfun (@minus, X_nr, Q'*X));
    
      if k == 1
        [dis, idx] = min (sim, [], 2);
      else  
        [dis, idx] = sort (sim, 2);
        dis = dis (:, 1:k);
        idx = idx (:, 1:k);
      end   
      dis = dis' * 2;
      idx = idx';
    
    case {16,'COS'}
      sim = Q' * X;
                    
      if k == 1
        [dis, idx] = min (sim, [], 2);
        dis = dis';
        idx = idx';
      else  
        [dis, idx] = sort (sim, 2);
        dis = dis (:, 1:k)';
        idx = idx (:, 1:k)';
      end
                     
    otherwise
       error ('Unknown distance type');
end


    

                
