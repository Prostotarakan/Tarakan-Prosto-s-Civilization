function [x,y,vall] = nearit(c,Map,   what)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
[N M]=size(Map);
x=[];y=[];vall=[];

if nargin==2
for i=2:N-1
    for j=2:M-1
        if Map(i,j)==c
%             if Map(i-1,j-1)~=c
%                 x=[x;i-1];y=[y;j-1];
%             end
            if Map(i,j-1)~=c
                x=[x;i];y=[y;j-1];
            end
%             if Map(i+1,j-1)~=c
%                 x=[x;i+1];y=[y;j-1];
%             end
            if Map(i-1,j)~=c
                x=[x;i-1];y=[y;j];
            end
            if Map(i+1,j)~=c
                x=[x;i+1];y=[y;j];
            end
%             if Map(i-1,j+1)~=c
%                 x=[x;i-1];y=[y;j+1];
%             end
            if Map(i,j+1)~=c
                x=[x;i];y=[y;j+1];
            end
%             if Map(i+1,j+1)~=c
%                 x=[x;i+1];y=[y;j+1];
%             end
        end;
        
    end
end
else
    
if what~=c    
    
for i=2:N-1
    for j=2:M-1
        if Map(i,j)==c
%             if Map(i-1,j-1)==what
%                 x=[x;i-1];y=[y;j-1];
%             end
            if Map(i,j-1)==what
                x=[x;i];y=[y;j-1];
            end
%             if Map(i+1,j-1)==what
%                 x=[x;i+1];y=[y;j-1];
%             end
            if Map(i-1,j)==what
                x=[x;i-1];y=[y;j];
            end
            if Map(i+1,j)==what
                x=[x;i+1];y=[y;j];
            end
%             if Map(i-1,j+1)==what
%                 x=[x;i-1];y=[y;j+1];
%             end
            if Map(i,j+1)==what
                x=[x;i];y=[y;j+1];
            end
%             if Map(i+1,j+1)==what
%                 x=[x;i+1];y=[y;j+1];
%             end
        end
        
    end
end
else
    for i=2:N-1
        for j=2:M-1
            if Map(i,j)==c
                x=[x;i];y=[y;j];
            end
        end
    end
    
    
    
    
end
end

x0=x;y0=y;
x=[];y=[];
X=x0*10000*N+y0;
X=unique(X);
x=fix(X/10000/N);
y=X-x*10000*N; 

vall=[];
for i=1:length(x)
    vall=[vall;Map(x(i),y(i))];
end
    

end

