clc;
clear all;
close all;

B=39;            
plazalength=135;  
h=NaN;           %¾ä±ú

[plaza,plaza1]=create_plaza(B,plazalength);
h=show_plaza(plaza,h,0.7);

iterations=plazalength-1;  
[plaza,plaza1,groupnum]=new_person(plaza,B,plaza1);

size(find(plaza==1));
h=show_plaza(plaza,h,0.7);
for t=1:iterations
    size(find(plaza==1));
    h=show_plaza(plaza,h,0.7);
    [plaza,plaza1]=move_forward(plaza,plaza1,groupnum);
end




