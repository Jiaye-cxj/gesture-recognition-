function [pic_cut] = threshold_cut(pic)
%THRESHOLD_CUT 此处显示有关此函数的摘要
%此处显示详细说明

se = strel('disk', 5); %构造结构元素
pictop = imtophat(pic, se);  % 高帽变换
picbot = imbothat(pic, se);  % 低帽变换
% figure, imshow(pictop, []);   % 高帽变换，体现原始图像的灰度峰值
% figure, imshow(picbot, []);   % 低帽变换，体现原始图像的灰度谷值
picenhance = imsubtract(imadd(pictop, pic), picbot);% 高帽图像与低帽图像相减，增强图像
% figure, imshow(picenhance);
% figure,imhist(picenhance);
pic_half=im2bw(picenhance,40/255); % im2bw函数需要将灰度值转换到[0,1]范围内
% level=graythresh(picenhance);     %确定灰度阈值 自动阈值法：Otsu法
% pic_half=~im2bw(pic,level); 
pic_half = bwareaopen(pic_half,100); %清除小面积块，可更改阈值
se = strel('disk',round(numel(pic_half)/15000));
pic_cut = imclose(pic_half,se); %闭操作

end

