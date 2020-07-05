function [x,y,vall] = nearflot(c,Map, what)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
[N M]=size(Map);
x=[];y=[];vall=[];


    for i=3:N-2
        for j=3:M-2
            if Map(i,j)==c
                if Map(i-1,j-1)==-1
                    x=[x;i-2;i-2;i-2;i-1;i];
                    y=[y;j;j-1;j-2;j-2;j-2];
                end
                if Map(i,j-1)==-1
                    x=[x;i-1;i;i+1];
                    y=[y;j-2;j-2;j-2];
                end
                if Map(i+1,j-1)==-1
                    x=[x;i+2;i+2;i+2;i+1;i];
                    y=[y;j;j-1;j-2;j-2;j-2];
                end
                if Map(i+1,j)==-1
                    x=[x;i+2;i+2;i+2];
                    y=[y;j-1;j;j+1];
                end
                if Map(i+1,j+1)==-1
                    x=[x;i+2;i+2;i+2;i+1;i];
                    y=[y;j;j+1;j+2;j+2;j+2];
                end    
                if Map(i,j+1)==-1
                    x=[x;i-1;i;i+1];
                    y=[y;j+2;j+2;j+2];
                end    
                if Map(i-1,j+1)==-1
                    x=[x;i-2;i-2;i-2;i-1;i];
                    y=[y;j;j+1;j+2;j+2;j+2];
                end      
                if Map(i-1,j)==-1
                    x=[x;i-2;i-2;i-2];
                    y=[y;j-1;j;j+1];
                end    
            end
        end
    end
if x
X=x*10000*N+y;
X=unique(X);
x=fix(X/10000/N);
y=X-x*10000*N;

for i=1:length(x)
vall=[vall;Map(x(i),y(i))];
end

if nargin==2
    x(find(vall==c))=[];
    y(find(vall==c))=[];
    vall(find(vall==c))=[];
    
else
    if find(vall==what)
    x=x(find(vall==what));
    y=y(find(vall==what));
    vall=vall(find(vall==what));
    else
    x=[];y=[];vall=[]; 
    end
end
else    
x=[];y=[];vall=[]; 
end    
    
    
    
end

