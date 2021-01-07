function [A1, A2, A3, A4] = F_data_ave1(CNT, num_ave, A1, A2, A3, A4)
    
    A1(CNT,1) = mean(A1(CNT,2:num_ave+1));
    A2(CNT,1) = mean(A2(CNT,2:num_ave+1));
    A3(CNT,1) = mean(A3(CNT,2:num_ave+1));
    A4(CNT,1) = mean(A4(CNT,2:num_ave+1));
    
end
