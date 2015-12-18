require! fs
require! urlencode

dir = "#__dirname/../../temp-work/wiki"
files = fs.readdirSync dir
# files.length = 1
dict = {}
i = files.indexOf "20151203-000000.txt"
files .= slice i
lastDay = files.0.substr 0, 8
for file in files
  day = file.substr 0, 8
  if day != lastDay
    out = "page\tcount\n"
    for page, count of dict
      continue if count < 10
      out += "#page\t#count\n"
    fs.writeFileSync "#__dirname/../data/daily/#day.tsv", out
    dict = {}
    lastDay = day
  console.log i, file
  i++
  lines = fs.readFileSync "#dir/#file"
    .toString!
    .split "\n"
  for line in lines
    continue unless "cs " == line.substr 0, 3
    [lang, page, count] = line.split " "
    # try
    #   page =  urlencode.decode page
    count = parseInt count, 10
    if dict[page]
      dict[page] += count
    else
      dict[page] = count


