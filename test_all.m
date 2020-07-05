Fig=[]; % Сохранение карты мира будет тут
colormap colorcube
name='test_big6.gif';
%% Основные параметры мира

N=20;M=20; % размер поля
h=randi(3)+5 %20; % сколько стран
r=10; % сколько религий
K=200; % 1/К - коэффициент для flot_pot
sea=0.1; % коэффициент моря
Period=200;%(N+M)*3*h; % сколько лет рассматриваем

per=4;
pob=2;
pobk=1;

war_K=95; % порог начала войны
%% Создание мира
Nat=creation(h,r); % создание стран с начальными параметрами

Map0=rand([N M]); % создание окруженного морем континента
Map0(Map0<sea)=-1;
Map0(Map0>=sea)=0;
Map=-ones(N+2,M+2);
Map(2:N+1,2:M+1)=Map0; 

Map_econ=rand([N+2 M+2])/10+0.05; % создание экономической карты мира
Map_econ(find(Map==-1))=0;

Map_war=rand([N+2 M+2])/20+0.05; % создание военной карты мира
Map_war(find(Map==-1))=0;

Map_sci=rand([N+2 M+2])/20+0.05; % создание научной карты мира
Map_sci(find(Map==-1))=0;


Nat_poz_x=randi(N,[h 1])+1; %определение столиц/начала стран
Nat_poz_y=randi(M,[h 1])+1;
Map1=Map;
Mmap=Map1*0;
for i=1:h
    Map1(Nat_poz_x(i),Nat_poz_y(i))=i; 
    [x,y,val] = nearit(i,Map1,0);
    if x
        for k=1:length(x)
            Map1(x(k),y(k))=i;
        end
    end
    Nat(i).econ_pot=Map_econ(Nat_poz_x(i),Nat_poz_y(i));
    Nat(i).flot_pot=length(find(val==-1))/K;
    Nat(i).war_pot=Map_war(Nat_poz_x(i),Nat_poz_y(i));
    Nat(i).sci_pot=Map_sci(Nat_poz_x(i),Nat_poz_y(i));
end

%% История
age=0; % год событий
war_call=0; % количество войн на данный момент
Historic=[0 0 0 0]; % история войн
list_of_enemy=[]; % список текущих противников и лет войны
age_of_war=[];

list_of_co=1:h;

while age<Period
% % %     ro=randi(20);
% % %     if ro>12
% % %         Map_econ=Map_econ*1.01;
% % %         Map_war=Map_war*1.01;
% % %         Map_sci=Map_sci*1.01;
% % %     end;
        
    
    
    age=age+1;
% % %     Map_econ(find(Map_econ>10))=10;
% % %     Map_war(find(Map_war>10))=10;
% % %     Map_sci(find(Map_sci>10))=10;
    
    for i=1:h %для каждой страны
        
        if length(find(Map1==i))>0 % если страна еще существует
            %раздробленность
            if length(find(Map1==i))>(N+M)
                ro=18;
            else
                ro=4;
            end
            ro=randi(ro);
            
            if ((Nat(i).econ+Nat(i).sci)<2.5*Nat(i).war && h<60 && age>10 && length(Map1(i))>8) || (ro==8 )
                a=find(Map1==i);
                f=randi(length(a));
                Map1(a(f))=h+1;

                Nat(h+1)=creation(1,r);
                [x,y,val] = nearit(h+1,Map1,i);
                if x
                    for k=1:length(x)
                            Map1(x(k),y(k))=h+1;
                    end
                end
                Nat(h+1).econ_pot=Map_econ(a(f));
                Nat(h+1).flot_pot=length(find(val==-1))/K;
                Nat(h+1).war_pot=Map_war(a(f));
                Nat(h+1).sci_pot=Map_sci(a(f));
                h=h+1
                %Period=(N+M)*3*h;
            end
            
            %Штраф к длинной границе.
            [x,y,val] = nearit(i,Map1);
            val(find(val==-1))=[];
            Leg=length(Map1==i);
            Leg_gran=length(val);
            if Leg_gran/Leg>1.5
                Nat(i).econ=Nat(i).econ*0.8;
                Nat(i).war=Nat(i).war*0.7;
                Nat(i).sci=Nat(i).sci*0.8;
                Nat(i).flot=Nat(i).flot*1.1;
            end
            
            if length(find(list_of_enemy==i))==0
                % мирное время
                % растет прибыльность клеточек
