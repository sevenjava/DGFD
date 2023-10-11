function [] = rank_list(features_pca,query_feature_pca,files,query_files,qe) 
 delete('../results/*.mat')
% % return results file 
    resultfile = {};
    num_return = size(files,1);
    
    % L2 distance
    for i=1:55
        dist = zeros(num_return,1);
        dist=pdist2(query_feature_pca(i,:),features_pca,'euclidean');

        [L1_sorted, index] = sort(dist);
        
        %QE
        if qe~=0
            Q=zeros(1,size(features_pca,2));
            for  s=1:qe
                Q=Q+features_pca(index(s),:);
            end
            Q=normalize(Q);
            dist = zeros(num_return,1);
            diff = repmat(Q,[num_return,1]) - features_pca;
            diff = diff.*diff;
            dist = sum(diff,2);
            [L2_sorted, index] = sort(dist);
        end
             
% % % save the returned results of query images
        for k=1:num_return
            result_image_name = split(files(index(k)).name,'.');
            resultfile{k,1} = result_image_name{1};
        end
        save(['../results/',query_files{i},'.mat'], 'resultfile');
    end
end
