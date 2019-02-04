library(readr)
library(zoo)
library(caret)
library(data.table)
library(dplyr)

set.seed(1001)


#load data
print("loading data...")
CA_cleaned <- read_csv("../input/california-traffic-data/CA_cleaned.csv", 
    col_types = cols(county_fips = col_skip(), 
        driver_age = col_skip(), driver_race_raw = col_skip(), 
        ethnicity = col_skip(), fine_grained_location = col_skip(), 
        id = col_skip(), location_raw = col_skip(), 
        police_department = col_skip(), search_type_raw = col_skip(), 
        state = col_skip(), stop_time = col_skip(),
        violation = col_skip()
                    ))
                    
                    
f <- '../input/californiademographics/CAdemographics.csv'
demo_data <-  read.csv(f, stringsAsFactors = F)
                    
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


print("Organizing demographics data...")

county_populations <- demo_data %>%
                        group_by(County) %>%
                            summarise(pop2010 = sum(X2010, na.rm = T),
                                      pop2011 = sum(X2011, na.rm = T),
                                      pop2012 = sum(X2012, na.rm = T),
                                      pop2013 = sum(X2013, na.rm = T),
                                      pop2014 = sum(X2014, na.rm = T),
                                      pop2015 = sum(X2015, na.rm = T),
                                      pop2016 = sum(X2016, na.rm = T))

print("Done with part 1, starting part 2.")

county_demographics <- demo_data %>%
                        group_by(County, Race) %>%
                            summarise(pop2010 = sum(X2010, na.rm = T),
                                      pop2011 = sum(X2011, na.rm = T),
                                      pop2012 = sum(X2012, na.rm = T),
                                      pop2013 = sum(X2013, na.rm = T),
                                      pop2014 = sum(X2014, na.rm = T),
                                      pop2015 = sum(X2015, na.rm = T),
                                      pop2016 = sum(X2016, na.rm = T))
                                      
print("Done.")

print("Adding county level predictors")

counties_train <- unique(CA_cleaned$county_name)
counties_demo <- unique(county_demographics$County)
training_years <- c(2010:2016)

CA_cleaned$population <- NA
CA_cleaned$black_pop <- NA
CA_cleaned$white_pop <- NA
CA_cleaned$hispanic_pop <- NA
CA_cleaned$asian_pop <- NA

black_id <- 'Black (Non-Hispanic)'
white_id <- 'White (Non-Hispanic)'
asian_id <- 'Asian (Non-Hispanic)'
hispanic_id <- 'Hispanic (any race)'

for (county in counties_train) {
    
    if (county %in% counties_demo) {
        
        for (year in training_years) {
            
            demo_idx <- paste0('pop', year)
            
            CA_cleaned[CA_cleaned$county_name == county
                  & CA_cleaned$year == year, ]$population <- as.numeric(county_populations[county_populations$County == county, demo_idx])
            
            CA_cleaned[CA_cleaned$county_name == county
                  & CA_cleaned$year == year, ]$black_pop <- as.numeric(county_demographics[county_demographics$County == county &
                                                                                      county_demographics$Race == black_id,
                                                                                      demo_idx])
            CA_cleaned[CA_cleaned$county_name == county
                  & CA_cleaned$year == year, ]$white_pop <- as.numeric(county_demographics[county_demographics$County == county &
                                                                                      county_demographics$Race == white_id,
                                                                                      demo_idx])
            CA_cleaned[CA_cleaned$county_name == county
                  & CA_cleaned$year == year, ]$asian_pop <- as.numeric(county_demographics[county_demographics$County == county &
                                                                                      county_demographics$Race == asian_id,
                                                                                      demo_idx])
            CA_cleaned[CA_cleaned$county_name == county
                  & CA_cleaned$year == year, ]$hispanic_pop <- as.numeric(county_demographics[county_demographics$County == county &
                                                                                      county_demographics$Race == hispanic_id,
                                                                                      demo_idx])
        }
    }
}

for (county in counties_train) {
    CA_cleaned[CA_cleaned$year == 2009 &
          CA_cleaned$county_name == county,]$population <- round(0.99 * mean(CA_cleaned[CA_cleaned$year == 2010 & 
                                                                        CA_cleaned$county_name == county,]$population))
    
    CA_cleaned[CA_cleaned$year == 2009 &
          CA_cleaned$county_name == county,]$white_pop <- round(0.99 * mean(CA_cleaned[CA_cleaned$year == 2010 & 
                                                                             CA_cleaned$county_name == county,]$white_pop))
    CA_cleaned[CA_cleaned$year == 2009 &
          CA_cleaned$county_name == county,]$black_pop <- round(0.99 * mean(CA_cleaned[CA_cleaned$year == 2010 & 
                                                                             CA_cleaned$county_name == county,]$black_pop))
    CA_cleaned[CA_cleaned$year == 2009 &
          CA_cleaned$county_name == county,]$asian_pop <- round(0.99 * mean(CA_cleaned[CA_cleaned$year == 2010 & 
                                                                             CA_cleaned$county_name == county,]$asian_pop))
    CA_cleaned[CA_cleaned$year == 2009 &
          CA_cleaned$county_name == county,]$hispanic_pop <- round(0.99 * mean(CA_cleaned[CA_cleaned$year == 2010 & 
                                                                             CA_cleaned$county_name == county,]$hispanic_pop))
}

print("Done.")

lined_up <- (sum(is.na(CA_cleaned$population)) == dim(CA_cleaned[CA_cleaned$county_name == 'Missing',])[1])

sprintf("The missing values and counties line up: %f", lined_up)

print("Aggregating the data...")

traffic_count_data <- CA_cleaned %>%
                        group_by(year, county_name, driver_race) %>%
                            summarise(stops = n(),
                                      num_males = sum(driver_gender),
                                      suspect_dui = sum(violation_raw == 'DUI Check'),
                                      move_violation = sum(violation_raw == 'Moving Violation (VC)'),
                                      searches = sum(search_conducted),
                                      consent = sum((search_type == 'Consent'), na.rm = T),
                                      probable = sum((search_type == 'Probable Cause'), na.rm = T),
                                      hits = sum(contraband_found, na.rm = T),
                                      arrests = sum(is_arrested),
                                      warnings = sum((stop_outcome == 'Verbal Warning')),
                                      chp215 = sum((stop_outcome == 'CHP 215')),
                                      collisions = sum((stop_outcome == 'Traffic Collision')),
                                      chp281 = sum((stop_outcome == 'CHP 281')))


print("Done")

p <- 0.05
sprintf("Drawing a subsample with %s of the data", p)
trainIndex <- createDataPartition(CA_cleaned$search_conducted, p = p, 
                                  list = FALSE, 
                                  times = 1)
train <- CA_cleaned[trainIndex,]

print("Writing subsample to csv.")
write.csv(train, file = 'stratifiedSample.csv')
write.csv(traffic_count_data, file = "caTrafficAgg.csv")
print("Completed all tasks.")