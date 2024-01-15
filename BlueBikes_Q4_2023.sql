--querying 3 months of bluebikes dataset via UNION all

select *
from oct_2023
UNION all
select *
from nov_2023
UNION all
select *
from dec_2023

--exporting all 3 datasets via Excel and re-importing back to SQL as 1 dataset

select *
from q4_2023_bike

--cleaning and sorting data

--converting started_at and ended_at datetimes to separate columns of date and time

select started_at, 
cast(started_at as date) as start_date,
cast(started_at as time) as start_time,
ended_at,
cast(ended_at as date) as end_date,
cast(ended_at as time) as end_time
from q4_2023_bike
order by started_at asc

--creating new columns for start_date, start_time, end_date, end_time

alter table q4_2023_bike
add start_date date

update q4_2023_bike
set start_date = cast(started_at as date)

alter table q4_2023_bike
add start_time time

update q4_2023_bike
set start_time = cast(started_at as time)

alter table q4_2023_bike
add end_date date

update q4_2023_bike
set end_date = cast(ended_at as date)

alter table q4_2023_bike
add end_time time

update q4_2023_bike
set end_time = cast(ended_at as time)

--EDA

select *
from q4_2023_bike

--count of rideable type of bikes

select rideable_type, count(rideable_type) as CountofBikeType
from q4_2023_bike
group by rideable_type

--grouping together start_stations to see most to least popular stations for starting point

select start_station_name, count(start_station_id) as CountofStartStations
from q4_2023_bike
group by start_station_name
order by count(start_station_id) desc

--grouping together end_stations to see most to least popular stations for ending point

select end_station_name, count(end_station_name) as CountofStartStations
from q4_2023_bike
group by end_station_name
order by count(end_station_name) desc

--counting total casual riders vs member riders

select member_casual, COUNT(member_casual) as TotalRiders
from q4_2023_bike
group by member_casual

--converting start_date to retrieve days of the week per date to determine which days are most popular for bike rides

select start_date, DATENAME(WEEKDAY, start_date) as DayofWeek
from q4_2023_bike

--placed above query into a subquery to be able to count the total number of each day of the week

select DayofWeek, COUNT(DayofWeek) AS CountofDays
from
(select start_date, DATENAME(WEEKDAY, start_date) as DayofWeek
from q4_2023_bike) as RiderDays
group by DayofWeek
ORDER BY COUNT(DayofWeek) desc

--creating new column for DayofWeek

alter table q4_2023_bike
add DayofWeek varchar(50)

update q4_2023_bike
set DayofWeek =  DATENAME(WEEKDAY, start_date) 

--converting start_time and end_time hh:mm:ss format to minutes 

select start_time, end_time, (datediff(second,start_time, end_time)/60) as MinutesRide
from q4_2023_bike

--creating new column for MinutesRide

alter table q4_2023_bike
add MinutesRide int

update q4_2023_bike
set MinutesRide = (datediff(second,start_time, end_time)/60)

--using above query for subquery to find min, max, average minutes of riders

select AVG(MinutesRide) as AvgMinutes from
(select start_time, end_time, ROUND((datediff(second,start_time, end_time)/60),2) as MinutesRide
from q4_2023_bike) as MinuteBike

select MAX(MinutesRide) as MaxMinutes from
(select start_time, end_time, ROUND((datediff(second,start_time, end_time)/60),2) as MinutesRide
from q4_2023_bike) as MinuteBike

select MIN(MinutesRide) as MinMinutes from
(select start_time, end_time, ROUND((datediff(second,start_time, end_time)/60),2) as MinutesRide
from q4_2023_bike) as MinuteBike

--calculating most to least popular day of the 3 months for riders

SELECT start_date, COUNT(*) as RidersPerDay
FROM q4_2023_bike
group by start_date
HAVING COUNT(*) > 1
order by COUNT(*) desc


select ride_id, rideable_type, member_casual, start_date, start_time, start_station_name, end_date, end_time, end_station_name, MinutesRide, DayofWeek, start_lat, start_lng, end_lat, end_lng
from q4_2023_bike