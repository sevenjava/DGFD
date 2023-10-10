function [TestFeatures_norm, TraFeatures_norm, qfeatures_norm] =  DGFDmain(testDs,imgfiles)

dim=512;
m=10; %%%%number of the selected feature maps
%%%%to obtain the index of global topology feature
if strcmp(testDs,'oxford5k')
    files=dir('../features/pool5/oxford5k/*.mat');  %%%%deep convolutional features
    wfiles=dir('../features/pool5/paris6k/*.mat');  %%%%%%%for PCA-whitening
    qfiles=dir('../features/pool5/qoxford/*.mat');  %%%%%deep features of query image
    label=FreqStatRank(files,imgfiles);
elseif strcmp(testDs,'paris6k')
    files=dir('../features/pool5/paris6k/*.mat'); 
    wfiles=dir('../features/pool5/oxford5k/*.mat');
    qfiles=dir('../features/pool5/qparis/*.mat');
    label=FreqStatRank(files,imgfiles);
elseif strcmp(testDs,'holidays')
    files=dir('../features/pool5/holidays/*.mat');  %%%%deep convolutional features
    qfiles="";
    wfiles=dir('../features/pool5/oxford105k/*.mat');     
    label=FreqStatRank(files,imgfiles);
elseif strcmp(testDs,'oxford105k')
    files=dir('../features/pool5/oxford105k/*.mat'); 
    wfiles=dir('../features/pool5/paris6k/*.mat'); 
    qfiles=dir('../features/pool5/qoxford/*.mat');
    label=FreqStatRank(files,imgfiles);
elseif strcmp(testDs,'paris106k')
    files=dir('../features/pool5/paris106k/*.mat'); 
    wfiles=dir('../features/pool5/oxford5k/*.mat');
    qfiles=dir('../features/pool5/qparis/*.mat');
    label=FreqStatRank(files,imgfiles);   
end
%% aggregate dataset features
file_num=size(files,1);
TestFeatures=zeros(file_num,dim);
parfor i=1:file_num
    ft=importdata([files(1).folder,'/',files(i).name]);
    %%%%%global topology feature
    [h,w,K] = size(ft);
    ms= zeros([h,w]);
    for k=1:m
         ms=ms+ft(:,:,label(k));%%%%%
    end
   %%%%%%%Spatial location embedding
    fil_ms=GausFilter(ms); %%%%%apply Gaussian filter on the global topology feature
    NormS=normp(fil_ms);%%%%%%%normalize and power-scale
    ft=ft.*NormS;  
    %%%%%%%%%%%%%%Channel-wise embedding
    C=mix_channel_weight(fil_ms,ft);
    X = reshape(sum(ft,[1,2]),[1,K]);
    tt=X.*C;
    TestFeatures(i,:)=tt;
end
%% aggregate query features
qfeatures=zeros(55,dim);
if qfiles ~=""
    parfor i=1:55
        qft=importdata([qfiles(1).folder,'/',qfiles(i).name]);
        %%%%%global topology feature
        [h,w,K] = size(qft);
        ms= zeros([h,w]);
        for k=1:m
             ms=ms+qft(:,:,label(k));%%%%%
        end
       %%%%%%%Spatial location embedding
        fil_ms=GausFilter(ms); %%%%%apply Gaussian filter on the global topology feature
        NormS=normp(fil_ms);%%%%%%%normalize and power-scale
        qft=qft.*NormS;  
        %%%%%%%%%%%%%%Channel-wise embedding
        C=mix_channel_weight(fil_ms,qft);
        X = reshape(sum(qft,[1,2]),[1,K]);
        tt=X.*C;
        qfeatures(i,:)=tt;
    end
else

end
%% using another dataset to learn PCA parameter
wfile_num=size(wfiles,1);
TraFeatures=zeros(wfile_num,dim);
parfor i=1:wfile_num
    ft=importdata([wfiles(1).folder,'/',wfiles(i).name]);
    %%%%%global topology feature
    [h,w,K] = size(ft);
    ms= zeros([h,w]);
    for k=1:m
         ms=ms+ft(:,:,label(k));%%%%%
    end
   %%%%%%%Spatial location embedding
    fil_ms=GausFilter(ms); %%%%%apply Gaussian filter on the global topology feature
    NormS=normp(fil_ms);%%%%%%%normalize and power-scale
    ft=ft.*NormS;  
    %%%%%%%%%%%%%%Channel-wise embedding
    C=mix_channel_weight(fil_ms,ft);
    X = reshape(sum(ft,[1,2]),[1,K]);
    tt=X.*C;
    TraFeatures(i,:)=tt;
end
%% Normalize
TestFeatures_norm=normalize(TestFeatures,2,'norm');
TraFeatures_norm=normalize(TraFeatures,2,'norm');
qfeatures_norm=normalize(qfeatures,2,'norm');
end


