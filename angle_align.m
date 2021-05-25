%%
gap1=1408;
end1=1808;
gap2=290;
end2=1;
camera_offset=15;
v1cutoff=50;
v2cutoff=80;
top2=1;
bottom2=1200;
figure;
ButtonHandle = uicontrol('Style', 'PushButton', 'String', 'Stop loop','Callback', 'delete(gcbf)');
while 1
    q1=getsnapshot(vid1);
    m=double(q1)-camera_offset;
    id=find(m>v1cutoff);
    m2=0.*m;
    m2(id)=1;
    upid=[];
    for k2=gap1:end1
        a=find(m2(:,k2), 1, 'first');
        upid=[upid;a];
    end
    %     loid=[];
    %     m3=flipud(m2);
    %     for k2=gap1:size(m3,2)
    %         a=find(m3(:,k2), 1, 'first');
    %         loid=[loid;1201-a];
    %     end
    x=gap1:(size(upid)+gap1-1);
    f=fit(x(:),upid(:),'poly1');
    upangle=atand(f.p1);
    upid2=f(x(:));
    %     f=fit(x(:),loid(:),'poly1');
    %     loangle=atand(f.p1);
    %     loid2=f(x(:));
    
    loangle=upangle;
    loid2=upid2;
    
    avgangle=(upangle+loangle)/2;
    f=fit((1:size(v1axisid,1)).',v1axisid(:),'poly1');
    axisangle=atand(f.p1);
    subplot(1,2,1);
    imagesc(q1);
    title(['average angle is ', num2str(avgangle),' axis angle is ', num2str(axisangle)]);
    hold on;
    plot(gap1:(size(upid)+gap1-1), upid2,'-r.');
    plot(gap1:(size(upid)+gap1-1), loid2,'-r.');
    set(gca,'FontSize',36);
    hold off; drawnow;
    
    q2=getsnapshot(vid2);
    m=double(q2(top2:bottom2,:))-camera_offset;
    id=find(m>v2cutoff);
    m2=0.*m;
    m2(id)=1;
    upid=[];
    for k2=end2:gap2
        a=find(m2(:,k2), 1, 'first');
        upid=[upid;a];
    end
    %     loid=[];
    %     m3=flipud(m2);
    %     for k2=end2:gap2
    %         a=find(m3(:,k2), 1, 'first');
    %         loid=[loid;1201-a];
    %     end
    x=1:size(upid);
    f=fit(x(:),upid(:),'poly1');
    upangle=atand(f.p1);
    upid2=f(x(:));
    %     f=fit(x(:),loid(:),'poly1');
    %     loangle=atand(f.p1);
    %     loid2=f(x(:));
    
    loangle=upangle;
    loid2=upid2;
    
    
    avgangle=(upangle+loangle)/2;
    f=fit((1:size(v2axisid,1)).',v2axisid(:),'poly1');
    axisangle=atand(f.p1);
    subplot(1,2,2);
    imagesc(q2);
    title(['average angle is ', num2str(avgangle),' axis angle is ', num2str(axisangle)]);
    hold on;
    plot(end2:size(upid2)+end2-1, upid2+top2,'-r.');
    %     plot(end2:size(upid2)+end2-1, loid-1200+bottom2,'-r.');
    set(gca,'FontSize',36);
    hold off; drawnow;
    
    if ~ishandle(ButtonHandle)
        disp('Loop stopped by user');
        break;
    end
end
%% camera 1 only
gap1=1400;
end1=2000;
camera_offset=15;
v1cutoff=20;
top1=1400;
bottom1=1944;
figure;
ButtonHandle = uicontrol('Style', 'PushButton', 'String', 'Stop loop','Callback', 'delete(gcbf)');
while 1
    q1=getsnapshot(vid1);
    m=double(q1(top1:bottom1,:))-camera_offset;
    id=find(m>v1cutoff);
    m2=0.*m;
    m2(id)=1;
    upid=[];
    for k2=gap1:end1
        a=find(m2(:,k2), 1, 'first');
        upid=[upid;a];
    end

    x=gap1:(size(upid)+gap1-1);
    f=fit(x(:),upid(:),'poly1');
    upangle=atand(f.p1);
    upid2=f(x(:));
    
    avgangle=upangle;
    
    f=fit((1:size(v1axisid,1)).',v1axisid(:),'poly1');
    axisangle=atand(f.p1);
    imagesc(q1);
    title(['average angle is ', num2str(avgangle),' axis angle is ', num2str(axisangle)]);
    hold on;
    plot(gap1:(size(upid)+gap1-1), upid2+top1,'-r.');
    set(gca,'FontSize',36);
    hold off; drawnow;
    
    if ~ishandle(ButtonHandle)
        disp('Loop stopped by user');
        break;
    end
end
%% camera 2 only
gap2=1200;
end2=1500;
camera_offset=20;
v2cutoff=20;
top2=600;
bottom2=1200;
figure;
ButtonHandle = uicontrol('Style', 'PushButton', 'String', 'Stop loop','Callback', 'delete(gcbf)');
while 1
    q2=getsnapshot(vid2);
    m=double(q2(top2:bottom2,:))-camera_offset;
    id=find(m>v2cutoff);
    m2=0.*m;
    m2(id)=1;
    upid=[];
    for k2=gap2:end2
        a=find(m2(:,k2), 1, 'first');
        upid=[upid;a];
    end
    x=1:size(upid);
    f=fit(x(:),upid(:),'poly1');
    upangle=atand(f.p1);
    upid2=f(x(:));
    avgangle=upangle;
    f=fit((1:size(v2axisid,1)).',v2axisid(:),'poly1');
    axisangle=atand(f.p1);
    imagesc(q2);
    title(['average angle is ', num2str(avgangle),' axis angle is ', num2str(axisangle)]);
    hold on;
    plot(gap2:size(upid2)+gap2-1, upid2+top2,'-r.');
    set(gca,'FontSize',36);
    hold off; drawnow;
    
    if ~ishandle(ButtonHandle)
        disp('Loop stopped by user');
        break;
    end
end