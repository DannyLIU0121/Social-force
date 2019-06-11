function [plaza,plaza1,groupnum]=new_person(plaza,B,plaza1)
%     for i=1:5
          A=rand(3,3);
          C=rand(3,3);
          D=rand(3,3);
          a1=max(max(A));b1=max(max(C));d1=max(max(D));
          [x1,y1]=find(a1==A);         
          [x2,y2]=find(b1==C);
          [x3,y3]=find(d1==D);
          C(:,:)=0;A(:,:)=0;D(:,:)=0;
          A(x1,y1)=1;C(x2,y2)=2;D(x3,y3)=3;
%      end
      plaza1{B/6,1}=A;
      plaza1{B/6+1,1}=A;
      plaza1{B/6-1,1}=A;
      plaza1{B/6,2}=A;
      plaza1{B/6+1,2}=A;
      plaza1{B/12,1}=C;
      plaza1{B/12+1,1}=C;
      plaza1{B/12-1,1}=C;
      plaza1{B/12,2}=C;
      plaza1{B/12+1,2}=C;
      plaza1{B/12+1,2}=C;
      plaza1{B/4,1}=D;
      plaza1{B/4+1,1}=D;
      plaza1{B/4-1,1}=D;
      plaza1{B/4,2}=D;
      plaza1{B/4+1,2}=D;
      plaza1{B/4+1,2}=D;     
      plaza=cell2mat(plaza1);
      groupnum=3;
end