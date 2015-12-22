require! fs
require! urlencode

terms =
  "Stepan_Bandera"
  "GIGN"
  "Petr_Fiala_(politolog)"
  "Demograf"
  "Super_Bowl"
  "Program_NSDAP"
  "Jan_Pohan"
  "Alessandro_Volta"
  "Petter_Northug"
  "Gerhard_Mercator"
  "Terry_Pratchett"
  "Vlasta_Korec"
  "Ambra"
  "Dadja_Altenburg-Kohl"
  "Pony_Express"
  "Terra_nullius"
  "Bruce_Jenner"
  "David_Navara"
  "European_Train_Control_System"
  "Pekka_Rinne"
  "Eurovision_Song_Contest_2015"
  "Hydrazin"
  "Pierre_Brice"
  "MERS"
  "Svoboda_panoramatu"
  "Josef_Masopust"
  "Janis_Varufakis"
  "Theobald_Czernin"
  "Jules_Bianchi"
  "Ladislav_Kantor"
  "Ivan_Moravec"
  "Perseidy"
  "Aeronet.cz"
  "Laibach"
  "Villarreal_CF"
  "Skopolamin"
  "Nomofobie"
  "Ztohoven"
  "TV_JOJ"
  "Sitatunga"
  "Lupus"
  "Ivan_Langer"
  "Martin_Havelka"
  "Miroslav_Toman_(1935)"
  "Strana_spravedlnosti_a_rozvoje"
  "Eagles_of_Death_Metal"
  "Mali"
  "Ortel"
  "Miloslav_Ransdorf"


dir = "#__dirname/../data/daily"
out = fs.createWriteStream "#__dirname/../data/spikes-stats.tsv"
out = process.stdout
days = fs.readdirSync dir
out.write "day\t#{terms.join '\t'}"
for day in days
  lines = fs.readFileSync "#dir/#day"
    .toString!
    .split "\n"
    .slice 1
  out.write "\n"
  out.write day
  for term in terms
    termCount = 0
    for line in lines
      [page, count] = line.split "\t"
      try
        page =  urlencode.decode page
      if page == term
        termCount = count
        break

    out.write "\t#termCount"
