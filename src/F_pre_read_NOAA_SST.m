function [ Lat, Lon, time, mask, sst ] = F_pre_read_NOAA_SST( filename, maskname )
%read_data Read in ENSO data
%   Return meshgrid of lat,long,times and sea-surface temp

    sst  = ncread(['../data/', filename], 'sst');
    time = ncread(['../data/', filename], 'time'); %days
    % each element of time array is a new week, in units of days

    lat  = ncread(['../data/', filename], 'lat');
    lon  = ncread(['../data/', filename], 'lon');

    mask = ncread(['../data/', maskname], 'mask');
    mask = mask(:,:,1);
    [Lat, Lon] = meshgrid(lat, lon);

    % % Do not plot continent mask
    % Lat(mask==0) = NaN;
    % Lon(mask==0) = NaN;
    
end
