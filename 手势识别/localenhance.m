function [ pic_enh ] = localenhance( graypic )
%LOCALENHANCE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
E=2.0; % ��Щ���������ʵ�����  �ֲ���ǿ
k0=0.4;
k1=0.02;
k2=0.4;
M=mean2(graypic);%����ȫ�ֻҶ�
D=std2(graypic);%����ȫ�ֱ�׼��
[m,n]=size(graypic);
pic_enh = zeros(m,n);
for x=2:m-1
    for y=2:n-1
        h=graypic(x-1:x+1,y-1:y+1);%ѡ��ÿ�����ص��3*3����
        m=mean2(h);%�ֲ��Ҷ�
        d=std2(h);%�ֲ����d
        if (m<=k0*M && d<=k2*D && d>=k1*D)
            pic_enh(x,y)=E*graypic(x,y);
        else
            pic_enh(x,y)=graypic(x,y);
        end
    end
end

end

