%% make zernike polynomials
% zern_max=35; % max order of zernike
zern_p=[];
% for j=2:27
%     zern_p=[zern_p,2*j*(j+1)];
% % end
% zern_p=[zern_p,3,5:11,13:23,23:39];
zern_p=1:50;
zernike=make_zernike(zern_p,408,298,325); % generate the zernike,start from mode 1
zernike=zernike(26:625,:,:);
%%
r=180;
for i=1:600
    for j=1:792
        for k=1:19
            if sqrt((i-270)^2+(j-270)^2)<r
                zernike(i,j,k)=0;
            end
        end
    end
end
%%
image_path='G:\COMPACT\data\20190327\bead1\';
mkdir(image_path)
base_name='bead';
Nxpixels=512;
Nypixels=512;
N=1;
pausetime=0.08; %pause for SLM
% basephase=zeros(600,792);
% basephase=-slmphase;
basephase=outputphase_cphasefinalphaseslmphase;
metric=[];
coeff_zern=[];
threshold=100;
fit_threshold=0.75;
amp_lim=pi*3;
amp_N=7;
amplitude=linspace(-amp_lim,amp_lim,amp_N);
metric_option=2;%option 1---sum of the total pixles, option 2---sum of high frequency pixels,
if metric_option==2
    MASKF=ones(Nypixels,Nxpixels);
    min_k= 6;
    max_k= 120;
    x=linspace(-1,1,Nxpixels)*Nxpixels/2;
    y=linspace(-1,1,Nypixels)*Nypixels/2;
    [X,Y]=meshgrid(x,y);
    MASKF((X.^2+Y.^2)<min_k^2)=0;
    MASKF((X.^2+Y.^2)>max_k^2)=0;
    figure(234);imagesc(MASKF)
end
zernike_modes=[1:50];% select the zernike mode for AO
checkid=1;
counterN=1;
correction=zeros(600,792);
SaveImageBuffer=zeros(Nypixels,Nxpixels,(N*size(zernike,3)),numel(amplitude));
% hSI.startLoop();pause(5)
filecounter=0;
for round_id=1:N    %iteration #
    for zern_id=zernike_modes%size(zernike,3)
        metricAll=[];
        amplitudeAll=[];
        while(checkid)
            filecounter=filecounter+1;
            for amp_id=1:numel(amplitude)
                totalwavefront=zernike(:,:,zern_id)*amplitude(amp_id)+correction+basephase;  %apply re order Zernike with changing amplitude
                outputphase=angle(exp(1i*totalwavefront))+1.1*pi;% shift minimum to above 0;
                for k1=1:10
                    for k2=1:12
                        phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
                        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
                        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
                    end
                end
                vout=uint8(vout);Screen(window2, 'PutImage',vout);Screen(window2,'Flip');pause(pausetime);
                pause(0.75);
                % acquire images;
