function [ALL]=F_data_arrange1(ps, CNT, A1, A2, A3, A4, A5, A6, A7)

    ALL(1:CNT,1) = ps'        ;
    ALL(1:CNT,2) = A1(1:CNT,1);
    ALL(1:CNT,3) = A2(1:CNT,1);
    ALL(1:CNT,4) = A3(1:CNT,1);
    ALL(1:CNT,5) = A4(1:CNT,1);
    ALL(1:CNT,6) = A5(1:CNT,1);
    ALL(1:CNT,7) = A6(1:CNT,1);
    ALL(1:CNT,8) = A7(1:CNT,1);

end
