function [ pic_enh ] = localenhance( graypic )
%LOCALENHANCE 此处显示有关此函数的摘要
%   此处显示详细说明
E=2.0; % 这些参数可以适当调整  局部增强
k0=0.4;
k1=0.02;
k2=0.4;
M=mean2(graypic);%计算全局灰度
D=std2(graypic);%计算全局标准差
[m,n]=size(graypic);
pic_enh = zeros(m,n);
for x=2:m-1
    for y=2:n-1
        h=graypic(x-1:x+1,y-1:y+1);%选择每个像素点的3*3邻域
        m=mean2(h);%局部灰度
        d=std2(h);%局部穷差d
        if (m<=k0*M && d<=k2*D && d>=k1*D)
            pic_enh(x,y)=E*graypic(x,y);
        else
            pic_enh(x,y)=graypic(x,y);
        end
    end
end

end

