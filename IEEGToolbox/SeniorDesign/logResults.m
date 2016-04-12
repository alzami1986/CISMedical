function logResults(results, cfMat, costMatrix)
fid = fopen('log.txt','a');
title = num2str(results(1,:)); 
date_string = results(2,:);
num_instances = results(3,:);
accuracy_string = results(4,:);
precision_string = results(5,:);
recall_string = results(6,:);
f_score_string = results(6,:);
fprintf(fid, '%s\r\n','');
fprintf(fid,'%s\r\n',title);
fprintf(fid,'%s\r\n',date_string);
fprintf(fid,'%s\r\n',num_instances);
fprintf(fid,'%s\r\n',accuracy_string);
fprintf(fid,'%s\r\n',precision_string);
fprintf(fid,'%s\r\n',recall_string);
fprintf(fid,'%s\r\n',f_score_string);
fprintf(fid,'%s\r\n', 'Confusion Matrix');
fprintf(fid,'%d,%d\r\n', cfMat');
fprintf(fid,'%s\r\n', 'Cost Matrix');
fprintf(fid,'%d,%d\r\n', costMatrix');
fclose(fid);

end