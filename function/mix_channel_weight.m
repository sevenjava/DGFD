function channel = mix_channel_weight(M,X)
% % % the parameter M is the global topology feature map.
% % % X is deep feature map after spatial location embedding
    [h,w,K] = size(X) ;
    e=1*10^(-5);
    channel=zeros(1,K);
 
    area=h*w;
    tt=sum(M,"all")/area;
    
    X_sum =reshape(sum(X,[1,2]),[1,K]);
    X_sum=(tt*X_sum).^2;  % operator
 
    nzsum = sum(X_sum);
    for i=1:K
        if X_sum(i)>0
            channel(i) = log((nzsum/(X_sum(i)+e)));
        else
            channel(i) = 0;
        end
    end

end

