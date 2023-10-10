function [oxford_feature,coeff,mu,u,s] = pca_and_whitening(XTrain,XTest,d)

[coeff,scoreTrain,~,~,~,mu]=pca(XTrain);

%Training dataset dimensionality reduction
x_train=scoreTrain(:,1:d);

%calculate covariance matrix
sigma=cov(x_train,'omitrows');
[u,s,~]=svd(sigma);

%%convert test dataset using the principal component score of the training
%%set
scoreTest=(XTest-mu)*coeff;
x_test=scoreTest(:,1:d);
xRot=x_test*u;

epsilon=1*10^(-5);
xPCAWhite=diag(1./(sqrt(diag(s)+epsilon)))*xRot';%%whitening operation
oxford_feature=xPCAWhite';

end

