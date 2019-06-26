function [plaza,plaza1]=move_forward(plaza,plaza1,groupnum)
[L,W]=size(plaza);
plaza2=zeros(40,140);
% livelocation=mat2cell(plaza2,ones(L/1,1)*1,ones(W/2,1)*2);
walllocation=mat2cell(plaza2,ones(40/1,1)*1,ones(140/2,1)*2);
grouplocation=mat2cell(plaza2,ones(40/1,1)*1,ones(140/2,1)*2);
groupcenter=mat2cell(plaza2,ones(40/1,1)*1,ones(140/2,1)*2);
va0=2;%移动速度
nn=1;

%记录此时刻所有人的在plaza中的初始位置
% for lanes=W:-1:1
%     t=find(plaza(:,lanes)==1 );
%     if t~=0
%         for n=1:length(t)
%             p=t(n);
%             livelocation{n,nn}=[p,lanes];
%         end
%         nn=nn+1;
%     else
%         continue
%     end
% end

%记录plaza中的所有障碍的位置
nn=1;
for lanes=1:W
    t=find(plaza(:,lanes)==-1 );
    if t~=0
        for n=1:length(t)
            p=t(n);
            walllocation{n,nn}=[p,lanes];
        end
        nn=nn+1;
    else
        continue
    end
end

%分别记录各个组的组员的位置,储存在grouplocation各列中
for lanes=W:-1:1
    for id = 1:groupnum
        t=find(plaza(:,lanes)==id );
    if t~=0
        for n=1:length(t)
            p=t(n);
            for loc=1:L
                if grouplocation{loc,id}~=0
                    continue;
                else
                    grouplocation{loc,id}=[p,lanes];
                    break;
                end
            end                  
         end
    else
        continue
    end
    end
end


% 计算小组形心并储存
i=0;
for lanes=1:W/2
    code=0;
    for p=1:L
        if any(grouplocation{p,lanes})~=0
            code=1;%表明此center需要记录进groupcenter
            center=zeros(1,2);
            peoplesum1=cellfun('isempty',grouplocation);
            peoplesum=length( find( peoplesum1(:,lanes)==1 ) );
            center(1,1)=center(1,1)+grouplocation{p,lanes}(1,1);
            center(1,2)=center(1,2)+grouplocation{p,lanes}(1,2);
            center(1,1)=center(1,1)/peoplesum;
            center(1,2)=center(1,2)/peoplesum;
        else
            continue
        end
    end
    if code==1
        i=i+1;
        groupcenter{1,i}=center;
    end
end

%循环计算每个元组受到的力
fin=[L/2,W];
A=1;
B=1;
for ii=groupnum:-1:1
    %元组受到的目的地的吸引力
    ga=(fin-groupcenter{1,ii})/sqrt((L/2-groupcenter{1,ii}(1,1))^2+(W-groupcenter{1,ii}(1,2))^2);
    Ga=2*ga*va0;
    
    %计算该元组与其他元组之间的力
    gb=(groupcenter{1,1}-groupcenter{1,2})/sqrt((groupcenter{1,1}(1,1)-groupcenter{1,2}(1,1))^2+(groupcenter{1,1}(1,2)-groupcenter{1,2}(1,2))^2);
    Gb1=A*exp((sqrt((groupcenter{1,1}(1,1)-groupcenter{1,2}(1,1))^2+(groupcenter{1,1}(1,2)-groupcenter{1,2}(1,2))^2)-2)/B)*gb;  %吸引力
    Gb2=A*exp((2-sqrt((groupcenter{1,1}(1,1)-groupcenter{1,2}(1,1))^2+(groupcenter{1,1}(1,2)-groupcenter{1,2}(1,2))^2))/B)*gb;  %排斥力  
end

%循环计算每个人的行走
for lanes=1:W/2
        %         P=ceil(t/3);
        %         Q=ceil(lanes/3);
        %         终点位置定为（L/2，W）
        
        %计算目的地对元组中心的吸引力
        fin=[L/2,W];
        
   
        for p=1:L
            va2=[0,0];
            if any(grouplocation{p,lanes})~=0
            
            %计算目的地吸引力    
            ea=(fin-grouplocation{p,lanes})/sqrt((L/2-p)^2+(W-lanes)^2);%  目的地的吸引力确定移动方向
            Fa=2*ea*va0; %目的地吸引力

            
            %计算最近的障碍点排斥力
            nearstwall=[0,0];
            distance=sqrt((grouplocation{p,lanes}(1,1)-walllocation{1,1}(1,1))^2+(grouplocation{p,lanes}(1,2)-walllocation{1,1}(1,2))^2);
            for wallW=1:W/2
                for wallL=1:L
                    distance1=sqrt((grouplocation{p,lanes}(1,1) -walllocation{wallL,wallW}(1,1))^2+(grouplocation{p,lanes}(1,2) -walllocation{wallL,wallW}(1,2))^2);
                    if distance>distance1
                       distance=distance1;nearstwall=walllocation{wallL,wallW};
                    else
                       continue;
                    end
                end  
            end
            FaB=1*(grouplocation{p,lanes}-nearstwall)/distance^2;
            
            
            %计算最近的其他组的人的排斥力
            pvpdistance=100;
            for lanes1=[1:lanes-1,lanes+1:W/2]
                for p1=[1:p-1,p+1:L]
                    if grouplocation{p1,lanes1}~=0
                    pvpdistance1=sqrt((grouplocation{p,lanes}(1,1)-grouplocation{p1,lanes1}(1,1))^2+(grouplocation{p,lanes}(1,2)-grouplocation{p1,lanes1}(1,2))^2);
                    if pvpdistance1<pvpdistance
                        pvpdistance=pvpdistance1;
                    else
                        continue;
                    end
                    end
                end
            end
            Fad=-0.01*(grouplocation{p,lanes}-grouplocation{p1,lanes1})/pvpdistance^2;
