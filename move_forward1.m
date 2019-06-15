function [plaza,plaza1]=move_forward1(plaza,plaza1)
[L,W]=size(plaza)
t=zeros(L,1);
for lanes=W:-1:1
    t=find(plaza(:,lanes)==1 );
    if t~= 0
        P=ceil(t/3);
        Q=ceil(lanes/3);
        for n=1:1:length(P)
            p=P(n);
            R=rand(3,3);
            b=max(max(R));
            [x,y]=find(b==R);
            R(:,:)=0; R(x,y)=1;
            plaza1{p,Q+1}=R;
            plaza1{p,Q}=zeros(3,3);
        end
        plaza=cell2mat(plaza1);
    else
        continue;
    end
end
end

