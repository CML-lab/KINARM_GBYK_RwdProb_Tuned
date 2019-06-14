im = zeros(25,25,3);
im(:,:,1) = 1;
imshow(im)

%pct = [0.2 0.3 0.5 0.7 0.80];
pct = [1 2 3 5 6 7]/8;
pct = repmat(pct,1,1);

for p = 1:length(pct)
    
    im1 = im;
    
    if abs(pct(p)-(1/8)) < 1e-5
        figpct = 0.37;
        luminance = 1;
        plt = 1;
    elseif abs(pct(p)-(2/8)) < 1e-5
        figpct = 0.415;
        luminance = .965;
        plt = 2;
    elseif abs(pct(p)-(3/8)) < 1e-5
        figpct = 0.48;
        luminance = .93;
        plt = 3;
    elseif abs(pct(p)-(5/8)) < 1e-5
        figpct = 0.53;
        luminance = .895;
        plt = 6;
    elseif abs(pct(p)-(6/8)) < 1e-5
        figpct = 0.59;
        luminance = .86;
        plt = 5;
    elseif abs(pct(p)-(7/8)) < 1e-5
        figpct = 0.66;
        luminance = .825;
        plt = 4;
    end
    figpct = figpct-.07;
    
    while abs(sum(sum(im1(:,:,1)==1))/(size(im1(:,:,1),1)*size(im1(:,:,1),2)) - figpct) > 0.05  % - (1-pct(p))
        %do regenerate noisy figure until we are sure that we are within
        %the desired tolerance

        %im1 = imnoise(im,'salt & pepper',pct(p));
        %for a = 1:30
        %    for b = 1:30
        %        if isequal(squeeze(im1(a,b,:)),[1 0 0]')
        %            continue;
        %        else
        %            im1(a,b,:) = [0 0 1];
        %        end
        %    end
        %end
        
        %do this manually without using the image processing toolbox imnoise
        im1 = im;
        imr = im1(:,:,1);
        %imb = im1(:,:,3);
        x = rand(size(imr));
        imr(x>figpct) = 0;
        %imb(x>figpct) = 1;
        %im1(:,:,1) = imr;
        %im1(:,:,3) = imb;
        tmp = find(imr == 0);
        tmpimr = imr;
        tmpimg = zeros(size(imr));
        tmpimb = zeros(size(imr));
        tmpimr(tmp) = 80/255;
        tmpimg(tmp) = 80/255;
        tmpimb(tmp) = 80/255;
        im1 = cat(3,tmpimr,tmpimg,tmpimb);
        
    end
    
    tmpimr = squeeze(im1(:,:,1));
    tmpimr(tmpimr == 1) = luminance;
    im1(:,:,1) = tmpimr;
    
    p1 = strrep(num2str(pct(p)),'0.','');
    if length(p1) == 1
        p1 = [p1 '00'];
    elseif length(p1) == 2
        p1 = [p1 '0'];
    end
    p2 = strrep(num2str(1-pct(p)),'0.','');
    if length(p2) == 1
        p2 = [p2 '00'];
    elseif length(p2) == 2
        p2 = [p2 '0'];
    end
    
    fname = sprintf('_redgray%s-%sa.png',p1,p2);
    
    iadd = char('a'-1);
    tmpfname = fname;
    
    while exist(tmpfname,'file')
        iadd = char(iadd+1);
        tmpfname = strrep(fname,'a.png',[iadd '.png']);
    end
    %if strcmp(iadd,char('a'-1))
    
    fname = tmpfname;
    imwrite(im1,fname);
    
    figure(1);
    subplot(2,3,plt);
    imshow(im1);

end