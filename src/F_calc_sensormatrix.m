function [H]=F_calc_sensormatrix(p, n, SNSR)

   H=zeros(p, n);
   for pp=1:1:p
      H(pp, SNSR(pp))=1;
   end
   
end
