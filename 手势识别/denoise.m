function [ pic_cut ] = denoise( pic )
%DENOISE 此处显示有关此函数的摘要
%   此处显示详细说明
IM= bwareaopen(pic,round(1/20*numel(pic)));%把包含像素点少的白色区域去除
% figure
% imshow(IM);
se = strel('disk',round(numel(IM)/15000));
IM=imopen(IM,se);%开操作
% figure
% imshow(IM)
IM= bwareaopen(IM,round(1/20*numel(IM)));%把包含像素点少的白色区域去除
% figure
% imshow(IM)
se=fspecial('average',[5,5]);%平滑滤波
pic_cut=imfilter(IM,se);
% figure
% imshow(pic_cut)
end

