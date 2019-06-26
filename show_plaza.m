function [h,X1,X2,Y1,Y2]=show_plaza(plaza,h,n)
[L,W]=size(plaza); 
temp=plaza;
temp(temp==1)=0;%≥ı ºΩÁ√Ê
temp(temp==2)=0;
plaza_draw=plaza;  

% PLAZA(:,:,1)=temp;
% PLAZA(:,:,2)=temp;
% PLAZA(:,:,3)=temp;
% PLAZA=1-PLAZA;
% PLAZA(PLAZA(:,:,1)<=-1)=PLAZA(PLAZA(:,:,1)<=-1)+2;
% PLAZA(PLAZA>1)=PLAZA(PLAZA>1)/6;

% PLAZA(:,:,1)=plaza_draw;
% PLAZA(:,:,2)=plaza_draw;
% PLAZA(:,:,3)=temp;
% PLAZA=1-PLAZA;
% PLAZA(PLAZA(:,:,1)<=-1)=PLAZA(PLAZA(:,:,1)<=-1)+2;
% PLAZA(PLAZA>1)=PLAZA(PLAZA>1)/6;

PLAZA(:,:,1)=ones(L,W);
PLAZA(:,:,2)=ones(L,W);
PLAZA(:,:,3)=ones(L,W);

if ishandle(h)
   set(h,'CData',PLAZA);
%    pause(n);
else
    figure('position',[100 100 1500 800]);
    h=imagesc(PLAZA);
    hold on;

    plot([[0:3:W]',[0:3:W]']+0.5,[0,L]+0.5,'k');
    plot([0,W]+0.5,[[0:3:L]',[0:3:L]']+0.5,'k');
    axis image
    set(gca, 'xtick', [], 'ytick', []);
%     pause(n);
end
y=2:56;
x=y/4.5+2;
plot(y,x,'k','LineWidth',4);
plot([56 76], [14.4 14.4],'k','LineWidth',4);
y=2:56;
x=y/(-4.85)+38.4;
plot(y,x,'k','LineWidth',4);
plot([56 76], [26.8 26.8],'k','LineWidth',4);

[X1,Y1]=find(plaza==1);
plot(Y1,X1,'b.','markersize',20);
[X2,Y2]=find(plaza==2);
plot(Y2,X2,'r.','markersize',20);
pause(n);
plot(Y1,X1,'w.','markersize',20);
plot(Y2,X2,'W.','markersize',20);

% scatter(Y1,X1,60,'filled','b','o');
end