% Fad=[0,0];           
            
            %计算同组人的吸引力及排斥力
            pvpdistance=100;
            sgrouppower=[0,0];
            for p1=[1:p-1,p+1:L]
                    if grouplocation{p1,lanes}~=0
                    pvpdistance1=sqrt((grouplocation{p,lanes}(1,1)-grouplocation{p1,lanes}(1,1))^2+(grouplocation{p,lanes}(1,2)-grouplocation{p1,lanes}(1,2))^2);
                    if pvpdistance1<pvpdistance
                        pvpdistance=pvpdistance1;
                    else
                        continue;
                    end
                    end
            end
            Fac=-0.01*(1-pvpdistance)*(grouplocation{p,lanes}-grouplocation{p1,lanes})/pvpdistance^2;
%             Fac=A*exp((sqrt((grouplocation{p,lanes}(1,1)-grouplocation{p1,lanes}(1,1))^2+(grouplocation{p,lanes}(1,2)-grouplocation{p1,lanes}(1,2))^2)-1)/B)*eac;
% Fac=[0,0];
            
            
            %计算元组间的吸引力及排斥力
             for lanes1=[1:lanes-1,lanes+1:W/2]
                for p1=[1:p-1,p+1:L]
                    if grouplocation{p1,lanes1}~=0
                    pvpdistance1=sqrt((grouplocation{p,lanes}(1,1)-grouplocation{p1,lanes1}(1,1))^2+(grouplocation{p,lanes}(1,2)-grouplocation{p1,lanes1}(1,2))^2);
                    if pvpdistance1<pvpdistance
                        pvpdistance=pvpdistance1;
                    else
                        continue;
                    end
                    end
                end
            end
            Fae=-0.1*(grouplocation{p,lanes}-grouplocation{p1,lanes1})/pvpdistance^2;
            
            
            %计算组间排斥力
            
            %计算最终移动位置
            step1=Fa(1)+FaB(1)+Fac(1)+Fad(1);
            step2=Fa(2)+FaB(2)+Fac(2)+Fad(2);
            P=ceil(grouplocation{p,lanes}(1,1)/3);
            Q=ceil(grouplocation{p,lanes}(1,2)/3);%该人在plaza1中的位置为（P,Q）
            %处理步伐大小，变为1
            k=abs(step1/step2);
            if k>1
                step1=step1/abs(step1);
                step2=round(step2/abs(step1));
            else 
                step2=step2/abs(step2);
                step1=round(step1/abs(step2));
            end
            x=round(P+step1);
            y=round(Q+step2);
            
            %下一步的X1、X2、X3
            if max(max(plaza1{P,Q}))==1
            X1=plaza1{P,Q};
            X1num=max(max(X1));
            X1location=zeros(1,2);
            [location1,location2]=find(X1==max(max(X1)));
            if FaB(1)>4
                X1location(1,1)=location1+x;
            else
                X1location(1,1)=location1;
            end
            if FaB(2)>4
                X1location(1,2)=location2+y;
                 else
                X1location(1,2)=location2;
            end
            if X1location(1,1)>3
                X1location(1,1)=3;
            elseif  X1location(1,1)<0
                X1location(1,1)=0;
            end
            if X1location(1,2)>3
                X1location(1,2)=3;
            elseif  X1location(1,2)<0
                X1location(1,2)=0;
            end
            X1=zeros(3,3);
            X1(X1location(1,1), X1location(1,2))=X1num;
            end
            
            if max(max(plaza1{P,Q}))==2
            X2=plaza1{P,Q};
            X2num=max(max(X2));
            X2location=zeros(1,2);
            [location1,location2]=find(X2==max(max(X2)));
            if FaB(1)>4
                X2location(1,1)=location1+x;
            else
                X2location(1,1)=location1;
            end
            if FaB(2)>4
                X2location(1,2)=location2+y;
            else
                X2location(1,2)=location2;
            end
            if X2location(1,1)>3
                X2location(1,1)=3;
            elseif  X2location(1,1)<0
                X2location(1,1)=0;
            end
            if X2location(1,2)>3
                X2location(1,2)=3;
            elseif  X2location(1,2)<0
                X2location(1,2)=0;
            end
            X2=zeros(3,3);
            X2(X2location(1,1), X2location(1,2))=X2num;
            end
            
            %边界处理
            if y<=45  && max(max(plaza1{x,y}))==0
                %判断组别并赋相应值
                if  max(max(plaza1{P,Q}))==1
                    plaza1{x,y}=X1;
                    plaza1{P,Q}=zeros(3,3);
                end
                if max(max(plaza1{P,Q}))==2
                    plaza1{x,y}=X2;
                     plaza1{P,Q}=zeros(3,3);
                end
                if max(max(plaza1{P,Q}))==3
                    plaza1{x,y}=X3;
                     plaza1{P,Q}=zeros(3,3);
                end
         
            elseif y>45
                plaza1{P,Q}=zeros(3,3);
                break;
            else
                break;
            end
            else
                break;
            end
        end
end
plaza=cell2mat(plaza1);
end