function [oxford_feature_pca,query_feature_pca] =Hh_writening(paris_feature_normalize,oxford_feature_normalize,query_features,dim)

%%%Dataset images PCA-whitening
[oxford_feature,coeff,mu,u,s]=pca_and_whitening(paris_feature_normalize,oxford_feature_normalize,dim);
oxford_feature_pca=normalize(oxford_feature,2,"norm");

%%%query images pca-whitening
% % query_features_white=query_pca(query_features,coeff,mu,u,s,d3);
q_features=(query_features-mu)*coeff;
q_test=q_features(:,1:dim);
q_xRot=q_test*u;

epsilon=1*10^(-5);
q_xPCAWhite=diag(1./(sqrt(diag(s)+epsilon)))*q_xRot';
query_features_white=q_xPCAWhite';

query_feature_pca=normalize(query_features_white,2,"norm");

end

