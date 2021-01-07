function F_map_original(num_video, Xorg, meansst, mask, time, videodir)

    p=0;
    filename = ('enso_original');
    output = [videodir, '/', filename, '.avi'];
    F_map_videowriter(num_video, Xorg, meansst, [], [], mask, time, p, output);

end