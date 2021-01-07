function [ALL]=F_data_arrange3(ps, CNT, A1, A2)

    ALL(1:CNT,1) = ps'        ;
    ALL(1:CNT,2) = A1(1:CNT,1);
    ALL(1:CNT,3) = A2(1:CNT,1);

end
