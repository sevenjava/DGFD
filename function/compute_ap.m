function ap = compute_ap(query,gtr_path,rank_list_path)
gt_path = gtr_path;
rank_list_path = rank_list_path;
% load sorting list and Groundtruth
ranked_list = importdata([rank_list_path,query,'.mat']);
good_set = importdata([gt_path,query,'_good.txt']);
ok_set = importdata([gt_path,query,'_ok.txt']);
junk_set = importdata([gt_path,query,'_junk.txt']);
% 
pos_set = [good_set;ok_set];
old_recall = 0.0;
old_precision = 1.0;
ap = 0.0;
intersect_size = 0;
j = 0;
for i=1:size(ranked_list,1)
    if ismember(ranked_list(i),junk_set)
        continue;
    end
    if ismember(ranked_list(i),pos_set)
        intersect_size = intersect_size + 1;
    end
    
    recall = intersect_size / size(pos_set,1);
    precision = intersect_size / (j + 1.0);
    ap = ap + (recall - old_recall)*((old_precision + precision) / 2.0);

    old_recall = recall;
    old_precision = precision;
    j = j + 1;
    
end
end

