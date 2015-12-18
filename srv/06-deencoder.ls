require! fs
require! urlencode

encoded = fs.readFileSync "#__dirname/../data/yearly-top.tsv" .toString!
  .split "\n"

decoded = for line in encoded
  try
      line =  urlencode.decode line
  line

decoded .= join "\n"

fs.writeFileSync do
  "#__dirname/../data/yearly-top-deencoded.tsv"
  decoded

