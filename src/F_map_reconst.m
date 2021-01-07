function F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors, Zestimate, name, videodir, sensordir)

    text = name;
    filename = ['enso_', text ,'_mode' num2str(r) '_sensor', num2str(p)];
    output = [sensordir, '/', filename];
    F_map_plot_sensors(U*Zestimate(:,1)+meansst, mask, sensors, output);
    output = [videodir, '/', filename, '.avi'];
    F_map_videowriter(num_video, [], meansst, U, Zestimate, mask, time, p, output, sensors);

end