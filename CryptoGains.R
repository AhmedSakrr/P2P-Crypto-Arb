require("httr")
require("jsonlite")
suppressPackageStartupMessages(library(tidyverse))
library(tidyverse)
options(warn=-1)

shell.exec("import_prices.py")
Sys.sleep(10)

p2pusdt <- ("usdt.txt")
p2pusdt_json <- fromJSON(p2pusdt, flatten = TRUE)
p2pusdtok <-max(p2pusdt_json$data$adv.price)

p2peth <- ("eth.txt")
p2peth_json <- fromJSON(p2peth, flatten = TRUE)
p2pethok <-max(p2peth_json$data$adv.price)

p2pbtc <- ("btc.txt")
p2pbtc_json <- fromJSON(p2pbtc, flatten = TRUE)
p2pbtcok <-max(p2pbtc_json$data$adv.price)

apieth <- paste0("https://api.binance.com/api/v3/ticker/price?symbol=ETHUSDT")
apieth <- GET(apieth)
apieth_text <- content(apieth, "text")
apieth_json <- fromJSON(apieth_text, flatten = TRUE)
apieth <- as.data.frame(apieth_json)

apibtc <- paste0("https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT")
apibtc <- GET(apibtc)
apibtc_text <- content(apibtc, "text")
apibtc_json <- fromJSON(apibtc_text, flatten = TRUE)
apibtc <- as.data.frame(apibtc_json)

priceeth <- apieth$price
pricebtc <- apibtc$price

resulteth <- (((((100 / as.numeric(p2pusdtok)) / as.numeric(priceeth)) * as.numeric(p2pethok)) / 100) - 1)*  100
resultbtc <- (((((100 / as.numeric(p2pusdtok)) / as.numeric(pricebtc)) * as.numeric(p2pbtcok)) / 100) - 1)*  100

fn <- "eth.txt"
fb <- "btc.txt"
fa <- "usdt.txt"

#Remove temp txt files.
if (file.exists(fn, fa, fb)) {
  #Delete file if it exists
  file.remove(fn, fa, fb)
}

cat("\n","P2P USDT: ",p2pusdtok,"\n","P2P ETH: ",p2pethok,"\n","P2P BTC: ",p2pbtcok,"\n","\n","ETH Gains: ",resulteth,"%","\n","BTC Gains: ",resultbtc,"%","\n","\n","Press ENTER to exit... ", sep = "")
fin <- readLines("stdin", 1)