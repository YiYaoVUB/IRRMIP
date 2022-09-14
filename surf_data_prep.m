PCT_CFT=ncread('C:\Research3\landuse.timeseries_0.9x1.25_hist_78pfts_CMIP6_simyr1850-2015_c170824_PCT_CFT.nc', 'PCT_CFT');          
PCT_CROP=ncread('C:\Research3\landuse.timeseries_0.9x1.25_hist_78pfts_CMIP6_simyr1850-2015_c170824_PCT_CROP.nc', 'PCT_CROP');
PCT_CFT_1901 = PCT_CFT(:,:,:,52);   % Get the percentage of CFT data
PCT_CROP_1901 = PCT_CROP(:,:,52);   % Get the percentage of CROP data (as the CFT data only represents the CFT percentage of CROP)
PCT_AREA_1901 = PCT_CFT_1901 .* PCT_CROP_1901;   % Get the AREA percentage of CFT of the gridcell

PCT_CFT_AFTER = zeros(288,192,64,166);      % CFT percentage after change, which is used in the new surfdata set
PCT_AREA_AFTER = zeros(288,192,64,166);      % AREA percentage after change

PCT_CFT_AFTER(:,:,:,1:52) = PCT_CFT(:,:,:,1:52);    % For the year before 1901, do nothing

for yr = 53 : 166
    PCT_CFT_yr = PCT_CFT(:,:,:,yr);     % Get the CFT data of the year
    PCT_CROP_yr = PCT_CROP(:,:,yr);     % Get the CROP data of the year
    PCT_AREA_yr = PCT_CFT_yr .* PCT_CROP_yr;     % Get the AREA data of the year
    
    for lon = 1 : 288
        for lat = 1 : 192
            for cft = 2:2:64    % In CLM5, every CFT is divided to two types: rainfed and irrigated, so we do not need to do anything for rainfed CFT at this moment
                if PCT_AREA_yr(lon, lat, cft) > PCT_AREA_1901(lon, lat, cft)        % If there is increase in IRR area, 
                    PCT_AREA_AFTER(lon, lat, cft, yr) = PCT_AREA_1901(lon, lat, cft);       % then modify it to the value at the year of 1901 
                    PCT_AREA_AFTER(lon, lat, cft-1, yr) = PCT_AREA_yr(lon, lat, cft) + PCT_AREA_yr(lon, lat, cft) - PCT_AREA_AFTER(lon, lat, cft);   % The increased irrigated area will be added to rainfed CFT
                else
                    continue
                end
            end
        end
    end
    PCT_CFT_AFTER_yr = PCT_AREA_AFTER(:,:,:,yr) ./ PCT_CROP_yr;       % Get the CFT data used for surfdata
    PCT_CFT_AFTER(:,:,:,yr) = PCT_CFT_AFTER_yr;     % Store the CFT data in the array
end

PCT_CFT_AFTER(find(isnan(PCT_CFT_AFTER)==1)) = 0;   % Change the NaN value to 0 to make it consistent with the surfdata set
ncwrite('C:\Research3\landuse.timeseries_0.9x1.25_hist_78pfts_CMIP6_simyr1850-2015_c170824_PCT_CFT_noirr.nc', 'PCT_CFT', PCT_CFT_AFTER);


