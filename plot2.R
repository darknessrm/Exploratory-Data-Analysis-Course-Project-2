library(dplyr)
exdata_filename <- "exdata-data-NEI_data.zip"

if (!file.exists(exdata_filename)) {
  download_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(download_url, destfile = exdata_filename)
  unzip (zipfile = exdata_filename)
}

if (!exists("NEI")) {
  # print("Loading NEI Data, please wait.")
  NEI <- readRDS("summarySCC_PM25.rds") 
}

if (!exists("SCC")) {
  # print("Loading SCC Data.")
  SCC <- readRDS("Source_Classification_Code.rds")
}
#Here starts the code for the second plot.
b_total_emissions <- NEI %>%
  filter(fips == "24510") %>%
  group_by(year) %>%
  summarise(Emissions = sum(Emissions))

png('plot2.png')
with(b_total_emissions,
       barplot(height=Emissions/1000, names.arg = year, col = color_range, 
               xlab = "Year", ylab = expression('PM'[2.5]*' in Kilotons'),
               main = expression('Baltimore, Maryland Emissions from 1999 to 2008'))
)
dev.off()