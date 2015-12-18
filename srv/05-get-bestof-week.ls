require! fs
require! urlencode

dir = "#__dirname/../data/daily"
files = fs.readdirSync dir
# files.length = 1
dict = {}
i = 0

# files .= slice i
lastDay = files[i].substr 0, 8
save = ->
  out = "page\tcount\n"
  for page, count of dict
    continue if count < 10
    out += "#page\t#count\n"
  fs.writeFileSync "#__dirname/../data/weekly/#day.tsv", out
  dict := {}
  lastDay := day

for file in files
  day = file.substr 0, 8
  if i % 7 == 6
    save!
  console.log i, file
  i++
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


