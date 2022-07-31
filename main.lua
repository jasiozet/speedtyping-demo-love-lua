function IsMatchingStart(s, w)
  for i=1,#w do
    if s:sub(i,i) ~= w:sub(i,i) then
      return false
    end
  end
  return true
end

function Shuffle(x)
	for i = #x, 2, -1 do
		local j = math.random(i)
		x[i], x[j] = x[j], x[i]
	end
end

function love.load()
  WordsToBeAdded = {"borsuk", "kot", "pies", "krowa", "lama", "konik", "sarna", "dzik", "locha", "prosiaczek", "sowa", "kruk", "komar", "osa", "jaguar", "tygrys", "wilk"}
  WordsOnScreen = {}
  Message = ""
  CurrentlyTyped = ""
  Score = 0
  Width = 800
  Height = 600
  GameOver = false
  ElapsedTimeSinceLastAdded = 0
  math.randomseed(os.time())
  Shuffle(WordsToBeAdded)
end

function love.draw()
  if not GameOver then
    for i,word in pairs(WordsOnScreen) do
      love.graphics.print(word.word, word.x, word.y)
    end
    love.graphics.print("Score: " .. Score .. " current: " .. Message, 0, Height - 15)
  else
    love.graphics.print("Game over \nscore: " .. Score, Width/2-50, Height/2-20)
  end
end

function love.update(dt)
  for i,word in pairs(WordsOnScreen) do
    word.y = word.y + 1
    word.x = word.x + word.direction
    if word.x > Width or word.x < 0 then
      word.direction = - word.direction
    end
    if word.y > Height then
      table.remove(WordsOnScreen, i)
      Score = Score - 1
    end
  end
  ElapsedTimeSinceLastAdded = ElapsedTimeSinceLastAdded + dt
  if ElapsedTimeSinceLastAdded > 1 and #WordsToBeAdded > 0 then
    local temp = table.remove(WordsToBeAdded, 1)
    local toBeAdded = {word = temp; x=math.random(0,600), y=0, direction=math.random(-1,1)}
    table.insert(WordsOnScreen, toBeAdded)
    ElapsedTimeSinceLastAdded = 0
  end

  if #WordsOnScreen == 0 and #WordsToBeAdded == 0 then
    GameOver = true
  end
end

function love.keypressed(key, unicode)
  if key == "escape" then
      love.event.quit()
  elseif key == "rctrl" then 
    debug.debug()
  else
    Message = Message .. key
    local isMessageValiable=false
    for i, word in pairs(WordsOnScreen) do
      if word.word == Message then
        Score = Score + 1
        table.remove(WordsOnScreen, i)
      elseif IsMatchingStart(word.word, Message) then
        isMessageValiable = true
      end
    end
    if not isMessageValiable then
      Message = ""
    end
  end
end