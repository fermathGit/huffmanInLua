require("huffman")
require("printTable")

local str = "a,a,a,a,a,a,a,a,a,a,b,b,c,c,c,c,d,e"

print("\nbegin:" .. str .. "\n")

local fixedLengthSerializeRes = huffman:fixedLengthSerialize(str)
print("fixedLengthSerialize:" .. fixedLengthSerializeRes)
print("lenght:" .. string.len(fixedLengthSerializeRes))
print("fixedLengthDeserialize:" .. huffman:fixedLengthDeserialize(fixedLengthSerializeRes))
print("")
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print("")
local huffmanSerializeRes = huffman:huffmanSerialize(str)
print("huffmanSerialize:" .. huffmanSerializeRes)
print("lenght:" .. string.len(huffmanSerializeRes))
print("huffmanDeserialize:" .. huffman:huffmanDeserialize(huffmanSerializeRes))

local file2 = io.output("log.txt")
io.write(printStrings)
io.flush()
io.close()
