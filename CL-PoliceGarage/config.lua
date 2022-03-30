Config = Config or {}

Config.UseColors = false

Config.MS = 'high' -- MS for the script recommended using high if not the "close" will get a bit baggy. options high / low

Config.Job = 'police'

--You Can Add As Many As You Like
--DO NOT add vehicles that are not in your shared ! otherwise the qb-garages wont work
Config.Vehicles = {
    [1] = {
        ['vehiclename'] = "Bati", --Name
        ['vehicle'] = "bati", --Model
        ['price'] = 5000, --Price
        ['r'] = 0, --Vehicle Color (optional)
        ['g'] = 0,
        ['b'] = 0,
    }, 
    [2] = {
        ['vehiclename'] = "Test", --Name
        ['vehicle'] = "t20", --Model
        ['price'] = 18000, --Price
        ['r'] = 0, --Vehicle Color (optional)
        ['g'] = 0,
        ['b'] = 0,
    }, 
}