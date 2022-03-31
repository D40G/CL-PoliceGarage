Config = Config or {}

Config.UseColors = false

Config.UseGrade = true -- Want to use grades for each vehicle? if not type false

Config.UseMarkerInsteadOfMenu = false -- Want to use the marker to return the vehice? if false you can do that by opening the menu

Config.MS = 'high' -- MS for the script recommended using high if not the "close" will get a bit baggy. options high / low

Config.Job = 'police'

--You Can Add As Many As You Like
--DO NOT add vehicles that are not in your shared ! otherwise the qb-garages wont work
Config.Vehicles = {
    [1] = {
        ['vehiclename'] = "Bati", --Name
        ['vehicle'] = "bati", --Model
        ['price'] = 5000, --Price
        ['grade'] = 1, --Grade Needed To Buy Vehicle (Optional)
        ['r'] = 0, --Vehicle Color (Optional)
        ['g'] = 0,
        ['b'] = 0,
    }, 
    [2] = {
        ['vehiclename'] = "Test", --Name
        ['vehicle'] = "t20", --Model
        ['price'] = 18000, --Price
        ['grade'] = 2, --Grade Needed To Buy Vehicle (Optional)
        ['r'] = 0, --Vehicle Color (Optional)
        ['g'] = 0,
        ['b'] = 0,
    }, 
}