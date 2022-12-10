
%find the T by Otsu method
function  T = OSTU(B)
%find the frequency of each greyvalue
S=size(B);
I=S(1,1);
J=S(1,2);

G=zeros(256,1);

for greyvalue=0:255
               n=0;
    for i=1:I
        for j=1:J
            if B(i,j)==greyvalue
               n=n+1;
            else
                continue
            end
        end
    end
           G(greyvalue+1,1)=n;
end

%calculate the G1(greyvalue & P(greyvalue) & 1-P(greyvalue) & w1 w2 & u1 u2 & v1 v2)
k=0;
for i=1:256
    if G(i,1)>0
       k=k+1;
    else
        continue
    end
end
%p1 & ut
G1=zeros(k,9);
m=0;
ut=0;
for i=1:256
    if G(i,1)~=0
        m=m+1;
        G1(m,1)=i-1;
        G1(m,2)=G(i,1)/(I*J);
        G1(m,3)=(G(i,1)/(I*J))*(i-1);
        ut=ut+G1(m,3);
    else
        continue
    end
end


%w1 w2
G1(1,4)=G1(1,2);
for i=2:k
    G1(i,4)=G1(i,2)+G1(i-1,4);
end

for i=1:k
    G1(i,5)=1-G1(i,4);
end

%u1 u2

u1=0;
for i=1:k
    u1=u1+G1(i,2)*G1(i,1);
    G1(i,6)=u1/G1(i,4);
end

u2=0;
G1(k,7)=0;
for i=1:k-1
    u2=u2+G1(k+1-i,2)*G1(k+1-i,1);
    G1(k-i,7)=u2/G1(k-i,5);
end

% vb^2

for i=1:k
    G1(i,8)=G1(i,4)*(G1(i,6)-ut)^2 + G1(i,5)*(G1(i,7)-ut)^2;
end

% find max vb^2 
V=zeros(k,1);
for i=1:k
    V(i,1)=G1(i,8);
end
[~,II]=max(V);
T=G1(II,1);

%use it as a threshold

% for i=1:I
%     for j=1:J
%         if B(i,j)<T
%             B(i,j)=0;
%         else
%             B(i,j)=255;
%         end
%     end
% end








