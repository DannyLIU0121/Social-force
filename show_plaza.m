function h=show_plaza(plaza,h,n)

[L,W]=size(plaza); 
temp=plaza;
temp(temp==1)=0;%��ʼ����

plaza_draw=plaza;  

PLAZA(:,:,1)=plaza_draw;
PLAZA(:,:,2)=plaza_draw;
PLAZA(:,:,3)=temp;
PLAZA=1-PLAZA;
PLAZA(PLAZA>1)=PLAZA(PLAZA>1)/6;


if ishandle(h)
   set(h,'CData',PLAZA);
   pause(n);
else
    figure('position',[100 100 1500 800]);

    h=imagesc(PLAZA);

    hold on;
%     plot([[0:3:W]',[0:3:W]']+0.5,[0,L]+0.5,'k');
%     plot([0,W]+0.5,[[0:3:L]',[0:3:L]']+0.5,'k');
    axis image
    set(gca, 'xtick', [], 'ytick', []);
    pause(n);
end
end