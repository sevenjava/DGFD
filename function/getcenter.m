function [u,v]=getcenter(Z)
% % % Z is the global topology feature map.
%%%% get the center point
    [x,y]=size(Z);
    area=x*y;
    K=round(area/10); 

    p=zeros(1,area);
    p=reshape(Z,[1,area]);
    [q, ~] = sort(p,'descend');
    m=0; 
    n=0;
    X=0; 
    Y=0;
    for i=1:K
        [X,Y]=find(Z==q(i));

        if size(X,1)>1
            m=m+X(1);
            n=n+Y(1);
        else
            m=m+X;
            n=n+Y;
        end
    end
    u=floor(m/K);
    v=floor(n/K);
      
end