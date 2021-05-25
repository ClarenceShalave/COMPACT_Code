%%
file_path='H:\COMPACT\video\transition\';
file_basename='Assembly1';
video_name='transition.avi';
frame_num=240;
%%
% create the video writer with 1 fps
writerObj = VideoWriter([file_path,video_name]);
writerObj.FrameRate = 100;
% set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:frame_num
    % convert the image to a frame
    frame = imread([file_path,file_basename,num2str(i,'%03d'),'.tif']);
    writeVideo(writerObj, frame);
    i
end
% close the writer object
close(writerObj);