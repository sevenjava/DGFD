function chanI = FreqStatRank(files,lfiles)
%%%%select top-m channel 
%%%%The parameter files denote deep convolutional features;
%%%%The parameter lfiles denote the dataset images.
file_num=size(files,1);
dim=512;
mo=zeros(file_num,1);

for i=1:file_num
    ft=importdata([files(1).folder,'\',files(i).name]);
    folder=[lfiles(1).folder,'\'];
    I=imread([folder,lfiles(i).name]);
    
    [h,w,~]=size(ft);
    I1=imresize(I,[h w]);
    I2=rgb2hsv(I1);
    V=I2(:,:,3);  %%%to obtain Value component
    ang=[0  20 40 60 80 100 120 140 160];
    gaborArray=gabor([7.0],ang);
    gabortmp=imgaborfilt(V,gaborArray);

    E=reshape(sum(gabortmp,[1 2]),[1,9]);
    rft=imresize(ft,[9,9]);
    sft=reshape(sum(rft,1),[9,dim]);
    sft=sft';
    lt=single(E);
    sft=single(sft);
    dist=pdist2(lt,sft,'euclidean');
    [~,index]=sort(dist,'ascend');

    mo(i)=index(1);
end
tbl=tabulate(mo);
[~,chanI]=sort(tbl(:,2),'descend');

end