% % %                 Map_econ(find(Map1==i))=Map_econ(find(Map1==i))*1.001;
% % %                 Map_war(find(Map1==i))=Map_war(find(Map1==i))*1.001;
% % %                 Map_sci(find(Map1==i))=Map_sci(find(Map1==i))*1.001;
                
  
                Nat(i).econ_pot=sum(Map_econ(find(Map1==i)));
                Nat(i).war_pot=sum(Map_war(find(Map1==i)));
                Nat(i).sci_pot=sum(Map_sci(find(Map1==i)));
                [x,y,val] = nearit(i,Map1);
                Nat(i).flot_pot=length(find(val==-1))/K;
                % растет экономика и военная мощь
                Nat(i).econ=Nat(i).econ+Nat(i).econ_pot;
                Nat(i).war=Nat(i).war+Nat(i).war_pot;
                Nat(i).sci=Nat(i).sci+Nat(i).sci_pot;
                Nat(i).flot=Nat(i).flot+Nat(i).flot_pot;
                
% % %                 for j=1:length(x)
% % %                     if val(j)==0 
% % %                         Map_econ(x(j),y(j))=Map_econ(x(j),y(j))*1.001;
% % %                         Map_war(x(j),y(j))=Map_war(x(j),y(j))*1.001;
% % %                         Map_sci(x(j),y(j))=Map_sci(x(j),y(j))*1.001;
% % %                     end
% % %                 end
                % к пулу интересных клеток добавляются заморские при
                % достаточном флоте
                if Nat(i).flot>0.5 && Leg_gran/Leg<1.5
                    [xf,yf,valf] = nearflot(i,Map1);
                    x=[x;xf];y=[y;yf];val=[val;valf];
                else
                    xf=[];
                end
                
                maxi=-100;
                max_w=-100;
                xjw=0;
                x(find(val==-1))=[];
                y(find(val==-1))=[];
                val(find(val==-1))=[];
                for j=1:length(x)
                    if val(j)==0 
% %                         Map_econ(x(j),y(j))=Map_econ(x(j),y(j))*1.1;
% %                         Map_war(x(j),y(j))=Map_war(x(j),y(j))*1.1;
% %                         Map_sci(x(j),y(j))=Map_sci(x(j),y(j))*1.1;
                        
                        if maxi<(Map_econ(x(j),y(j))-Map_war(x(j),y(j))/2-Map_sci(x(j),y(j))/2)
                            if j>(length(x)-length(xf))
                                ro=randi(10);
                                if ro==10 && maxi<(Map_econ(x(j),y(j))-Map_war(x(j),y(j))/2-Map_sci(x(j),y(j))/2)/2
                                    maxi=(Map_econ(x(j),y(j))-Map_war(x(j),y(j))/2-Map_sci(x(j),y(j))/2)/2;
                                    xj=x(j);
                                    yj=y(j);
                                end
                            else
                                maxi=Map_econ(x(j),y(j))-Map_war(x(j),y(j))/2-Map_sci(x(j),y(j))/2;
                                xj=x(j);
                                yj=y(j);
                            end
                        end
                    elseif val(j)>0
                        if max_w<Map_econ(x(j),y(j))*Nat(i).war/Nat(val(j)).war*0.75-Map_war(x(j),y(j))-Map_sci(x(j),y(j))
                            max_w=Map_econ(x(j),y(j))*Nat(i).war/Nat(val(j)).war*0.75-Map_war(x(j),y(j))-Map_sci(x(j),y(j));
                            xjw=x(j);
                            yjw=y(j);
                        end
                    end
                end
                if xjw
                    if Map1(xjw,yjw)>0
                        %к войне
                        %по религиозным причинам
                        if Nat(Map1(xjw,yjw)).relig==Nat(i).relig
                            ver=20;
                        else
                            ver=10;
                        end

                        %по историческим причинам
                        if length(find( (Historic(:,2)*10+Historic(:,3)) == (Map1(xjw,yjw)*10+i) ))>0 || length(find( (Historic(:,2)*10+Historic(:,3)) == (i*10+Map1(xjw,yjw)) ))>0
                            ver=fix(ver/4*3);
                        end
                        ran=randi(ver);
                    else
                        ran=0;
                        ver=0;
                    end 
                else
                        ran=0;
                        ver=0;
                        Map1(xj,yj)=i;
                end
               
                if 0.25*max_w>maxi && ran==1
                    country2=Map1(xjw,yjw); %объявление войны по случаю территорий
                    country1=i;
                    war_call=war_call+1;
                    Historic=[Historic; age country1 country2 age];
                    list_of_enemy=[list_of_enemy; country1 country2]; 
                    age_of_war=[age_of_war; 0];
                    
                    
                else
                    Map1(xj,yj)=i;
                end
            else
                %%%%%%%%%%%%%%%%%%%%%  1/15 ->  1/10
                % военное время
