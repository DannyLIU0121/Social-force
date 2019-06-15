function [plaza,plaza1]=create_plaza(B,plazalength)
plaza=zeros(B,plazalength);count=1; m=12;n=B/3-9;
plaza1=mat2cell(plaza,ones(B/3,1)*3,ones(plazalength/3,1)*3);
for i=2:plazalength/3-115 
    if count ==4
        wall=[-1,-1,-1;-1,-1,-1;-1,-1,-1];
        plaza1{m,i}=wall;plaza1{n,i}=wall;plaza1{m+1,i}=wall;plaza1{n-1,i}=wall;
        m=m+1;
        n=n-1; 
        count=1;
    else
        plaza1{m,i}=wall;plaza{n,i}=wall;
        count =count+1;
    end
end
for i=plazalength/3-115:plazalength/3-105
     plaza{m,i}=wall;plaza{n,i}=wall;
end
plaza=cell2mat(plaza1);



