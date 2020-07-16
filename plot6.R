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
#Here starts the code for the sixth plot.
fips_lookup <- data.frame(fips = c("06037", "24510"), county = c("Los Angeles", "Baltimore"))

vehicles_SCC <- SCC[grep("[Vv]ehicle", SCC$EI.Sector), "SCC"]
vehicle_emissions <- NEI %>%
  filter(SCC %in% vehicles_SCC & fips %in% fips_lookup$fips) %>%
  group_by(fips, year) %>%
  summarize(Emissions = sum(Emissions))

vehicle_emissions <- merge(vehicle_emissions, fips_lookup)

png('plot6.png')

bcv_plot <- ggplot(vehicle_emissions, aes(x = factor(year), y = round(Emissions/1000, 2), 
                                          label=round(Emissions/1000,2), fill = year)) +
  geom_bar(stat = "identity") + facet_grid(. ~ county) +
  ylab(expression('PM'[2.5]*' Emissions in Kilotons')) + xlab("Year") +
  geom_label(aes(fill = year),colour = "white", fontface = "bold") +
  ggtitle("Los Angeles vs Baltimore Vehicle Emissions.")
print(bcv_plot)

dev.off()