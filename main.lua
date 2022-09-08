
local emoji = "🐐"
local board_data = {top_L= " ", top_M = " ", top_R= " ", mid_L= " ", mid_M= " ", mid_R= " ", low_L= " ", low_M= " ",
low_R= " "}

local location = {"top","mid","low"}
local position = {"_L","_M","_R"}

local function draw_board(board) -- Draws the board
    print(
        board["top_L"].."|"..board["top_M"].."|"..board["top_R"].."\n"..
    "------\n"..
    board["mid_L"].."|"..board["mid_M"].."|"..board["mid_R"].."\n"..
    "------\n"..
    board["low_L"].."|"..board["low_M"].."|"..board["low_R"].."\n"
    )
end

local function check_if_avaliable(board,input) -- Checks if the user has entered a position in a empty spot
    return board[input] == " "
end

local function make_move(_board,_position,_mark)
    _board[_position] = _mark
end

local function check_win(board,current_turn) --Checks to see if player won 
    for i = 1, 3 do --check each rows
        if board[location[i]..position[1]] == current_turn and board[location[i]..position[2]] == current_turn and board[location[i]..position[3]] == current_turn then
            return true --check collums
        elseif board[location[1]..position[i]] == current_turn and board[location[2]..position[i]] == current_turn and board[location[3]..position[i]] == current_turn then
            return true 
        end -- check diagonals
    end
    if board[location[1]..position[1]] == current_turn and board[location[2]..position[2]] == current_turn and board[location[3]..position[3]] == current_turn then
        return true
    elseif board[location[3]..position[1]] == current_turn and board[location[2]..position[2]] == current_turn and board[location[1]..position[3]] == current_turn then
        return true
    end
end

local function check_tie(board)
    local is_not_empty = 0
    for i = 1,3 do
        if board[location[i]..position[1]] ~= " " and board[location[i]..position[2]] ~= " " and board[location[i]..position[3]] ~= " " then
            is_not_empty = is_not_empty + 3
        end
    end
    return is_not_empty == 9
end

local function find_empty_slots(board)
    local key_array = {"top_L","top_M","top_R","mid_L","mid_M","mid_R","low_L","low_M","low_R"}
    local empty_slots = {}
        for a in pairs(key_array) do
            if board[key_array[a]] == " " then
                table.insert(empty_slots,key_array[a])
            end
        end
    return empty_slots
end

local function minimax(board,current_player) -- Minimax algorithm
    local avaliable_slots = find_empty_slots(board) -- gets a table of empty slots on the board
    local size_of_array = #avaliable_slots

    if check_win(board,"X") then -- Check to see if player won the game
        return {score = -1}
    elseif check_win(board,"O") then -- Checks to see if ai won the game
        return {score = 1}
    elseif check_tie(board) then -- Checks for a tie
        return {score = 0}
    end

    local allTestPlayInfos = {} -- hold all the attempts in this empty table

    for i = 1, size_of_array do -- Loop through the array and apply recursion with minimax
        local currentTestPlayInfo = {}
        local index = avaliable_slots[i]
        currentTestPlayInfo["index"] = index
        board[index] = current_player

        if current_player == "O" then -- Sinces its the ai's turn we change it to x's turn
            local x_result = minimax(board,"X")-- Minimizing Recursion
            currentTestPlayInfo["score"] = x_result["score"]
        else
            local o_result = minimax(board,"O") -- Maximizing Recursion
            currentTestPlayInfo["score"] = o_result["score"]
        end
        board[index] = " " -- Empty the board
        table.insert(allTestPlayInfos,i,currentTestPlayInfo) -- Store the current play of the board

    end
    local bestTestPlay = nil -- Holds the index of the best possiable move
    if current_player == "O" then
        local best_score = -700 -- Check if the ai has a win conditon by checking the score value
        for i = 1, #allTestPlayInfos do
            if allTestPlayInfos[i]["score"] > best_score then
                best_score = allTestPlayInfos[i]["score"] -- Add the best score
                bestTestPlay = i -- Set the index of the best move
            end
        end
    else
        local best_score = 700 -- Check if the player has a win conditon by checking the score value
        for i = 1, #allTestPlayInfos do
            if allTestPlayInfos[i]["score"] < best_score then
                best_score = allTestPlayInfos[i]["score"]
                bestTestPlay = i
            end
        end
    end
    return allTestPlayInfos[bestTestPlay] -- Return the index and score of the game
end

local function main(board)
    local current_turn = "X"
    while true do
        if current_turn == "X" then
            print("\nSelect a position by typing (Top_Left = top_L, Top_Mid = top_M, Low_Left= low_L) ")
            print("(top, mid, low) \n")
            draw_board(board)
            
            print("Player's turn: ")
            local input = io.read()
            if check_if_avaliable(board,input) then
                make_move(board,input,current_turn)
                draw_board(board)
                if check_win(board,current_turn) then
                    print("\nPlayer " .. current_turn .. " has won this game!")
                    return
                elseif check_tie(board) then
                    print("Tie game!")
                    return
                end
                current_turn = "O"
            else
                print("Please choose differnt position.")
            end
        else
            print("\nAI's turn!")
            local play = minimax(board,current_turn)
            make_move(board,play["index"],current_turn)
            draw_board(board)
            if check_win(board,current_turn) then
                print("\nPlayer " .. current_turn .. " has won this game!")
                return
            elseif check_tie(board) then
                print("Tie game!")
                return
            end
            current_turn = "X"
        end
    end
end

main(board_data)