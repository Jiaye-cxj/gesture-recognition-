function [pic_cut] = colour_cut(pic)
%COLOUR_CUT �˴���ʾ�йش˺�����ժҪ
%�˴���ʾ��ϸ˵�� 

%�ռ�ת��
se=fspecial('average',[3,3]);%ƽ���˲�
A=imfilter(pic,se);
imageR=A(:,:,1);
imageG=A(:,:,2);
imageB=A(:,:,3);
imageY=16+0.2568*imageR+0.5041*imageG+0.0979*imageB;
imageCg=128-0.318*imageR+0.4392*imageG-0.1212*imageB;
imageCr=128+0.4392*imageR-0.3677*imageG-0.0714*imageB;


Y=find(imageY<=230&imageY>=35);%����ͳ�Ƶ������ҳ����ڸ÷�Χ�����ص��±�
Cg=find(imageCg<=128&imageCg>=80);
Cr=find(imageCr<=173&imageCr>=131);
index=intersect(Cg,intersect(Y,Cr));%�ҳ�����ƽ��ķ�ɫ���꽻��
pic_cut=im2bw(A);%�����ֵͼ
pic_cut=zeros(size(pic_cut));%ȫͼ��Ϊ��ɫ
pic_cut(index)=1;%�ѷ�ɫ������Ϊ��ɫ
% figure
% imshow(BW)
end
