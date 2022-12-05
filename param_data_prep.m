% 79 pft parameters

para_file_in = 'C:\Research3\param_data\clm5_params.c200624.nc'
ncid_in = netcdf.open(para_file_in,'NC_NOWRITE');

para_file_out = 'C:\Research3\param_data\clm5_params.c221205.nc'
para_file_out = 'C:\Research3\param_data\test8.nc'
ncid_out = netcdf.create(para_file_out,'NC_NOCLOBBER');

dimid_0 = netcdf.defDim(ncid_out, 'pft', 143);
dimid_1 = netcdf.defDim(ncid_out, 'segment', 4);
dimid_2 = netcdf.defDim(ncid_out, 'string_length', 40);
dimid_3 = netcdf.defDim(ncid_out, 'variants', 2);


for varid_in = 0 : 336
    [varname,xtype,dimids,natts] = netcdf.inqVar(ncid_in,varid_in);
    data_old = netcdf.getVar(ncid_in,varid_in);

    size_dim = size(dimids);
    size_dim = size_dim(2)

    varid_out = netcdf.defVar(ncid_out ...
        ,varname,xtype,dimids);
    
    netcdf.endDef(ncid_out)

    if size_dim == 0
        data_new = data_old
        netcdf.putVar(ncid_out,varid_out,data_new);
        
    elseif size_dim == 1
        if dimids == 0
            
            data_new(1:79) = data_old(1:79);
            for i = 80 : 143
                if mod(i, 2) == 0
                    data_new(i) = data_old(i - 63);
                else
                    data_new(i) = data_old(i - 64);
                end
            end
            
            netcdf.putVar(ncid_out,varid_out,data_new);
            
        else
            data_new = data_old
            netcdf.putVar(ncid_out,varid_out,data_new);
            
        end
    else
        size_data = size(data_old)
        if dimids(1) == 0
            data_new = zeros(size_data);
            data_new(1:79, :) = data_old(1:79, :);
            for i = 80 : 143
                if mod(i, 2) == 0
                    data_new(i, :) = data_old(i - 63, :);
                else
                    data_new(i, :) = data_old(i - 64, :);
                end
            end

            netcdf.putVar(ncid_out,varid_out,data_new);
            
        elseif dimids(2) == 0
            
            data_new(:, 1:79) = data_old(:, 1:79);
            for i = 80 : 143
                if mod(i, 2) == 0
                    data_new(:, i) = data_old(:, i - 63);
                else
                    data_new(:, i) = data_old(:, i - 64);
                end
            end
            netcdf.putVar(ncid_out,varid_out,data_new);
            
        else
            data_new = data_old
            netcdf.putVar(ncid_out,varid_out,data_new);
            
        end
    end
    netcdf.reDef(ncid_out)
    clearvars data_new
    for n_att = 0 : natts - 1
        attrname = netcdf.inqAttName(ncid_in,varid_in,n_att)
        %netcdf.copyAtt(ncid_in,0,attname,ncid_out,1)
        attrvalue = netcdf.getAtt(ncid_in,varid_in,attrname)
        netcdf.putAtt(ncid_out,varid_out,attrname,attrvalue)
    end
end

netcdf.close(ncid_out)