function Nation = creation(number,   kolvo_rel)
%Создание number штук стран в массиве структур с kolvo_rel штук религий
% У каждой страны номер-название, показатели уровня и роста экономики,
% войны, науки, кораблестроения, номер религии
if nargin==1
    kolvo_rel=1;
end
for i=1:number
    econ=0.5+rand/2;
    war=0.5+rand/2;
    sci=1-war;
    relig=randi(kolvo_rel);
    co=struct('name',i,'econ',econ,'war',war,'sci',sci,'flot',0,'relig',relig,'econ_pot',econ/10,'war_pot',war/10,'sci_pot',sci/10,'flot_pot',0 );
    Nation(i)=co;
end

end

