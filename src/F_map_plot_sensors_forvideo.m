function [ ] = F_map_plot_sensor_video(sensi, mask, sensors, day_name)
% see the following GitHub
%https://github.com/kmanohar/SSPOR_pub/blob/master/MATLAB/display_sensors.m
% Updated on 20 Jan 2017
% Krithika Manohar

	figure(1)
	%display_sensors Template for displaying image data
	%   Displays enso sensors on white w/ black continents
	close all;
	%    set(gcf,'PaperPositionMode','auto')
	snapshot = NaN*zeros(360*180,1);
	x=sensi';
	snapshot(mask==1) = x;
	C = reshape(real(snapshot),360,180)';
	b = imagesc(C);
	shading interp;
	jetmod=jet(256);
	jetmod(1,:)=0;
	colormap(jetmod);
	%colormap(jet);
	%   colorbar;
	caxis([-5 40]);
	set(gca, 'FontName', 'Times','Color','white', 'FontSize', 20);
	%drawnow;
	pivot=sensors;

	sensors_location = zeros(360,180);
	P = zeros(size(x));
	P(pivot) = 1:length(pivot);
	sensors_location(mask==1) = P;
	S = reshape(real(sensors_location)',360*180,1);
	[~,IC,~] = unique(S);

	[I,J] = ind2sub(size(sensors_location'),IC(2:end));

	hold on; 
	plot(J,I,'wo','MarkerSize', 15, 'LineWidth', 3, 'MarkerFaceColor', 'none');

	day_name=datenum('1-Jan-1800 00:00:00') +day_name;
	g=datestr(day_name,'yyyy/mm/dd');
	title(g,'FontSize',20,'FontName','Times New Roman');
	dim = [.2 .5 .2 .3];
	hold off;
	axis off;
    
end
