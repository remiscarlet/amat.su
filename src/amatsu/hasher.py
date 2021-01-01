import hashlib

base64_map_tmp = {
  "000000":"a", "011010":"A", "110100":"0",
  "000001":"b", "011011":"B", "110101":"1",
  "000010":"c", "011100":"C", "110110":"2",
  "000011":"d", "011101":"D", "110111":"3",
  "000100":"e", "011110":"E", "111000":"4",
  "000101":"f", "011111":"F", "111001":"5",
  "000110":"g", "100000":"G", "111010":"6",
  "000111":"h", "100001":"H", "111011":"7",
  "001000":"i", "100010":"I", "111100":"8",
  "001001":"j", "100011":"J", "111101":"9",
  "001010":"k", "100100":"K", "111110":"-",
  "001011":"l", "100101":"L", "111111":"_",
  "001100":"m", "100110":"M",
  "001101":"n", "100111":"N",
  "001110":"o", "101000":"O",
  "001111":"p", "101001":"P",
  "010000":"q", "101010":"Q",
  "010001":"r", "101011":"R",
  "010010":"s", "101100":"S",
  "010011":"t", "101101":"T",
  "010100":"u", "101110":"U",
  "010101":"v", "101111":"V",
  "010110":"w", "110000":"W",
  "010111":"x", "110001":"X",
  "011000":"y", "110010":"Y",
  "011001":"z", "110011":"Z",
}
base64_map = {}

for k,v in base64_map_tmp.items():
  base64_map[k] = v
  base64_map[v] = k


def returnHash(inp):
  inp = hashlib.md5(inp.encode()).hexdigest()
  return (''.join('{0:08b}'.format(ord(x), 'b') for x in inp))

def shorten(inp):
  inp = str(inp)
  temp = inp[3::6]
  return temp[:36]

def base64(inp):
  output = ""
  for i in range(6):
    bitstring = inp[i*6:(i+1)*6]
    output+=base64_map[bitstring]
  return output

def returnShortenedURL(inp):
  v = returnHash(inp)
  s = shorten(v)
  return base64(s)

def decodeBase64(inp):
  output = ""
  for c in inp:
    output+=base64_map[c]
  return output
