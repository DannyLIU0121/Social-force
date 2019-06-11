function [plaza,plaza1]=create_plaza(B,plazalength)
plaza=zeros(B,plazalength);count=1; m=4;n=B-3;

for i=2:plazalength-115 
    if count ==4
        plaza(m,i)=-1;plaza(n,i)=-1;
        m=m+1;
        n=n-1; 
        count=1;
    else
        plaza(m,i)=-1;plaza(n,i)=-1;
        count =count+1;
    end
end
for i=plazalength-115:plazalength-80
     plaza(m,i)=-1;plaza(n,i)=-1;
end
plaza1=mat2cell(plaza,ones(B/3,1)*3,ones(plazalength/3,1)*3);

% v=zeros(B,plazalength); 
% plaza(1:B,[1,plazalength])={-1};

