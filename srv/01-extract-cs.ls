require! {
  fs
  zlib
  https
  async
}

start = new Date!
  ..setTime 86400 / 2 * 1e3
  ..setFullYear 2015

requests = []
toDouble = -> if it < 10 then "0#it" else it

loop
  dayStr = [start.getFullYear!, toDouble(start.getMonth! + 1), toDouble(start.getDate!)].join ""
  for i in [0 til 24]
    str = "#dayStr-#{toDouble i}0000"
    requests.push str
    if str == "20151214-220000"
      break
  if str == "20151214-220000"
    break
  start.setTime start.getTime! + 86400 * 1e3
# console.log requests.length


i = 7475
requests .= slice i
console.log requests.length

(err) <~ async.eachSeries requests, (dateStr, cb) ->
  try
    process.stdout.write i.toString!
    i++
    month = dateStr.substr 4, 2
    opts =
      host: "dumps.wikimedia.org"
      path: "/other/pagecounts-raw/2015/2015-#month/pagecounts-#dateStr.gz"
    gunzip = zlib.createGunzip!
    csOnly = fs.createWriteStream "#__dirname/../wiki/#dateStr.txt"
    request = https.request opts, (response) ->
      response.pipe gunzip
      response.on \data ->
        process.stdout.write "."
      l = 0
      started = no
      ended = no
      gunzip.on \data (chunk) ->
        str = chunk.toString!
        index = str.indexOf "\ncs"
        if not started
          if -1 != index
            started := yes
            csOnly.write str.substr index + 1 # without newline
        else if not ended
          endIndex = str.indexOf "\ncsb "
          if -1 != endIndex
            ended := yes
            csOnly.write str.substr 0, endIndex
            request.abort!
            csOnly.end!
            console.log " DONE"
            cb!
          else
            csOnly.write str
    request.on \error ->
      console.log it
      cb!
    gunzip.on \error ->
      console.log it
      cb!
    request.end!
  catch e
    console.log e
    cb!

console.log err if err
