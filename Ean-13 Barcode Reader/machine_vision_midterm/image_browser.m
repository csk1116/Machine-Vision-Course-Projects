function B = image_browser()
[filename]=uigetfile({'*.bmp'},'File selector');
B=imread(filename);

