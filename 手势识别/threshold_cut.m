function [pic_cut] = threshold_cut(pic)
%THRESHOLD_CUT �˴���ʾ�йش˺�����ժҪ
%�˴���ʾ��ϸ˵��

se = strel('disk', 5); %����ṹԪ��
pictop = imtophat(pic, se);  % ��ñ�任
picbot = imbothat(pic, se);  % ��ñ�任
% figure, imshow(pictop, []);   % ��ñ�任������ԭʼͼ��ĻҶȷ�ֵ
% figure, imshow(picbot, []);   % ��ñ�任������ԭʼͼ��ĻҶȹ�ֵ
picenhance = imsubtract(imadd(pictop, pic), picbot);% ��ñͼ�����ñͼ���������ǿͼ��
% figure, imshow(picenhance);
% figure,imhist(picenhance);
pic_half=im2bw(picenhance,40/255); % im2bw������Ҫ���Ҷ�ֵת����[0,1]��Χ��
% level=graythresh(picenhance);     %ȷ���Ҷ���ֵ �Զ���ֵ����Otsu��
% pic_half=~im2bw(pic,level); 
pic_half = bwareaopen(pic_half,100); %���С����飬�ɸ�����ֵ
se = strel('disk',round(numel(pic_half)/15000));
pic_cut = imclose(pic_half,se); %�ղ���

end

