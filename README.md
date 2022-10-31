# PostGres-Olympics-Case-Study

## 120 Years of Olympic History
Historical data on the modern Olympic Games, from Athens 1896 to Rio 2016. Each row corresponds to an individual athlete competing in an individual event, including the athlete's name, sex, age, height, weight, country, and medal, and the event's name, sport, games, year, and city.

## About the dataset
This dataset contains 2 tables, in CSV format:

The Athlete Events table contains over 270,000
Olympic performances across history
Each record represents an individual athlete 
competing in an individual event
Records contain details about the 
athlete (ID, sex, name, age, height, weight, country) and the event (games, year, city, sport, event, medal)
The Country Definitions table serves as a lookup table with “NOC” as the primary key
Each record represents one country according
to the National Olympic Committee

### Recommended Analysis
Analyze and visualize the % of athletes who were female over time.
First things i did was to check thed data by using
Select * FROM olympics_history
Then another Query to check the total number of females and males to get an idea of the percent of the genders.
![Screenshot (71)](https://user-images.githubusercontent.com/41531796/199002985-11c420e0-927f-4e7d-87d9-f0fa5a8b72af.png)

Finally to See the percentage of female and male over time
---- percentage of female and male athlethes 
with cte as 
(
    select cast(count(id) as float) as total_athlete
    from olympics_history
    )
    select sex,
    case when sex = 'M' THEN round(cast((count(*)/cte.total_athlete )*100 as numeric),2)
    when sex = 'F' THEN round(cast((count(*)/cte.total_athlete)*100as numeric),2)
    end as athlete_percentage
    from olympics_history,cte
    group by sex, cte.total_athlete
    order by cte.total_athlete desc

![Screenshot (73)](https://user-images.githubusercontent.com/41531796/199007409-592e6639-f54e-4ec0-84fd-75f0368a6611.png)

    



#### Compare and contrast the summer and the winter games...

How many athletes compete?
How many countries compete?
How many events are there?

#### Analyze and visualize country-level trends...
Which countries send the most athletes to the olympics?
Do they also tend to win the most medals?
How have these trends changed over time?


