-- this function owns to roblox, so i made my own one.
concat = table.concat
function string:split(sep)
  local t = {}
  sep = sep or ' '
  self = self .. sep
  for x in self:gmatch('(.-)' .. sep) do
    t[#t+1] = x
  end
  return t
end

-- bxor function, i didnt made that i got this from stackoverflow hahahaha.
function bxor(a, b)
  if type(a) == 'string' or type(b) == 'string' then return end
    local XOR_l =
    {
        {0, 1},
        {1, 0},
    }
    local pow = 1
    local c = 0
    while a > 0 or b > 0 do
        c = c + (XOR_l[(a % 2) + 1][(b % 2) + 1] * pow)
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        pow = pow * 2
    end
    return c
end
-- num to hex converter, this convert the hexa in a way other decryptors can read it.
function num2Hex(num)
  local hex = string.format('%x',tostring(num))
  if #hex == 1 then
    return '0' .. hex:upper()
  end
  return hex:upper()
end
function hex2Num(hex)
  if #hex >1 then
    if hex:sub(1,1) == '0' then hex = hex:sub(2,2) end
  end
  return tonumber(string.format('%d', '0x'..hex))
end


--[[This is the xor key encryption
  it take 3 params, the first one is the key
  the second one is the text u wanna encrypt
  and the third one is a boolean
  if its true or any true value it will return the-
  output in hexadecimal.
]]
function encryptXor(key,text,hexa)
  local j = 1
  local result = {}

  for i = 1,#text do
    local byte = text:sub(i,i):byte()
    result[#result+1] = hexa and num2Hex(bxor(byte,key:sub(j,j):byte())) or bxor(byte,key:sub(j,j):byte())
    j = j + 1
    if j > #key then
      j=1
    end
  end
  -- u can return it as table.concate(result,' ')
  return result
end
-- this convert a number into a binary
function num2Bin(num)
  local div = num
  local result = ''
  while div > 0 do
    local bin = div%2
    div = math.floor(div/2)
    result = result .. bin
  end
  return result:reverse()
end


--[[
  this one decrypt the xor
  takes 2 params
  the first one is the xor encrypted value
  and the second one is the key
]]
function decryptXor(xor,key,isHex)
local xor2 = {unpack(xor)}
  -- make sure to set the 3th argument as true if u sending it as hex, and this returns bytes/ascii.
      if type(xor2) == 'string' then xor2 = xor2:split(' ') end
      local j = 1
      for i = 1, #xor2 do
          xor2[i] = bxor((isHex and hex2Num(xor2[i]) or xor[i]), key:sub(j,j):byte())
          j = j + 1
          if j > #key then
              j = 1
          end
      end
      return xor2
end

function bytes2Text(bytes)
    local result = ""
    for i = 1, #bytes do
        result = result .. string.char(bytes[i])
    end
    return result
end
-- cesarCipher only alfabetic, you can convert it to ascii doing string.char(string.byte()+shift), but i prefer the classic way
function cesarCipher(text,shift)
  shift = shift or 3
  local abcLower = 'abcdefghijklmnopqrstuvwxyz'
  local abcUpper = abcLower:upper()
  local result = ''
  for i = 1,#text do
    local letter = text:sub(i,i)
    if abcLower:find(letter) then
      local shf = abcLower:find(letter) + shift
      if shf >#abcLower then shf = shf - #abcLower end
      result = result .. abcLower:sub(shf,shf)
      elseif abcLower:find(letter) then
      local shf = abcLower:find(letter) + shift
      if shf >#abcLower then shf = shf - #abcLower end
      result = result .. abcLower:sub(shf,shf)
      else result = result .. text:sub(i,i)
    end
  end

  return result
end
-- here some examples.
key = 'im a key'
data = 'Hey, i was an encrypted text!'
encrypted = encryptXor(key,data, not false)
decrypted = bytes2Text(decryptXor(encrypted, key, true))

print('Key:', key)
print('Encrypted:', concat(encrypted,' '))
print('Decrypted:', decrypted)
print(('='):rep(40))
print('Decrypted with wrong key:',bytes2Text(decryptXor(encrypted, 'imnotkey', true)))



--[[
  made by me (ramirez.#7396)
  if u wanna use this functions in ur code go ahead!, thats why i made them, soon bringing more!!
]]
