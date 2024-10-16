# # FIXME: Should I need to normalize lon lat? Or should I check whether longitude and latitude are legal?
# # Normalize latitude to -90° to +90°
function latlon_normalize(lat::Latitude{U}) where {U}
    temp_lat = lat.value.val
    while temp_lat > 90 || temp_lat < -90
        if temp_lat > 90
            temp_lat = 180 - temp_lat
        elseif temp_lat < -90
            temp_lat = -180 - temp_lat
        end
    end
    return Latitude(temp_lat * u"°")
end

# # Normalize longitude to -180° to +180°
function latlon_normalize(lon::Longitude{U}) where {U}
    value_in_deg = lon.value.val
    Longitude((mod(value_in_deg + 180, 360) - 180) * u"°")
end

latlon_normalize(x) = x
