function F_map_videowriter(num_video, Xmatrix, meansst, U, Zestimate, mask, time, p, filename, sensors)

	v = VideoWriter(filename);
	open(v);

	for i=1:num_video%length(time)
		% bounds = [min(x+meansst) max(x+meansst)];
		figure(1);           
		if p==0
			xtmp = Xmatrix(:,i);
			F_map_plot_sensors_forvideo(xtmp+meansst, mask, [], time(i));
		else
			xls = U*Zestimate(:,i);
			F_map_plot_sensors_forvideo(xls+meansst, mask, sensors, time(i));
		end
		frame = getframe(figure(1));
		writeVideo(v,frame);
		close(1)
	end
	close(v);

end