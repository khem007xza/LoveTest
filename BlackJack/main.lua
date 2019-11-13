function love.load()
    love.graphics.setBackgroundColor(1, 1, 1)

    images = {}
    for nameIndex, name in ipairs({
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 'pipHeart', 'pipDaimond',
        'pipClub', 'pipSpade', 'miniHeart', 'miniDaimond', 'miniClub', 'miniSpade',
        'card', 'cardFacedown', 'faceJack', 'faceQueen', 'faceKing',
    }) do
        images[name] = love.graphics.newImage('images/'..name..'.png')
    end

    function takeCard(hand)
        table.insert(hand, table.remove(deck, love.math.random(#deck)))
    end

    function getTotal(hand)
        local total = 0
        local hasAce = false

        for cardIndex, card in ipairs(hand) do
            if card.rank > 10 then
                total = total + 10
            else
                total = total + card.rank
            end

            if card.rank == 1 then
                hasAce = true
            end
        end

        if hasAce and total <= 11 then
            total = total + 10
        end

        return total
    end

    button_Y = 230
    button_Height = 25

    button_Hitx = 10
    button_HtWidth = 53

    button_StandX = 70
    button_StandWidth = 53

    button_PlayAgainX = 10
    button_PlayAgainWidth = 113

    function isMouseInButton(button_X, button_Width)
        return love.mouse.getX() >= button_X
        and love.mouse.getX() < button_X + button_Width
        and love.mouse.getY() >= button_Y
        and love.mouse.getY() < button_Y + button_Height
    end

    function reset()
        deck = {}
        for suitIndex, suit in ipairs({'club', 'diamond', 'heart', 'spade'}) do
            for rank = 1, 13 do
                table.insert(deck, {suit = suit, rank = rank})
            end
        end

        playHand = {}
        takeCard(playHand)
        takeCard(playHand)

        dealerHand = {}
        takeCard(dealerHand)
        takeCard(dealerHand)

        roundOver = false
    end

    reset()
end

function love.draw()
    local output = {}

    table.insert(output, 'Player hand:')
    for cardIndex, card in ipairs(playHand) do
        table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
    end

    love.graphics.print(table.concat(output, '\n'), 15, 15)

    if roundOver then
        table.insert(output, '')

        local function hasHandWon(thisHand, otherHand)
            return getTotal(thisHand) <= 21
            and (
                getTotal(otherHand) > 21
                or getTotal(thisHand) > getTotal(otherHand)
            )
        end

        if hasHandWon(playHand, dealerHand) then
            table.insert(output, 'Player Wins')
        elseif hasHandWon(dealerHand, playHand) then
            table.insert(output, 'Dealer Wins')
        else
            table.insert(output, 'Draw')
        end
    end

    local function drawCard(card, x, y)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(images.card, x, y)

        if card.suit == 'heart' or card.suit == 'daimond' then
            love.graphics.setColor(.89, .06, .39)
        else
            love.graphics.setColor(.2, .2, .2)
        end

        local cardWidth = 53
        local cardHeight = 73

        local function drawCorner(images, offsetX, offsetY)
            love.graphics.draw(
                images,
                x + offsetX,
                y + offsetY
            )
            love.graphics.draw(
                images,
                x + cardWidth - offsetX,
                y + cardHeight - offsetY,
                0,
                -1
            )
        end

        drawCorner(images[card.rank], 3, 4)
        drawCorner(images['mini_'..card.suit], 3, 14)

        if card.rank > 10 then
            local faceImage
            if card.rank == 11 then
                faceImage = images.faceJack
            elseif card.rank == 12 then
                faceImage = images.faceQueen
            elseif card.rank == 13 then
                faceImage = images.faceKing
            end
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(faceImage, x + 12, y + 11)
        else
            local function drawPip(offsetX, offsetY, mirrorX, mirrorY)
                local pipImage = images['pip_'..card.suit]
                local pipWidth = 11
                love.graphics.draw(
                    pipImage,
                    x + offsetX,
                    y + offsetY
                )
                if mirrorX then
                    love.graphics.draw(
                        pipImage,
                        x + cardWidth - offsetX - pipWidth,
                        y + offsetY
                    )
                end
                if mirrorY then
                    love.graphics.draw(
                        pipImage,
                        x + offsetX + pipWidth<
                        y + cardHeight - offsetY<
                        0,
                        -1
                    )
                end
                if mirrorX and mirrorY then
                    love.graphics.draw(
                        pipImage,
                        x + cardWidth - offsetX,
                        y + cardHeight - offsetY,
                        0,
                        -1
                    )
                end
            end

            local xLeft = 11
            local xMid = 21
            local yTop = 7
            local yThird = 19
            local yQtr = 23
            local yMid = 31

            if card.rank == 1 then
                drawPip(xMid, yMid)
            elseif card.rank == 2 then
                drawPip(xMid, yTop, false, true)
            elseif card.rank == 3 then
                drawPip(xMid, yTop, false, true)
                drawPip(xMid, yMid)
            elseif card.rank == 4 then
                drawPip(xLeft, yTop, true, true)
            elseif card.rank == 5 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xMid, yMid)
            elseif card.rank == 6 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yTop, true)
            elseif card.rank == 7 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yMid, true)
                drawPip(xMid, yThird)
            elseif card.rank == 8 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yMid, true)
                drawPip(xMid, yThird, false, true)
            elseif card.rank == 9 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yQtr, true, true)
                drawPip(xMid, yMid)
            elseif card.rank == 10 then
                drawPip(xLeft, yTop, true, true)
                drawPip(xLeft, yQtr, true, true)
                drawPip(xMid, 16, false, true)
            end
        end
    end

    local cardSpacing = 60
    local marginX = 10

    for cardIndex, card in ipairs(dealerHand) do
        local dealerMarginY = 30
        if not roundOver and cardIndex == 1 then
            love.graphics.draw(images.cardFacedown, marginX, dealerMarginY)
        else
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
        end
    end

    for cardIndex, card in ipairs(playHand) do
        drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
    end

    love.graphics.setColor(0, 0, 0)

    if roundOver then
        love.graphics.print('Total: '..getTotal(dealerHand), marginX, 10)
    else
        love.graphics.print('Total: ?', marginX, 10)
    end

    love.graphics.print('Total: '..getTotal(playHand), marginX, 120)

    if roundOver then
        local function hasHandWon(thisHand, otherHand)
            return getTotal(thisHand) <= 21
            and (
                getTotal(otherHand) > getTotal(otherHand)
                or getTotal(thisHand) > getTotal(otherHand)
            )
        end

        local function drawWinner(message)
            love.graphics.print(message, marginX, 268)
        end

        if hasHandWon(playHand, dealerHand) then
            drawWinner('Player Wins')
        elseif hasHandWon(dealerHand, playHand) then
            drawWinner('Dealer Wins')
        else
            drawWinner('Draw')
        end
    end

    local function drawButton(text, button_X, button_Width, textOffsetX)
        local button_Y = 230
        local button_Height = 25

        if love.mouse.getX() >= button_X
        and love.mouse.getX() < button_X + button_Width
        and love.mouse.getY() >= button_Y
        and love.mouse.getY() < button_Y + button_Height then
            love.graphics.setColor(1, .8, .3)
        else
            love.graphics.setColor(1, .5, .2)
        end
        love.graphics.rectamgle('fill', button_X, button_Y + 6)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(text, button_X + textOffsetX, button_Y + 6)
    end

    if roundOver then
        drawButton('Play Again?', button_PlayAgainX, button_PlayAgainWidth, 24)
    else
        drawButton('Hit!', button_Hitx, button_HtWidth, 16)
        drawButton('Stand', button_StandX, button_StandWidth, 8)
    end
end

function love.mouserelesed()
    if not roundOver then
        if isMouseInButton(button_Hitx, button_HtWidth) then
            takeCard(playHand)
            if getTotal(playHand) > 21 then
                roundOver = true
            end
        elseif isMouseInButton(button_StandX, button_StandWidth) then
            roundOver = true
        end

        if roundOver then
            while getTotal(dealerHand) < 17 do
                takeCard(dealerHand)
            end
        end
    elseif isMouseInButton(button_PlayAgainX, button_PlayAgainWidth) then
        reset()
    end
end