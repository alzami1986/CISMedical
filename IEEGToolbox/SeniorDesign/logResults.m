function logResults(results, cfMat, costMatrix)
fid = fopen('logRUSBoost.txt','a');
title = num2str(results(1,:)); 
date_string = results(2,:);
num_instances = results(3,:);
accuracy_string = results(4,:);
precision_string = results(5,:);
recall_string = results(6,:);
f_score_string = results(7,:);
dataset_string = results(8,:);
num_test_instances = results(9,:);
fprintf(fid, '%s\n','');
fprintf(fid,'%s\n',title);
fprintf(fid,'%s\n',date_string);
fprintf(fid,'%s\n',dataset_string);
fprintf(fid,'%s\n',num_instances);
fprintf(fid,'%s\n',num_test_instances);
fprintf(fid,'%s\n',accuracy_string);
fprintf(fid,'%s\n',precision_string);
fprintf(fid,'%s\n',recall_string);
fprintf(fid,'%s\n',f_score_string);
fprintf(fid,'%s\n', 'Confusion Matrix');
fprintf(fid,'%d,%d\n', cfMat');
fprintf(fid,'%s\n', 'Cost Matrix');
fprintf(fid,'%d,%d\n', costMatrix');
fclose(fid);

end