﻿module MaxHelpingHandGroupedTriggerSpikes

using ..Ahorn, Maple

@mapdef Entity "MaxHelpingHand/GroupedTriggerSpikesUp" GroupedTriggerSpikesUp(x::Integer, y::Integer, width::Integer=Maple.defaultSpikeWidth, type::String="default", behindMoveBlocks::Bool=false)
@mapdef Entity "MaxHelpingHand/GroupedTriggerSpikesDown" GroupedTriggerSpikesDown(x::Integer, y::Integer, width::Integer=Maple.defaultSpikeWidth, type::String="default", behindMoveBlocks::Bool=false)
@mapdef Entity "MaxHelpingHand/GroupedTriggerSpikesLeft" GroupedTriggerSpikesLeft(x::Integer, y::Integer, height::Integer=Maple.defaultSpikeHeight, type::String="default", behindMoveBlocks::Bool=false)
@mapdef Entity "MaxHelpingHand/GroupedTriggerSpikesRight" GroupedTriggerSpikesRight(x::Integer, y::Integer, height::Integer=Maple.defaultSpikeHeight, type::String="default", behindMoveBlocks::Bool=false)

const placements = Ahorn.PlacementDict()

groupedTriggerSpikes = Dict{String, Type}(
    "up" => GroupedTriggerSpikesUp,
    "down" => GroupedTriggerSpikesDown,
    "left" => GroupedTriggerSpikesLeft,
    "right" => GroupedTriggerSpikesRight
)

const spikeTypes = String[
    "default",
    "outline",
    "cliffside",
    "dust",
    "reflection"
]

const triggerSpikeColors = [
    (242, 90, 16, 255) ./ 255,
    (255, 0, 0, 255) ./ 255,
    (242, 16, 103, 255) ./ 255
]

groupedTriggerSpikesUnion = Union{GroupedTriggerSpikesUp, GroupedTriggerSpikesDown, GroupedTriggerSpikesLeft, GroupedTriggerSpikesRight}

for variant in spikeTypes
    for (dir, entity) in groupedTriggerSpikes
        key = "Grouped Trigger Spikes ($(uppercasefirst(dir)), $(uppercasefirst(variant))) (max480's Helping Hand)"
        placements[key] = Ahorn.EntityPlacement(
            entity,
            "rectangle",
            Dict{String, Any}(
                "type" => variant
            )
        )
    end
end

Ahorn.editingOptions(entity::groupedTriggerSpikesUnion) = Dict{String, Any}(
    "type" => spikeTypes
)

directions = Dict{String, String}(
    "MaxHelpingHand/GroupedTriggerSpikesUp" => "up",
    "MaxHelpingHand/GroupedTriggerSpikesDown" => "down",
    "MaxHelpingHand/GroupedTriggerSpikesLeft" => "left",
    "MaxHelpingHand/GroupedTriggerSpikesRight" => "right",
)

offsets = Dict{String, Tuple{Integer, Integer}}(
    "up" => (4, -4),
    "down" => (4, 4),
    "left" => (-4, 4),
    "right" => (4, 4),
)

groupedTriggerSpikesOffsets = Dict{String, Tuple{Integer, Integer}}(
    "up" => (0, 5),
    "down" => (0, -4),
    "left" => (5, 0),
    "right" => (-4, 0),
)

rotations = Dict{String, Number}(
    "up" => 0,
    "right" => pi / 2,
    "down" => pi,
    "left" => pi * 3 / 2
)

triggerRotationOffsets = Dict{String, Tuple{Number, Number}}(
    "up" => (3, -1),
    "right" => (4, 3),
    "down" => (5, 5),
    "left" => (-1, 4),
)

resizeDirections = Dict{String, Tuple{Bool, Bool}}(
    "up" => (true, false),
    "down" => (true, false),
    "left" => (false, true),
    "right" => (false, true),
)

function Ahorn.renderSelectedAbs(ctx::Ahorn.Cairo.CairoContext, entity::groupedTriggerSpikesUnion)
    direction = get(directions, entity.name, "up")
    theta = rotations[direction] - pi / 2

    width = Int(get(entity.data, "width", 0))
    height = Int(get(entity.data, "height", 0))

    x, y = Ahorn.position(entity)
    cx, cy = x + floor(Int, width / 2) - 8 * (direction == "left"), y + floor(Int, height / 2) - 8 * (direction == "up")

    Ahorn.drawArrow(ctx, cx, cy, cx + cos(theta) * 24, cy + sin(theta) * 24, Ahorn.colors.selection_selected_fc, headLength=6)
end

function Ahorn.selection(entity::groupedTriggerSpikesUnion)
    if haskey(directions, entity.name)
        x, y = Ahorn.position(entity)

        width = Int(get(entity.data, "width", 8))
        height = Int(get(entity.data, "height", 8))

        direction = get(directions, entity.name, "up")

        ox, oy = offsets[direction]

        return Ahorn.Rectangle(x + ox - 4, y + oy - 4, width, height)
    end
end

Ahorn.minimumSize(entity::groupedTriggerSpikesUnion) = 8, 8

function Ahorn.resizable(entity::groupedTriggerSpikesUnion)
    if haskey(directions, entity.name)
        direction = get(directions, entity.name, "up")

        return resizeDirections[direction]
    end
end

function Ahorn.render(ctx::Ahorn.Cairo.CairoContext, entity::groupedTriggerSpikesUnion)
    if haskey(directions, entity.name)
        variant = get(entity.data, "type", "default")
        direction = get(directions, entity.name, "up")
        groupedTriggerSpikesOffset = groupedTriggerSpikesOffsets[direction]

        if variant == "dust"
            rng = Ahorn.getSimpleEntityRng(entity)

            width = get(entity.data, "width", 8)
            height = get(entity.data, "height", 8)

            updown = direction == "up" || direction == "down"

            for ox in 0:8:width - 8, oy in 0:8:height - 8
                color1 = rand(rng, triggerSpikeColors)
                color2 = rand(rng, triggerSpikeColors)

                drawX = ox + triggerRotationOffsets[direction][1]
                drawY = oy + triggerRotationOffsets[direction][2]

                Ahorn.drawSprite(ctx, "danger/triggertentacle/wiggle_v06", drawX, drawY, rot=rotations[direction], tint=color1)
                Ahorn.drawSprite(ctx, "danger/triggertentacle/wiggle_v03", drawX + 3 * updown, drawY + 3 * !updown, rot=rotations[direction], tint=color2)
            end
        else

            width = get(entity.data, "width", 8)
            height = get(entity.data, "height", 8)

            for ox in 0:8:width - 8, oy in 0:8:height - 8
                drawX, drawY = (ox, oy) .+ offsets[direction] .+ groupedTriggerSpikesOffset
                Ahorn.drawSprite(ctx, "danger/spikes/$(variant)_$(direction)00", drawX, drawY)
            end
        end
    end
end

end
