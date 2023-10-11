
Tests = ["oxford5k","paris6k","oxford105k","paris106k","holidays"];

load("Oqueryimg.mat"); %%%the filename list of oxford queryset
load("Pqueryimg.mat"); %%%the filename list of paris queryset 

for i=1:5
   switch Tests(i)
       case "oxford5k"
           imgfiles=dir('../datasets/oxford5k/*.jpg'); %%%dataset images
           [TestFN,TrainFN,QFN]= GDFDmain(Tests(i),imgfiles);
           evaluateOP(TestFN,TrainFN,QFN,queryPic,imgfiles,i);
       case "oxford105k"
           imgfiles=dir('../datasets/oxford105k/*.jpg');
           [TestFN,TrainFN,QFN]= GDFDmain(Tests(i),imgfiles);      
           evaluateOP(TestFN,TrainFN,QFN,queryPic,imgfiles,i);
       case "paris6k"
           imgfiles=dir('../datasets/paris6k/*.jpg');
           [TestFN,TrainFN,QFN]= GDFDmain(Tests(i),imgfiles);
           evaluateOP(TestFN,TrainFN,QFN,pqueryPic,files,i);
       case "paris106k"
           imgfiles=dir('../datasets/paris106k/*.jpg');
           [TestFN,TrainFN,QFN]= GDFDmain(Tests(i),imgfiles);
           evaluateOP(TestFN,TrainFN,QFN,pqueryPic,files,i);
       case "holidays"
           imgfiles= dir('E:\datasets\holidays6\*.jpg');
           [TestFN,TrainFN,QFN]= GDFDmain(Tests(i),imgfiles);
           evaluateH(TestFN,TrainFN);
   end
end

%% compute mAP 
function evaluateOP(Test,Train,query,queryimg,files,index)
    ogt_query_filename=queryimg(:,1);
    if mod(index,2) ==0
        gtr_files='../paris/gt_files_120310/';
    else
        gtr_files='../oxford/gt_files_170407/';
    end
    for j=3:5
        dd=32*2^(j-1);
        [oxford_feature_pca,query_feature_pca]=Hh_writening(Train,Test,query,dd);
        rank_list(oxford_feature_pca,query_feature_pca,files,ogt_query_filename,0);
       
        query_num=size(ogt_query_filename,1);
        sum_ap=0;
        ap=0;
        rank_list_path='../results/rank_list_tmp/';      
        parfor i=1:query_num
            ap=compute_ap(ogt_query_filename{i},gtr_files,rank_list_path);
            sum_ap=sum_ap+ap; 
        end
         AP=sum_ap/query_num;
         fprintf('dim= %d  mAP= %.4f\n',dd,AP);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% compute mAP for Holidays
function evaluateH(TestFN,TrainFN)
    addpath('holidays');
    load('gnd_holidays.mat');
    
    for i=3:5
        dd=32*2^(i-1);
        vecs_test=TestFN';
        qvecs = vecs_test(:,qidx);
        [hol_feature_pca,hq_feature_pca]=Hh_writening(TrainFN,TestFN,qvecs',dd);
        vecs_test=hol_feature_pca';
        qvecs=hq_feature_pca';
        [ranks,~] = knnDist(vecs_test, qvecs, size(vecs_test,2), 'L2');
        [map,~] = computehmap (ranks, gnd);
        fprintf('dim= %d  mAP= %.4f\n',dd,map);
    end
end


