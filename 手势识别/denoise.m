function [ pic_cut ] = denoise( pic )
%DENOISE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
IM= bwareaopen(pic,round(1/20*numel(pic)));%�Ѱ������ص��ٵİ�ɫ����ȥ��
% figure
% imshow(IM);
se = strel('disk',round(numel(IM)/15000));
IM=imopen(IM,se);%������
% figure
% imshow(IM)
IM= bwareaopen(IM,round(1/20*numel(IM)));%�Ѱ������ص��ٵİ�ɫ����ȥ��
% figure
% imshow(IM)
se=fspecial('average',[5,5]);%ƽ���˲�
pic_cut=imfilter(IM,se);
% figure
% imshow(pic_cut)
end

