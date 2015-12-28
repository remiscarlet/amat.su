import hashlib

base64Map = {
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

for k,v in base64Map.items():
  base64Map[v] = k


def returnHash(inp):
  inp = hashlib.md5(inp).hexdigest()
  return (''.join('{0:08b}'.format(ord(x), 'b') for x in inp))

def shorten(inp):
  inp = str(inp)
  temp = inp[3::6]
  return temp[:36]

def base64(inp):
  output = ""
  for i in xrange(6):
    bitstring = inp[i*6:(i+1)*6]
    output+=base64Map[bitstring]
  return output

def returnShortenedURL(inp):
  v =  returnHash(link)
  s = shorten(v)
  return base64(s)

def decodeBase64(inp):
  output = ""
  for c in inp:
    output+=base64Map[c]
  return output


# links = [
#   "https://www.facebook.com/groups/866004163507738/permalink/900007110107443/?comment_id=900025450105609&notif_t=group_comment_reply",
#   "http://sixrevisions.com/css/css-specificity/",
#   "https://docs.google.com/document/d/1yMc8cCV7u5oALDcE-mUXHZbMT0B-_J8EcYdo6KNrJqk/edit",
#   "http://stackoverflow.com/questions/7160737/python-how-to-validate-a-url-in-python-malformed-or-not",
#   "https://pythonhosted.org/passlib/lib/passlib.hash.mysql323.html",
#   "https://docs.python.org/2/library/hashlib.html#module-hashlib",
#   "http://stackoverflow.com/questions/18815820/convert-string-to-binary-in-python",
#   "https://www.google.com/search?q=256%2F6&oq=256%2F6&aqs=chrome..69i57j69i64j0l2.1579j0j7&sourceid=chrome&es_sm=91&ie=UTF-8",
#   "http://regexr.com/",
#   "https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=string%20to%20binary%20python",
#   "http://puu.sh/maXeS/f4e077d94b.pdf",
#   "http://stackoverflow.com/questions/1403674/pythonic-way-to-return-list-of-every-nth-item-in-a-larger-list"  

# ]