%                 state.files.fileCounter=filecounter;
%                 state.files.savePath=image_path;
%                 state.files.baseName=[base_name,'_',num2str(zern_id),'_',num2str(amp_id),'_'];
%                 state.files.fullFileName=[image_path,base_name,'_',num2str(zern_id),'_',num2str(amp_id),'_'];
%                 executeGrabOneCallback(gh.mainControls.grabOneButton);
%                 pause(1.5)
%                 BUFF=double(imread([image_path,base_name,'_',num2str(zern_id),'_',num2str(amp_id),'_',num2str(filecounter,'%03d'),'.tif']));
                BUFF=double(state.acq.acquiredData{1,1}{1,1});
                SaveImageBuffer(:,:,zern_id,amp_id)=BUFF;
                BUFF_background=mean(mean(BUFF(1:50,1:50)));
                BUFF=BUFF-BUFF_background;
                BUFF(BUFF<threshold)=0;
                if metric_option==1
                    metric(amp_id)=sum(BUFF(:)); % sum of the whole pixles
                elseif metric_option==2
                    metric(amp_id)=sum(sum(abs(fftshift(fft2(double(BUFF)))).*MASKF));
                else
                    metric(amp_id)=sum(BUFF(:)); % sum of the whole pixles
                end
            end
            metricAll=[metricAll; metric(:)];
            amplitudeAll=[amplitudeAll;amplitude(:)];
            %fresult=fit(amplitudeAll(:),metricAll(:),'gauss1');
            %plot(amplitudeAll, metricAll,' bo', amplitudeAll,fresult.a1*exp(-((amplitudeAll-fresult.b1)./fresult.c1).^2),' rx' );
            % Set up fittype and options.
            ft = fittype( 'gauss1' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.DiffMinChange = 0.01;
            opts.Lower = [min(metricAll) min(amplitudeAll)-2*pi (max(amplitudeAll)-min(amplitudeAll))/5];
            opts.Upper = [max(metricAll)*2 max(amplitudeAll)+2*pi (max(amplitudeAll)-min(amplitudeAll))*5];
            % opts.StartPoint = [max(y) mean(y) (max(y)-min(y))/2];
            opts.TolFun = 0.01;
            opts.TolX = 0.01;
            % Fit model to data.
            tic;
            [fitresult, gof] = fit( amplitudeAll(:), metricAll(:), ft, opts );
            t=toc;
            % Plot fit with data.
            h=figure(999);
            subplot(1,2,1)
            plot( fitresult, amplitudeAll(:), metricAll(:) );
            legend off;
            %legend( h, 'y vs. x', 'untitled fit 1', 'Location', 'NorthEast' );
            %title(['time ',num2str(t),'  SSE ',num2str(gof.sse)]);
            % Label axes
            xlabel amplitude
            ylabel metric
            title(['zern mode number ',num2str(zern_id),' rsquare ',num2str(gof.rsquare)]);
            drawnow;
            % grid on
            % check if the center is outside the range
            if gof.rsquare>fit_threshold
                max_point=fitresult.b1;
            else
                [maxvalue,maxid]=max(metricAll);
                max_point=amplitudeAll(maxid);
            end
            if max_point>=max(amplitudeAll)
                amplitude=amplitude-min(amplitude)+max(amplitudeAll);
                checkid=1;
                counterN=counterN+1;
            elseif max_point<=min(amplitudeAll)
                amplitude=amplitude-max(amplitude)+min(amplitudeAll);
                checkid=1;
                counterN=counterN+1;
            else
                checkid=0;
                counterN=1;
            end
            if counterN>=5
                max_point=0;
                checkid=0;
            end
            %             disp(counterN);
            counterN=counterN+1;
            coeff_zern(zern_id)=max_point;
            fit_max(zern_id)=fitresult.a1;
            
        end
        correction=correction+zernike(:,:,zern_id).*max_point;
        checkid=1;
        counterN=1;
        amplitude=linspace(-amp_lim,amp_lim,amp_N);
        subplot(1,2,2)
        imagesc(correction);
        colormap jet;colorbar;drawnow;
    end
    totalwavefront=correction+basephase;
    outputphase=angle(exp(1i*totalwavefront))+1.1*pi;% shift minimum to above 0;
    for k1=1:10
        for k2=1:12
            phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
            vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
            vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
        end
    end
    vout=uint8(vout);
    Screen(window2, 'PutImage',vout);
    Screen(window2,'Flip');
    pause(pausetime);
end
figure;
subplot(1,2,1);plot(coeff_zern);title('zernike coeff')
subplot(1,2,2);plot(fit_max);title('max fitting value')

%% system correction
outputphase=angle(exp(1i*totalwavefront))+1.1*pi;% shift minimum to above 0;
for k1=1:10
    for k2=1:12
        phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
    end
end
vout=uint8(vout);
Screen(window2, 'PutImage',vout);
Screen(window2,'Flip');
pause(pausetime);
%% compare;
outputphase=-1*slmphase;
outputphase=angle(exp(1i*outputphase))+1.1*pi;% shift minimum to above 0;
for k1=1:10
    for k2=1:12
        phaseblock=outputphase((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66);
        vblock=voltagearray(k1,k2,1)*phaseblock.^6 + voltagearray(k1,k2,2)*phaseblock.^5 + voltagearray(k1,k2,3)*phaseblock.^4 + voltagearray(k1,k2,4)*phaseblock.^3+voltagearray(k1,k2,5)*phaseblock.^2+voltagearray(k1,k2,6)*phaseblock.^1;
        vout((k1-1)*60+1:(k1-1)*60+60,(k2-1)*66+1:(k2-1)*66+66)=vblock;
    end
end
vout=uint8(vout);
Screen(window2, 'PutImage',vout);Screen(window2,'Flip');
%%
save([image_path,'phase0_copy.mat'],'correction','totalwavefront');
%%
cd(image_path);
delete *.tif