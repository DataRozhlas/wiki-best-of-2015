data = d3.tsv.parse ig.data.data, (row) ->
  for field, value of row
    if field == \day
      row[field] = value
    else
      row[field] = parseInt value, 10
  row

terms = for field of data.0
  field
terms .= slice 1
xScale = d3.scale.linear!
  ..domain [0 347]
yScale = d3.scale.linear!
  ..domain [45601 0]

months =
  "01" : "ledna"
  "02" : "února"
  "03" : "března"
  "04" : "dubna"
  "05" : "května"
  "06" : "června"
  "07" : "července"
  "08" : "srpna"
  "09" : "září"
  "10" : "října"
  "11" : "listopadu"
  "12" : "prosince"

headers = d3.selectAll '#article p.perex ~ p'
  ..each (_, i) ->
    <~ setTimeout _, i * 100
    element = document.createElement "div"
      ..setAttribute \class \ig
    @appendChild element
    container = d3.select element
    term = terms[i]
    max = d3.max data.map (.[term])
    yScale = d3.scale.linear!
      ..domain [max, 0]
    maxPoint = null
    points = data.map (it, i) ->
      x = xScale i
      labelX = "#{it.day.substr 6, 2}. #{months[it.day.substr 4, 2]}"
      y = yScale it[term]
      labelY = ig.utils.formatNumber it[term]
      point = {x, y, labelX, labelY}
      if it[term] == max
        maxPoint := point
      point

    config =
      width: 610px
      height: 100px
      padding: {top: 15, right: 40, bottom: 40, left: 65}
      data: [{points}]
    lc = new ig.LineChart container, config
      ..highlight maxPoint
    lc.downlight = -> lc.highlight maxPoint
