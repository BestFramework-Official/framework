-- Player will get registered here in the database with the steam id
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local identifier

    -- you can use [steam, license] so the players have a license
    for k, v in ipairs(identifiers) do 
        if string.match(v, 'steam:') then
            identifier = v
            break
        end
    end

    if not identifier then
        deferrals.done('You need open steam') -- If steam doesn't open it gives an error and the player will not connect
    else
        deferrals.done()

        -- Inserts all things in the Database:
        exports.ghmattimysql:scalar('SELECT 1 FROM users WHERE identifier = @identifier', {
            ['@identifier'] = identifier
        }, function(result)
            if not result then
                exports.ghmattimysql:execute('INSERT INTO users (identifier) VALUES (@identifier)', {
                    ['@identifier'] = identifier
                })
            end
        end)
    end
end)