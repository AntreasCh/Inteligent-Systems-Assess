
clc
close all;
clear;
load model;
finalString=''
file = fopen('License_Plates.txt', 'wt');
Accuracy=0;
%filelines = strsplit(fileread('Compared_LCP.txt'), '\n');
for i=0:0 % how many pictures you want to select
    matFileName = sprintf('Cars%d.png', i);
Images=imread(matFileName);
[~,cc]=size(Images);
subplot(3,3,1) , imshow(Images)
Images=imresize(Images,[300 500]);
subplot(3,3,2) , imshow(Images)
if size(Images,3)==3 % Gray values can be either 0 or 1 to 255
  Images=rgb2gray(Images);  
end
subplot(3,3,3) , imshow(Images)
threshold = graythresh(Images); %Graythresh function applies the threshhold value
Images=medfilt2(Images);% remove noise from image
Images=imsharpen(Images);% sharrpen Image
subplot(3,3,4) , imshow(Images)
Images =~im2bw(Images,threshold);  %conver the image to binary image

Images = bwareaopen(Images,30); %  things that have less than 30 pixels are removed
subplot(3,3,5) , imshow(Images)
if cc>2000
    Image1=bwareaopen(Images,3500); % things that have less than 3500 pixels are removed except the license plate region
else
Image1=bwareaopen(Images,3000); % things that have less than 3000 pixels are removed except the license plate region
end
subplot(3,3,6) , imshow(Image1)
Image3=Images-Image1;  %only license  plate is left
subplot(3,3,7) , imshow(Image3)
Image3=bwareaopen(Image3,200);  %only the characters inside the license plate are left
subplot(3,3,8) , imshow(Image3)

[Z,M]=bwlabel(Image3); % the info matrix that the license plate has
Position=regionprops(Z,'BoundingBox');
hold on
pause(1)
for n=1:size(Position,1)
  rectangle('Position',Position(n).BoundingBox,'EdgeColor','g','LineWidth',1)
end
hold off
License_Plates=[];
t=[];
for n=1:M
  [r,c] = find(Z==n);
  Character=Images(min(r):max(r),min(c):max(c));%picture command crops nth object from L
  Character=imresize(Character,[42,24]);  %in database size is 42,24 so it is resized so that we can match it with the database
  pause(0.2)
  x=[ ];

TotalCharacters=size(imgfile,2);

 for k=1:TotalCharacters
    
    y=corr2(imgfile{1,k},Character);
    x=[x y];
    
 end
 t=[t max(x)];
 if max(x)>.45
 z=find(x==max(x));
 out=cell2mat(imgfile(2,z));
License_Plates=[License_Plates out];

 end

end
License_Plates
Lic=ocr(Image3);
cmp=strcmp(Lic,License_Plates);
if(cmp)
Accuracy=Accuracy+1;
end

lp=License_Plates;


 finalString = [finalString, ' ', License_Plates];
if License_Plates~=' '
fprintf(file,'%s\n\r',License_Plates);
end
end 
Accuracy
 
  fclose(file);                     
    winopen('License_Plates.txt')