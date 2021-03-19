%IDW（反距离加权插值法）
%其中x,y,z为已知坐标及其函数值,X,Y为要插值的坐标
%x,y,z,X,Y最高为二维的，不可为三维
%不考虑x，y中出现重复坐标的情况
function [Z]=IDW(x,y,z,X,Y)
[m0,n0]=size(x);
[m1,n1]=size(X);
%生成距离矩阵r(m0*m1*n1,n0)
for i=1:m1
    for j=1:n1
        r(m0*n1*(i-1)+m0*(j-1)+1:m0*n1*(i-1)+m0*(j),:)=sqrt((X(i,j)-x).^2+(Y(i,j)-y).^2);
    end
end
%定义插值函数
for i=1:m1
    for j=1:n1
        if find(r(m0*n1*(i-1)+m0*(j-1)+1:m0*n1*(i-1)+m0*(j),:)==0)
            [m2,n2]=find(r(m0*n1*(i-1)+m0*(j-1)+1:m0*n1*(i-1)+m0*(j),:)==0);
            Z(i,j)=z(m2,n2);
        else
            numerator=sum(sum(z./r(m0*n1*(i-1)+m0*(j-1)+1:m0*n1*(i-1)+m0*(j),:)));
            denominator=sum(sum(1./r(m0*n1*(i-1)+m0*(j-1)+1:m0*n1*(i-1)+m0*(j),:)));
            Z(i,j)=numerator/denominator;
        end
    end
end