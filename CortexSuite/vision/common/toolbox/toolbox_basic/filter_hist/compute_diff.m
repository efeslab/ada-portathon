function B = compute_diff(Ja,Jfa,hw,hnb);
%
%    B = compute_diff(Ja,Jfa,hw,hnb)
%
%

figure(1);%imagesc(Ja);axis('image');
cs = round(ginput(1));

B = zeros(2*hnb+1,2*hnb+1);

scales = [1:5];filter_ids = [1:7];
Jc = get_win(Ja,cs,[hw,hw]);
Jfc= get_win5(Jfa,cs,[hw,hw]);
H2c = hist2d(Jc,Jfc,scales,filter_ids);

figure(2);imagesc(Ja);axis('image');colormap(gray);
hold on; plot(cs(1),cs(2),'g*');


for ii=-hnb:hnb,
  for jj=-hnb:hnb,
     J1 = get_win(Ja,cs+4*[jj,ii],[hw,hw]);
     Jf1= get_win5(Jfa,cs+4*[jj,ii],[hw,hw]);
     figure(2);plot(cs(1)+4*jj,cs(2)+4*ii,'ro');drawnow;
     %figure(3);imagesc(J1);drawnow;

     H2 = hist2d(J1,Jf1,scales,filter_ids);
     d = hist_diff(H2/prod(size(Jc)),H2c/prod(size(Jc)));
     disp(sprintf('d=%f',d));
     B(ii+hnb+1,jj+hnb+1) = d;

   end
end

figure(2);hold off;
