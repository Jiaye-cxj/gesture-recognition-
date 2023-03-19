function [pic_cut] = colour_cut(pic)
%COLOUR_CUT 此处显示有关此函数的摘要
%此处显示详细说明 

%空间转换
se=fspecial('average',[3,3]);%平滑滤波
A=imfilter(pic,se);
imageR=A(:,:,1);
imageG=A(:,:,2);
imageB=A(:,:,3);
imageY=16+0.2568*imageR+0.5041*imageG+0.0979*imageB;
imageCg=128-0.318*imageR+0.4392*imageG-0.1212*imageB;
imageCr=128+0.4392*imageR-0.3677*imageG-0.0714*imageB;


Y=find(imageY<=230&imageY>=35);%根据统计的数据找出处在该范围的像素的下标
Cg=find(imageCg<=128&imageCg>=80);
Cr=find(imageCr<=173&imageCr>=131);
index=intersect(Cg,intersect(Y,Cr));%找出三个平面的肤色坐标交集
pic_cut=im2bw(A);%构造二值图
pic_cut=zeros(size(pic_cut));%全图置为黑色
pic_cut(index)=1;%把肤色区域置为白色
% figure
% imshow(BW)
end
