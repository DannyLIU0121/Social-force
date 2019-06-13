function [plaza,plaza1]=move_forward(plaza,plaza1,groupnum)
[L,W]=size(plaza);
plaza2=zeros(L,W);
% livelocation=mat2cell(plaza2,ones(L/1,1)*1,ones(W/2,1)*2);
walllocation=mat2cell(plaza2,ones(L/1,1)*1,ones(W/2,1)*2);
grouplocation=mat2cell(plaza2,ones(L/1,1)*1,ones(W/2,1)*2);
va0=2;%�ƶ��ٶ�
nn=1;

%��¼��ʱ�������˵���plaza�еĳ�ʼλ��
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

%��¼plaza�е������ϰ���λ��
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

%�ֱ��¼���������Ա��λ��,������grouplocation������
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


% �����������
for lanes=1:W/2
    peoplesum=nnz(grouplocation{:,lanes});
    for p=1:L
        if any(grouplocation{p,lanes})~=0
            center=zeros(1,2);
            for i=1:peoplesum
                center(1,1)=center(1,1)+grouplocation{p,lanes}(i,1);
                center(1,2)=center(1,2)+grouplocation{p,lanes}(i,2);
            end
            center(1,1)=center(1,1)/peoplesum;
            center(1,2)=center(1,2)/peoplesum;
        else
            continue
        end
    end
end


%ѭ������ÿ���˵�����
for lanes=1:W/2
        %         P=ceil(t/3);
        %         Q=ceil(lanes/3);
        %         �յ�λ�ö�Ϊ��L/2��W��
        fin=[L/2,W];
        for p=1:L
            va2=[0,0];
            if any(grouplocation{p,lanes})~=0
            
            %����Ŀ�ĵ�������    
            ea=(fin-grouplocation{p,lanes})/sqrt((L/2-p)^2+(W-lanes)^2);%  Ŀ�ĵص�������ȷ���ƶ�����
            Fa=4*ea*va0 %Ŀ�ĵ�������

            
            %����������ϰ����ų���
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
            FaB=3*(grouplocation{p,lanes}-nearstwall)/distance^2
            
            
            %�����������������˵��ų���
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
            Fad=-0.1*(grouplocation{p,lanes}-grouplocation{p1,lanes1})/pvpdistance^2
            
            
            %����ͬ���˵����������ų���
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
            Fac=-0.1*(1-pvpdistance)*(grouplocation{p,lanes}-grouplocation{p1,lanes})/pvpdistance^2
% Fac=[0,0];
            
            
            %����Ԫ�������������ų���
            
            
            
            %��������ų���
            
            %���������ƶ�λ��
            step1=Fa(1)+FaB(1)+Fac(1)+Fad(1);
            step2=Fa(2)+FaB(2)+Fac(2)+Fad(2);
            k=abs(step1/step2);
            if k>1
                step1=step1/abs(step1)
                step2=round(step2/abs(step1))
            else 
                step2=step2/abs(step2)
                step1=round(step1/abs(step2))
            end
            x=round(grouplocation{p,lanes}(1,1)+step1)
            y=round(grouplocation{p,lanes}(1,2)+step2)
            if y<=200  && plaza(x,y)==0 
            if plaza(grouplocation{p,lanes}(1,1),grouplocation{p,lanes}(1,2))==1
                plaza(x,y)=1;
                plaza(grouplocation{p,lanes}(1,1),grouplocation{p,lanes}(1,2))=0;
            end
            if plaza(grouplocation{p,lanes}(1,1),grouplocation{p,lanes}(1,2))==2
            plaza(x,y)=2;
            plaza(grouplocation{p,lanes}(1,1),grouplocation{p,lanes}(1,2))=0;
            end
            if plaza(grouplocation{p,lanes}(1,1),grouplocation{p,lanes}(1,2))==3
            plaza(x,y)=3;
            plaza(grouplocation{p,lanes}(1,1),grouplocation{p,lanes}(1,2))=0;
            end
            elseif y>200
            plaza(grouplocation{p,lanes}(1,1),grouplocation{p,lanes}(1,2))=0;
                break;
            else
                break;
            end
            else
                break;
            end
        end
end 
end