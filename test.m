%потенциал флота 1/50 от количества клеточек с морем
Fig=[];
N=20;M=20; % размер поля
h=5; % сколько стран
K=100; %1/К - коэффициент для n_pot

Nat=creation(h,2);

Map0=rand([N M]);

Map0(Map0<0.3)=-1;
Map0(Map0>=0.3)=0;
Map=-ones(N+2,M+2);
Map(2:N+1,2:M+1)=Map0;
%image(abs(Map))


Nat_poz_x=randi(N,[h 1])+1;
Nat_poz_y=randi(M,[h 1])+1;
Map1=Map;

for i=1:h
   Map1(Nat_poz_x(i),Nat_poz_y(i))=i; 
   if find(Map1(Nat_poz_x(i)-1:Nat_poz_x(i)+1,Nat_poz_y(i)-1:Nat_poz_y(i)+1)==-1) 
       Nat(i).flot_pot=length(find(Map1(Nat_poz_x(i)-1:Nat_poz_x(i)+1,Nat_poz_y(i)-1:Nat_poz_y(i)+1)==-1))/K;
   end
   if length(find(Map1(Nat_poz_x(i)-1:Nat_poz_x(i)+1,Nat_poz_y(i)-1:Nat_poz_y(i)+1)>0))>1
       Nat(i).war_pot=Nat(i).war_pot+Nat(i).sci_pot/2;
       Nat(i).sci_pot=Nat(i).sci_pot/2;
   end
end

age=0; war_call=0; Historic=[];
while age<100
   age=age+1;
   %if war_call==0
   if war_call>0
       [n ~]=size(Historic);
       cou=Historic(n-war_call+1:n,2:3);
   else cou=0;
   end
   for i=1:h
       
       c=find(cou==i);
       if c %при войне!  
           vs=length(c);
           [n ~]=size(cou);
           for co=1:n
               if cou(co,1)==i
                   enemy=[enemy;cou(co,2)];
               elseif cou(co,2)==i
                   enemy=[enemy;cou(co,1)];
               end
           end
           if find(enemy==i)
               Nat(i).econ_pot=Nat(i).econ_pot*3/4
           end
           %все проседает...
           Nat(i).econ_pot=Nat(i).econ_pot*(10-length(enemy))/10;
           Nat(i).war_pot=Nat(i).war_pot*(12-length(enemy))/10;
           Nat(i).sci_pot=Nat(i).sci_pot*(10-length(enemy))/10;
           Nat(i).flot_pot=Nat(i).flot_pot*(10-length(enemy))/10;
           
           for co=1:length(enemy)
               if (Nat(i).econ*0.7+Nat(i).war+Nat(i).sci*0.5)>=(Nat(enemy(co)).econ*0.7+Nat(enemy(co)).war+Nat(enemy(co)).sci*0.5)
                   if Nat(i).flot>0.6
                        [x,y,~] = nearflot(i,Map1,enemy(co));
                        if x
                        xi=randi(length(x));
                        Map1(x(xi),y(xi))=i;
                        end
                   end
                   [x,y,~] = nearit(i,Map1,enemy(co));
                   if x
                        xi=randi(length(x));
                        Map1(x(xi),y(xi))=i;
                   end
               else
                   if Nat(enemy(co)).flot>0.6
                   [x,y,~] = nearflot(enemy(co),Map1,i);
                        if x
                        xi=randi(length(x));
                        Map1(x(xi),y(xi))=enemy(co);
                        end
                   end
                   [x,y,~] = nearit(enemy(co),Map1,i);
                   if x
                        xi=randi(length(x));
                        Map1(x(xi),y(xi))=enemy(co);
                   end
                   
               end
           end
           if Nat(i).war<0
               %проигрыш
               %каждой из других сторон часть территорий
               [x,y,~] = nearit(i,Map1,i);
               if x
                   a=length(x);
                   %enemy
                   warr=[];
                   for co=1:length(enemy)
                       warr=[warr;Nat(enemy(co)).war];
                   end;
                   for co=1:length(enemy)
                       parti=fix(a*warr/sum(warr));
                       for pari=1:parti
                           xi=randi(length(x));
                           Map1(x(xi),y(xi))=enemy(co);
                           x(xi)=[];y(xi)=[];
                       end
                   end
               end
               [m ~]=size(cou);
               [n ~]=size(Historic);
               for co=n-m+1:n
                if Historic(co,2)==i || Historic(co,3)==i
               
               
           end
                   
                   
                   
                   
               
               
               
               %менять порядок так, чтоб незаконченные всегда в конце!
               
               
       
         
       else
       Vw=Nat(i).war_pot/Nat(i).econ_pot;
       Vs=Nat(i).sci_pot/Nat(i).econ_pot;
       
       [x,y,~] = nearit(i,Map1,-1);
       if x
           Nat(i).flot_pot=length(x)/K;
           Nat(i).flot=Nat(i).flot+Nat(i).flot_pot;
       else
           Nat(i).flot_pot=0;
           Nat(i).flot=0;
       end
       
       
       if Nat(i).econ>0.75
            [x,y,~] = nearit(i,Map1,0);
            if x
                xi=randi(length(x));
                Map1(x(xi),y(xi))=i;
                Nat(i).econ=Nat(i).econ-0.1;
           end
       end
       if Nat(i).flot>0.5
            if Nat(i).econ>0.8
                [x,y,~] = nearflot(i,Map1,0);
                if x
                    xi=randi(length(x));
                    Map1(x(xi),y(xi))=i;
                    Nat(i).econ=Nat(i).econ-0.3;
                    Nat(i).flot=Nat(i).flot-2*Nat(i).flot_pot;
                end
            end
       end
       
       
       
       [x,y,~] = nearit(i,Map1,i);
       Nat(i).econ_pot=length(x)/K;
       Nat(i).econ=Nat(i).econ+Nat(i).econ_pot;
       
       Nat(i).war_pot=Vw*Nat(i).econ_pot;
       Nat(i).sci_pot=Vs*Nat(i).econ_pot;
       
       [x,y,vall] = nearit(i,Map1);
       if length(vall>0)
           f=length(vall>0);
       else
           f=0;
       end
       Nat(i).war=Nat(i).war+Nat(i).war_pot+f/K^2;
       Nat(i).sci=Nat(i).sci+Nat(i).sci_pot-f/K^2;
       %Nat(i).econ=Nat(i).econ-f/K;
       

        end
       end
   end
   
   wa=randi(100);
   if wa>95
       war_call=war_call+1;
       country1=randi(h);
       country2=randi(h);
       Historic=[Historic; age county1 country2 age];
   end
   if war_call>0
       [n ~]=size(Historic);
       Historic(n-war_call+1:n,4)=Historic(n-war_call+1:n,4)+1;
   end
   
  
   %pause(1);
   Fi=Map1;
   Fi(Fi==-1)=45;
   Fi(Fi==0)=20;
   Fi(Fi==1)=0;
   Fi(Fi==2)=7;
   Fi(Fi==3)=35;
   Fi(Fi==4)=50;
   Fi(Fi==5)=15;
   
   figure(1);image(Fi)
   colormap hsv
   text(1,1,int2str(age))
   Fi=getframe
   Fig(:,:,1,age)=rgb2ind(Fi.cdata,hsv(64));%Fi;
    
    
    
    
    
end

imwrite(Fig,hsv(64),'test.gif','DelayTime',0.2,'LoopCount',inf)




%figure();image(abs(Map1*5))


