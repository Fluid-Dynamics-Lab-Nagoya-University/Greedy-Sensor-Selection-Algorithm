function [ ] = F_map_plot_sensors(sensi, mask, sensors, filename)

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
	colorbar;
	caxis([-5 40]);
	set(gca, 'FontName', 'Times','Color','white', 'FontSize', 20);
	%drawnow;
	pivot=sensors;
	
	sensors_location = zeros(360,180);
	P = zeros(size(x)); P(pivot)=1:length(pivot);    
	sensors_location(mask==1) = P;
	S = reshape(real(sensors_location)',360*180,1);
	[C,IC,~] = unique(S);
	
	% align Ilin with pivot somehow
	
	[I,J] = ind2sub(size(sensors_location'),IC(2:end));

	hold on;
	%   for k=1:p
	plot(J,I,'wo','MarkerSize', 15, 'LineWidth', 3, 'MarkerFaceColor', 'none');
	filename_png = [filename,'.png'];
	saveas(gcf, filename_png);
	filename_emf = [filename,'.emf'];
	saveas(gcf, filename_emf);
	%  end
	hold off;
	axis off;
		
	drawnow;
end
