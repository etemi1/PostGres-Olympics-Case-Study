-- How many athletes compete during winter and summer
select Season,count(name) as counts
from olympics_history
where season IN('Summer','Winter')
group by season
    

--Compare and contrast the summer and the winter games
---1 How many athlethes compete
---2 How many countries compete
---3 How many events are there?

--Total ATHLETES from all countries combined
with cte as (
select name,count(distinct(name)) as cnt, year
from olympics_country as oc
inner join olympics_history as oh
using(noc)
group by year,name)
select count(distinct(name))
from cte   

--- Events and athletes
select Season,count(distinct(event))as Event, count(distinct(name)) athletes
from olympics_history
where season IN('Summer','Winter')
group by season


--- compare and contrast Events and countries
select Season,count(distinct(event))as Event, count(distinct(oc.noc)) athletes
from olympics_history as oh
inner join olympics_country as oc ON
oc.noc = oh.noc
where season IN('Summer','Winter')
group by season

-- which coutries send the most athletes to the olympics
select oc.noc, count(distinct(name)) as athlete
from olympics_history as oh
inner join olympics_country as oc
on oc.noc=oh.noc
group by oc.noc
order by athlete desc
fetch first 10 rows only

--- List of countries with most medals
select o as country, count(medal) as medals
from olympics_history as oh
inner join olympics_country as oc
using(noc)
where medal <> 'NA'
group by country
order by medals desc
fetch first 10 rows only

---- total number of female and male athlethes 
select sex ,
    case when sex = 'F' then count(sex)
         WHEN SEX = 'M' then count(sex)
         END AS genders
from olympics_history
group by sex


--- total number of gold, silver and bronze medal won
select medal, count(medal) as medals_won
from olympics_history
where medal <> 'NA'
group by  medal
order by medals_won desc
-- or we can use this query 
select medal,
       count(medal) as medals,
count(medal) over(partition by medal) as total
from olympics_history
where medal <> 'NA'
group by medal 

-- Top 5 athletes with the most gold medals
 with cte as(
select name, medal, count(medal) as medals,
dense_rank() over(order by count(medal) desc) as overall_rank
from olympics_history
where medal = 'Gold'
group by name,medal
order by medals desc)
select *
from cte
where overall_rank <=5

--- List for oldest and youngest age of gold winners
select age, oc.region as country, count(*) AS medals
        from olympics_history as oh
        join olympics_country as oc 
        using(noc)
        where medal <> 'NA' and oc.region <>'USA'
        group by country, age
        order by medals desc

--  total counts of gold, bronze and silver medals by country
select country
, coalesce (gold, 0) as gold
, coalesce (silver, 0) as silver
, coalesce (bronze,0) as bronze
from crosstab('select oc.region as country, medal, count(medal) as medals_counts
from olympics_history as oh
join olympics_country as oc ON
oh.noc=oc.noc
where medal <> ''NA''
group by country,medal
              order by country, medal',
              'values (''Bronze''),(''Gold''),(''Silver'')')

    as result (country varchar, Bronze bigint, Gold Bigint, Silver bigint)
    order by gold desc, silver desc, bronze desc



-- Percentage of female to male gender that participated 
  with cte as 
(select cast(count(id) as float) as total_athlete
 from olympics_history)
select sex, 
case when sex = 'F' THEN round(cast((count(*)/total_athlete)* 100 as numeric),2)
 when sex = 'M' THEN round(cast((count(*)/total_athlete)* 100 as numeric),2)
end as percentage_of_participating_athlete
from olympics_history,cte
group by sex, cte.total_athlete


--- Total season games and PERCENT
 with cte as 
 (
select cast(count(season) as float) as season_games
     from olympics_history)
         select season,COUNT(*)as game_count,
            case when season ='Summer' then round(cast((count(*)/season_games)*100 as numeric),2)
             when season ='Winter' then round(cast((count(*)/season_games)*100 as numeric),2)
             end as percent_games
             from olympics_history, cte
             group by season, cte.season_games
             ORDER BY percent_games desc
            
		
--- Medal count by sex
select sex,
case when sex ='F' then count(medal) 
when sex = 'M' then count(medal)
end as medal_count
from olympics_history
group by sex
order by medal_count desc

--- How many Sports has both genders participated in ?
select sex, count(distinct(sport)) as total_sports_played
from olympics_history
group by sex 


-- What games are played mostly by females
select sport, sex, count(sport) as sports
from olympics_history
WHERE  SEX = 'F'
group by sport,sex
order by sports desc, sex
FETCH FIRST 5 ROWS ONLY


-- What games are played mostly by males
select sport, sex, count(sport) as sports
from olympics_history
WHERE  SEX = 'M'
group by sport,sex
order by sports desc, sex
FETCH FIRST 5 ROWS ONLY








