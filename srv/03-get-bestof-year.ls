require! fs
dir = "#__dirname/../data/daily"
files = fs.readdirSync dir
dict = {}
for file in files
  lines = fs.readFileSync "#dir/#file"
    .toString!
    .split "\n"
    .slice 1
  for line in lines
    [page, count] = line.split "\t"
    # try
    #   page =  urlencode.decode page
    count = parseInt count, 10
    if dict[page]
      dict[page] += count
    else
      dict[page] = count

out = "page\tcount\n"
for page, count of dict
  out += "#page\t#count\n"
fs.writeFileSync "#__dirname/../data/yearly.tsv", out


