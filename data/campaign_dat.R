library(rvest)
library(tidyverse)

# GOAL: Create a list of all Obama Administration cabinet members.
# They will be used as the "field staff". Each will be assigned a region and turf code. 

session <- html_session("https://en.wikipedia.org/wiki/Category:Obama_administration_cabinet_members")

staff <- session %>% 
  html_nodes(".mw-category-group ul li") %>% 
  html_text() %>% 
  str_remove("\\([a-z]+\\)") %>% 
  str_squish() %>% 
  as_data_frame() %>% 
  filter(!str_detect(value, "Template")) %>% 
  rename(name = value) %>% 
  pull()
             
# Voter registrations collected (david litt's description of work as a field staffer)
# One-on-ones (taken from david litt's description of work as a field staffer) - 
# From: https://medium.com/national-democratic-training-committee/political-campaign-metrics-every-campaign-needs-4d29273429fe
# phone calls made, voters contacted
# doors knocked, voters contacted @ doors & their rating 1: their candidate, 5: oponents candidate (from david litt)
# contact rate? calculated
# commit to vote cards collected: https://www.txdemocrats.org/media/texas-democrats-mytexasvotes-launches-commit-to-vote-program/

# Election day 2020 is Nov. 3, 2020 
# Lets say field work starts april 2019

e_day <- as.Date("11/3/2020", format = "%m/%d/%Y")
first_day <- as.Date("4/1/2020", format = "%m/%d/%Y")

# create a sequence of all the dates between april 1 and e-day 2020
all_dates <- seq(first_day, e_day, by = "day")


set.seed(0)
x <- tibble(dates = all_dates) %>% 
  #mutate(dow = wday(all_dates, label = TRUE)) %>% 
  sample_n(10000, replace = TRUE) %>% 
  mutate(staff = sample(staff, size = n(), replace = TRUE),
         # "no zero days" is BS, it happens. 
         ctv_collected = round(rgamma(n(), shape = 3, scale = 6))) %>% 
  # hypothetically canvassing starts ~1 month prior to an election, 2/3/20 is iowa caucaus 
  mutate(canvass_period = if_else(dates > as.Date("2020/02/03") - 30, 1, 0),
         dow = wday(dates, label = TRUE),
         doors_knocked = case_when(
           canvass_period == 1 & dow == "Sun" ~ floor(rgamma(n(), shape = 4, scale = 10)),
           canvass_period == 1 & dow == "Sat" ~ floor(rgamma(n(), shape = 4, scale = 20)),
           canvass_period == 1 & dow == "Fri" ~ floor(rgamma(n(), shape = 4, scale = 12)),
           canvass_period == 1 & dow == "Thu" ~ floor(rgamma(n(), shape = 4, scale = 5)),
           TRUE ~ 0
         ),
         # if there are fewer than 15 doors knocked make it 0 because that's lame to knock 4 doors
         doors_knocked = ifelse(doors_knocked < 15, 0, doors_knocked),
         doors_rate = runif(n(), min = 0, max = .85),
         doors_contacted = floor(doors_knocked * doors_rate),
         # when people are canvassing they aren't collecting pledges as frequently,
         # reduce it by the inv of door_rate when doors > ctv
         ctv_collected = ifelse(doors_knocked >= ctv_collected,
                                yes = round(ctv_collected * (1 - doors_rate)),
                                no = ctv_collected)
         )



#-------- scratch area --------# 

y %>% 
  group_by(staff) %>% 
  summarise(avg_ctv = mean(ctv_collected),
            max_ctv = max(ctv_collected),
            min_ctv = min(ctv_collected),
            total_ctv = sum(ctv_collected)) %>% 
  top_n(100, avg_ctv)

runif(1, min = 0, max = .8)

%>% select(dow, doors_knocked) %>% 
  filter(!is.na(doors_knocked)) %>%
  group_by(dow) %>% 
  summarise(max(doors_knocked), min(doors_knocked))


# for canvassing dates I can use a case when to sample a different distribution for each day
      

floor(rgamma(10000, shape = 2, scale = 6)) %>% 
  hist()
