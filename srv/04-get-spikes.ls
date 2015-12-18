require! fs
require! urlencode

dir = "#__dirname/../data/daily"
days = fs.readdirSync dir
len = days.length

lines = fs.readFileSync "#__dirname/../data/yearly-top.tsv"
  .toString!
  .split "\n"
  .slice 1
dict = {}
for line in lines
  [page, count] = line.split "\t"
  dict[page] = (parseInt count, 10) / len
# days.length = 10
lines = for day in days
  lines = fs.readFileSync "#dir/#day"
    .toString!
    .split "\n"
    .slice 1
  dayBestRatio = -Infinity
  dayBestPage = null
  dayPages = []
  for line in lines
    [page, count] = line.split "\t"
    try
      page =  urlencode.decode page
    count = parseInt count, 10
    continue if isNaN count
    # continue if count < 10000
    continue unless dict[page]
    ratio = count / dict[page]
    dayPages.push {count, ratio, page}

  dayPages.sort (a, b) -> b.ratio - a.ratio
  out = [day]
  for page in dayPages.slice 0, 3
    out.push do
      page.page
      page.ratio
      page.count
  out.join "\t"
lines.unshift "day\tpage1\tratio1\tcount1\tpage2\tratio2\tcount2\tpage3\tratio3\tcount3"
fs.writeFileSync "#__dirname/../data/daily-spikes.tsv", lines.join "\n"
