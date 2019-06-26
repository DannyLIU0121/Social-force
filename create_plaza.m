function [plaza,plaza1]=create_plaza(B,plazalength)
plaza=zeros(B,plazalength);count=1; m=2;n=B-1;
plaza1=mat2cell(plaza,ones(B/3,1)*3,ones(plazalength/3,1)*3);
for i=2:56 
    if count ==4
        wall=-1;
        plaza(m,i)=wall;plaza(n,i)=wall;plaza(m+1,i)=wall;plaza(n-1,i)=wall;
        m=m+1;
        n=n-1; 
        count=1;
    else
        wall=-1;
        plaza(m,i)=wall;plaza(n,i)=wall;
        count =count+1;
    end
end
for i=57:76
     plaza(m,i)=wall;plaza(n,i)=wall;
end
% % for i=2:15
% %     wall=-1;
% %     plaza(m,i)=wall;
% %     plaza(n,i)=wall;
% %     m=m+1;n=n-1;
% % end
% % for i=16:28
% % plaza(m-1,i)=wall;
% % plaza(n+1,i)=wall;
% % end
plaza1=mat2cell(plaza,ones(B/3,1)*3,ones(plazalength/3,1)*3);
end



