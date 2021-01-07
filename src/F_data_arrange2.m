function [ALL] = F_data_arrange2(ps, CNT, A1, A2, A3, A4, A5, A6, A7,...
                                A8, A9, A10, A11, A12, A13, A14, A15)

    ALL(1:CNT, 1) = ps';
    ALL(1:CNT, 2) = A1 (1:CNT,1);
    ALL(1:CNT, 3) = A2 (1:CNT,1);
    ALL(1:CNT, 4) = A3 (1:CNT,1);
    ALL(1:CNT, 5) = A4 (1:CNT,1);
    ALL(1:CNT, 6) = A5 (1:CNT,1);
    ALL(1:CNT, 7) = A6 (1:CNT,1);
    ALL(1:CNT, 8) = A7 (1:CNT,1);
    ALL(1:CNT, 9) = A8 (1:CNT,1);
    ALL(1:CNT,10) = A9 (1:CNT,1);
    ALL(1:CNT,11) = A10(1:CNT,1);
    ALL(1:CNT,12) = A11(1:CNT,1);
    ALL(1:CNT,13) = A12(1:CNT,1);
    ALL(1:CNT,14) = A13(1:CNT,1);
    ALL(1:CNT,15) = A14(1:CNT,1);
    ALL(1:CNT,16) = A15(1:CNT,1);

end
