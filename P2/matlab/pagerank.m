function x = pagerank(U,G,p)
% PAGERANK  Google's PageRank
% pagerank(U,G,p) uses the URLs and adjacency matrix produced by SURFER,
% together with a damping factory p, (default is .85), to compute and plot
% a bar graph of page rank, and print the dominant URLs in page rank order.
% x = pagerank(U,G,p) returns the page ranks instead of printing.
% See also SURFER, SPY.

if nargin < 3, p = .85; end


if(ischar(U))
    U=cellstr(U);
end

if(isreal(U))
   U=(num2cell(U));
end


% Eliminate any self-referential links

G = G - diag(diag(G));
  
% c = out-degree, r = in-degree

n = size(G,1);
c = sum(G,1);
r = sum(G,2);

% Scale column sums to be 1 (or 0 where there are no out links).

k = find(c~=0);
D = sparse(k,k,1./c(k),n,n);

% Solve (I - p*G*D)*x = e

e = ones(n,1);
I = speye(n,n);
x = (I - p*G*D)\e;

% Normalize so that sum(x) == 1.

x = x/sum(x);

% Bar graph of page rank.

shg
bar(x)
title('Page Rank')

% Print URLs in page rank order.

if nargout < 1
   [~,q] = sort(-x);
   disp('     page-rank  in  out  url')
   k = 1;
   while (k <= n) && (x(q(k)) >= .005)
      j = q(k);
      temp1  = r(j);
      temp2  = c(j);
      fprintf(' %3.0f %8.4f %4.0f %4.0f  %s\n', j,x(j),full(temp1),full(temp2),U{j})
      k = k+1;
   end
end
