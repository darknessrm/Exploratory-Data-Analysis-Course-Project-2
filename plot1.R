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
#Here starts the code for the first plot.
total_annual_emissions <- aggregate(Emissions ~ year, NEI, FUN = sum)
color_range <- 2:(length(total_annual_emissions$year)+1)

png('plot1.png')
with(total_annual_emissions, 
     barplot(height=Emissions/1000, names.arg = year, col = color_range, 
             xlab = "Year", ylab = expression('PM'[2.5]*' in Kilotons'),
             main = expression('Annual Emission PM'[2.5]*' from 1999 to 2008')))
dev.off()