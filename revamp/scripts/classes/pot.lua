local enums = require 'scripts.enums'
local musics = require 'scripts.musics'

local plant = require 'scripts.classes.plant'

local pot = {}
pot.__index = pot

local index = 1 -- For naming

function pot.new(name)
    local newObject = {
        name = name or index,
        plant = nil,
        music = nil,
        waterLevel = 1
    }

    setmetatable(newObject, pot)

    newObject.plant = plant.new(newObject)

    if newObject.name == index then
        index = index + 1
    end

    return newObject
end

-- Initializes the pot before starting the simulation
function pot:initialize()
    local music = self.music

    -- Set loop when the selected music is less than 7 mins (which is the intended simulation time)
    if music.audio:getDuration('seconds') < (7*60) then
        music.audio:setLooping(true)
    end

    -- Load the sound data for use of algorithm
    self.music.data = love.sound.newSoundData(music.path)

    -- Plays the music
    music.audio:play()
end

function pot:setMusic(music)
    if self.music == nil then
        self.music = {}
    end

    -- Set the music table values of pot

    self.music.name = music.name
    self.music.artist = music.artist
    self.music.audio = music.audio
    self.music.path = music.path

    -- Set the name of the pot based on specified genre

    for genre, list in pairs(musics) do
        for _, table in ipairs(list) do
            -- Finding the same table specified using table reference for comparisons
            if music == table then
                self.name = genre
                return
            end
        end
    end

    -- If the specified music hasn't found (out of bounds from identified genre or just wrong input)
    error('Specified music not found')
end

-- Returns name of the pot, health of the pot, and water level of the pot
function pot:getInfo()
    local waterLevel = self.waterLevel
    waterLevel = waterLevel * 100

    if waterLevel >= 200 then
        waterLevel = '+200%'
    elseif waterLevel <= 0 then
        waterLevel = '-0%'
    else
        waterLevel = waterLevel .. '%'
    end

    return (self.name or 'No genre'), self.plant:getHealth(), waterLevel
end


return pot