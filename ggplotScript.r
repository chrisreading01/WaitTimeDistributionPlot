library(ggplot2)
library(dplyr)

load("referralToFirstApptData.Rdata")

#Note: sample data only contained the monthly data view, original dataset contained quarterly and yearly aggregations as well

distTime <- "Monthly" ##Grouping interval for date axis
distCancerSite <- "Example"

if(distTime == "Yearly") {
  tp <- "By Year"
  gap <- "1 year"
  label <- "%Y"
}
if(distTime == "Quarterly") {
  tp <- "By Quarter"
  gap <- "3 months"
  label <- "%B %Y"
}
if(distTime == "Monthly") {
  tp <- "By Month"
  gap <- "1 month"
  label <- "%B %Y"
}

dataset <- testData
dataset$SortDate <- as.Date(dataset$SortDate,format = "%d/%m/%Y")

filterset <- filter(dataset,Category == tp & Somerset_CancerSite == distCancerSite)
ggplot(filterset,aes(y = SortDate, x = DaysUntilSeen, size = PatientCount, color = DaysUntilSeen)) +
  geom_point(alpha = 0.8) +
  scale_size_area(max_size = 10) +
  geom_vline(xintercept = 14.5, colour = "red") +
  scale_colour_gradient(low="#9ebcda",high="#dd1c77") +
  labs(x = "Days from Referral to 2WW Appt", y = "Referral Month", title = paste0("Days from Referral to 2WW Appt (",distCancerSite,")")) +
  scale_y_date(breaks = gap,date_labels = label,limits = c(min(filterset$SortDate,na.rm = TRUE),max(filterset$SortDate,na.rm = TRUE))) +
  scale_x_continuous(breaks = seq(from = 0, to = max(filterset$DaysUntilSeen,na.rm = TRUE)+2,by = 7))
