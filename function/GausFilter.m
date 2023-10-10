function fs = GausFilter(ms)
    [h,w,~]=size(ms);
    S=zeros(h,w);
    d=max(h,w);
    sigma=ceil(d/6);

    [u,v]=getcenter(ms);  
    
    for i=1:h
      for j=1:w  
         S(i,j)=exp(-((i-u)^2+(j-v)^2)/(2*sigma^2));
      end
    end
    fs=ms.*S; 
end