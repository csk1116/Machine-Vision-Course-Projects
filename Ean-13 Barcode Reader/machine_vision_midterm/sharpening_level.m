function BC = sharpening_level(BCS,BC)
BC=double(BC);
BC=BC+1*BCS;
% BC=BC-min(min(BC));
% BC=BC*(256/max(max(BC)));
BC=uint8(BC);