library(readr)
library(zoo)
library(caret)
library(data.table)


set.seed(1001)


#load data
print("loading data...")
CA_cleaned <- read_csv("../input/CA_cleaned.csv", 
    col_types = cols(county_fips = col_skip(), 
        driver_age = col_skip(), driver_race_raw = col_skip(), 
        ethnicity = col_skip(), fine_grained_location = col_skip(), 
        id = col_skip(), location_raw = col_skip(), 
        police_department = col_skip(), search_type_raw = col_skip(), 
        state = col_skip(), stop_time = col_skip(),
        violation = col_skip()
                    ))
                    
print("Done.")

print("Preprocessing data...")                    
columns <- c('driver_race', 'stop_outcome', 'is_arrested')
CA_cleaned <- CA_cleaned[complete.cases(CA_cleaned[, columns]),]
CA_cleaned$driver_gender <- (CA_cleaned$driver_gender == 'M') * 1
CA_cleaned$search_conducted <- CA_cleaned$search_conducted * 1
CA_cleaned$is_arrested <- CA_cleaned$is_arrested * 1
CA_cleaned$contraband_found <- CA_cleaned$contraband_found * 1
CA_cleaned$stop_date <- as.Date(CA_cleaned$stop_date, '%Y-%m-%d')
CA_cleaned$stop_date <- as.yearmon(CA_cleaned$stop_date)
CA_cleaned$search_type[CA_cleaned$search_conducted == 1 & is.na(CA_cleaned$search_type)] <- 'None'

print("Removing logging errors and NAs")
#looks like a logging error, we remove it
CA_cleaned <- CA_cleaned[!(CA_cleaned$driver_age_raw == '7'), ]

#we want to focus on 'adults', so remove this too
CA_cleaned <- CA_cleaned[!(CA_cleaned$driver_age_raw == '0-14'), ]

#label missing county
CA_cleaned$county_name[is.na(CA_cleaned$county_name)] <- 'Missing'
CA_cleaned$count <- 1

print("Recoding dates")
CA_cleaned$year <- year(as.Date(CA_cleaned$stop_date))
CA_cleaned$month <- month(as.Date(CA_cleaned$stop_date))
#shift each year so that 2009 starts at 0
CA_cleaned$year_c <- CA_cleaned$year - min(CA_cleaned$year)

p <- 0.04
sprintf("Drawing a subsample with %s of the data", p)
trainIndex <- createDataPartition(CA_cleaned$search_conducted, p = p, 
                                  list = FALSE, 
                                  times = 1)
train <- CA_cleaned[trainIndex,]

print("Writing subsample to csv.")
write.csv(train, file = 'stratifiedSample.csv')
print("Completed all tasks.")