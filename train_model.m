clc;           
clear;        
close all;  
directory=dir('letters_numbers');
st={directory.name};
n=st(3:end);
imgfile=cell(2,length(n));
for i=1:length(n)
   imgfile(1,i)={imread(['letters_numbers','\',cell2mat(n(i))])};
   template=cell2mat(n(i));
   imgfile(2,i)={template(1)};
  
end
save('model.mat','imgfile');
clear;
 