% % %                 Map_econ(find(Map1==i))=Map_econ(find(Map1==i))*((2*h)-length(find(list_of_enemy==i)))/(3*h);
% % %                 Map_war(find(Map1==i))=Map_war(find(Map1==i))*((2*h)-length(find(list_of_enemy==i)))/(2*h);
% % %                 Map_sci(find(Map1==i))=Map_sci(find(Map1==i))*((2*h)-length(find(list_of_enemy==i)))/(3*h);
                
                % падает экономика и военная мощь
                Nat(i).econ=Nat(i).econ*(2*h-length(find(list_of_enemy==i)))/(2*h);
                Nat(i).war=Nat(i).war*(2*h-length(find(list_of_enemy==i)))/(2*h);
                Nat(i).sci=Nat(i).sci*(2*h-length(find(list_of_enemy==i)))/(2*h);
                Nat(i).flot=Nat(i).flot*(2*h-length(find(list_of_enemy==i)))/(2*h);
                
                [x,y,val] = nearit(i,Map1);
            end
        else
            if length(find(list_of_enemy==i))>0
                end_war=[];
                for n=1:length(age_of_war)
                    if list_of_enemy(n,1)==i || list_of_enemy(n,2)==i
                        
                        
                        
                        country1=list_of_enemy(n,1);
                        country2=list_of_enemy(n,2);
                        age_of_end=age;
                        [mn ~]=size(Historic);
                        j=mn;
                        while j>0
                            if Historic(j,2)==country1 && Historic(j,3)==country2
                                Historic(j,4)=age_of_end;
                            end
                            j=j-1;
                        end
                        end_war=[end_war; n];
                    end
                end
                list_of_enemy(end_war,:)=[];
                age_of_war(end_war)=[];
            end

            
        end
    end
    if length(age_of_war)>0
        %[n m]=size(list_of_enemy); %n колво столбцов
        end_war=[];
        for n=1:length(age_of_war)
            i=list_of_enemy(n,1);
            j=list_of_enemy(n,2);
            if (Nat(i).econ*0.4+Nat(i).war+Nat(i).sci*0.3)>=(Nat(j).econ*0.4+Nat(j).war+Nat(j).sci*0.3)
                %сильнее первый
                [x,y,~] = nearit(i,Map1,j);
                
                [xp,yp,val] = nearit(i,Map1);
                val(find(val==-1))=[];
                Leg=length(Map1==i);
                Leg_gran=length(val);
                if Nat(i).flot>0.5 && Leg_gran/Leg<1.5
                    [xf,yf,~] = nearflot(i,Map1,j);
                    x=[x;xf];y=[y;yf];
                end
                if x
                    maxi=0;
                    for k=1:length(x)
                            if maxi<Map_econ(x(k),y(k))
                                maxi=Map_econ(x(k),y(k));
                                xi=x(k);
                                yi=y(k);
                            end
                    end
                    Map1(xi,yi)=i;
                else
                    [x,y,~] = nearit(i,Map1,0);
                    if Nat(i).flot>0.5 && Leg_gran/Leg<1.5
                        [xf,yf,~] = nearflot(i,Map1,0);
                        x=[x;xf];y=[y;yf];
                    end
                    if x
                        maxi=0;
                        for k=1:length(x)
                                if maxi<Map_econ(x(k),y(k))
                                    maxi=Map_econ(x(k),y(k));
                                    xi=x(k);
                                    yi=y(k);
                                end
                        end
                        Map1(xi,yi)=i;
                    end
                end
            else
                % сильнее второй
                i=list_of_enemy(n,2);
                j=list_of_enemy(n,1);
                [x,y,~] = nearit(i,Map1,j);
                [xp,yp,val] = nearit(i,Map1);
                val(find(val==-1))=[];
                Leg=length(Map1==i);
                Leg_gran=length(val);
                if Nat(i).flot>0.5 && Leg_gran/Leg<1.5
                    [xf,yf,~] = nearflot(i,Map1,j);
                    x=[x;xf];y=[y;yf];
                end
                if x
                    maxi=0;
                    for k=1:length(x)
                            if maxi<Map_econ(x(k),y(k))
                                maxi=Map_econ(x(k),y(k));
                                xi=x(k);
                                yi=y(k);
                            end
                    end
                    Map1(xi,yi)=i;
                else
                    [x,y,~] = nearit(i,Map1,0);
                    if Nat(i).flot>0.5 && Leg_gran/Leg<1.5
                        [xf,yf,~] = nearflot(i,Map1,0);
                        x=[x;xf];y=[y;yf];
                    end
                    if x
                        maxi=0;
                        for k=1:length(x)
                                if maxi<Map_econ(x(k),y(k))
                                    maxi=Map_econ(x(k),y(k));
                                    xi=x(k);
                                    yi=y(k);
                                end
                        end
                        Map1(xi,yi)=i;
                    end
                end
            end
            if age_of_war(n)
                ran=randi(age_of_war(n));
            else
                ran=0;
            end
            if ran>10
                %перемирие %1/4
                i=list_of_enemy(n,1);
                j=list_of_enemy(n,2);
                if (Nat(i).econ*0.3+Nat(i).war+Nat(i).sci*0.4)>=(Nat(j).econ*0.3+Nat(j).war+Nat(j).sci*0.4)
                    %победил первый, отнимает территорию
                    
                    [x,y,~] = nearit(i,Map1,j);
                    if Nat(i).flot>0.45
                        [xf,yf,~] = nearflot(i,Map1,j);
                        x=[x;xf];y=[y;yf];
                    end
                    if x
                        for k=1:length(x)
                            ro=randi(per);%%%
                            if ro==1
                                Map1(x(k),y(k))=i;
                            end
                        end
                    end
                    
                else
                    i=list_of_enemy(n,2);
                    j=list_of_enemy(n,1);
                    %победил второй, отнимает территорию
                    
                    [x,y,~] = nearit(i,Map1,j);
                    if Nat(i).flot>0.45
                        [xf,yf,~] = nearflot(i,Map1,j);
                        x=[x;xf];y=[y;yf];
                    end
                    if x
                        for k=1:length(x)
                            ro=randi(per);%%%
                            if ro==1
                                Map1(x(k),y(k))=i;
                            end
                        end
                    end
                    
                end
                end_war=[end_war; n];
            end
            
            %%полная победа %1/2
            i=list_of_enemy(n,1);
            j=list_of_enemy(n,2);
            if (Nat(i).econ*0.3+Nat(i).war+Nat(i).sci*0.4)>=(Nat(j).econ*0.3+Nat(j).war+Nat(j).sci*0.4)*10
                for t=1:pobk%%%
                    [x,y,~] = nearit(i,Map1,j);
                    if Nat(i).flot>0.45
                        [xf,yf,~] = nearflot(i,Map1,j);
                        x=[x;xf];y=[y;yf];
                    end
                    if x
                        for k=1:length(x)
                            ro=randi(pob);%%%
                            if ro==1
                                Map1(x(k),y(k))=i;
                            end
                        end
                    end
                end
                end_war=[end_war; n];
            elseif (Nat(i).econ*0.3+Nat(i).war+Nat(i).sci*0.4)*10<=(Nat(j).econ*0.3+Nat(j).war+Nat(j).sci*0.4)
                i=list_of_enemy(n,2);
                j=list_of_enemy(n,1);
                for t=1:pobk%%%
                    [x,y,~] = nearit(i,Map1,j);
                    if Nat(i).flot>0.45
                        [xf,yf,~] = nearflot(i,Map1,j);
                        x=[x;xf];y=[y;yf];
                    end
                    if x
                        for k=1:length(x)
                            ro=randi(pob);%%%
                            if ro==1
                                Map1(x(k),y(k))=i;
                            end
                        end
                    end
                end
                end_war=[end_war; n];
            end
            
        end
    end
    
    if length(age_of_war)>0
        for i=1:length(age_of_war)
            if end_war
                if find(end_war==i)
                    %найти в хисторике нужную строчку и задать год
                    %конца
                    country1=list_of_enemy(i,1);
                    country2=list_of_enemy(i,2);
                    age_of_end=age;
                    [n ~]=size(Historic);
                    j=n;
                    while j>0
                        if Historic(j,2)==country1 && Historic(j,3)==country2
                            Historic(j,4)=age_of_end;
                        end
                        j=j-1;
                    end
                end
            else
                age_of_war(i)=age_of_war(i)+1;
            end
        end
        if end_war
            age_of_war(end_war)=[];
            list_of_enemy(end_war,:)=[];
        end
    end
    
    %демонстрация
    Fi=Map1;
% %     Fi(Fi==5)=63; %jet
% %     Fi(Fi==4)=50;
% %     Fi(Fi==3)=45;
% %     Fi(Fi==2)=25;
% %     Fi(Fi==1)=40;
% %     
% %     Fi(Fi==0)=35;
% %     Fi(Fi==-1)=0;

    
    
    
    
    
    Fi(Fi>0)=Fi(Fi>0)-fix(Fi(Fi>0)/55)*55;
    
    Fi(Fi==0)=63;
    Fi(Fi==-1)=64;
    figure(1);image(Fi)
    %colormap colorcube
    text(1,1,int2str(age))
    Fi=getframe;
    Fig(:,:,1,age)=rgb2ind(Fi.cdata,colorcube(64));
    
    
    if age==Period && sum(sum(Mmap-Map1))~=0
        Mmap=Map1;
        Period=Period+10;
    end
        
    
    
end

%%imwrite(Fig(:,:,:,1:800),colorcube(64),name,'DelayTime',0.15,'LoopCount',inf)

