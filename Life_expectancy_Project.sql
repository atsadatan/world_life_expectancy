-- world_life_expectancy-- firsrt project

-- # Data cleaning --

-- 1.1# delete duplicate--

SELECT * 
FROM world_life_expectency.world_life_expectancy ;


select country , year
from world_life_expectancy;

select country, year, concat(country , year), count(concat(country , year))
from world_life_expectancy
group by country, year, concat(country , year)
having count(concat(country , year)) > 1 ;


select  Row_id
from
(
select Row_ID, 
concat(country,year),
row_number() over(partition by concat(country,year)) as row_num
from world_life_expectancy
) as row_table
where row_num > 1   ;

delete  from world_life_expectancy
where Row_ID in (

select Row_ID
from
(
select Row_ID, 
concat(country,year),
row_number() over(partition by concat(country,year)) as row_num
from world_life_expectancy
) as row_table
where row_num > 1   

)
;

-- 1.2# delete blank--

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` IS NULL OR `Life expectancy` = '' ;
;


select distinct(status)
from world_life_expectancy
where status <> '' 
;


select distinct(country)
from world_life_expectancy
where status = 'Developing' 
;

UPDATE world_life_expectancy
set status = 'Developing' 
where country in 
(
select distinct(country)
from world_life_expectancy
where status = 'Developing' 
)
;


update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country =t2.country
    set t1.status = 'Developing'
    where t1.status = ''
    and t2.status <> ''
    and  t2.status = 'Developing'
;

select Country, year, `Life expectancy`
from world_life_expectancy
 where `Life expectancy` IS NULL OR `Life expectancy` = '' ;


select * 
from world_life_expectancy ;

update world_life_expectancy 
set `Life expectancy` =  76.5
where country = 'Albania' and year = 2018 ;

-- # Exploratory data --

select * 
from world_life_expectancy;


-- let's see how good each country has made in Health System over15 year --
select Country , status,
MIN(`Life expectancy`) as Min_life_expectancy, 
Max(`Life expectancy`) as Max_life_expectancy,
Round( Max(`Life expectancy`)- MIN(`Life expectancy`),1) as life_increase_15year
FROM world_life_expectancy
GROUP BY Country, status
having MIN(`Life expectancy`) <> 0 
and Max(`Life expectancy`) <> 0
ORDER BY life_increase_15year desc
;

-- Now let's see how good the world has made in Health System over15 year --
select Year, round(AVG(`Life expectancy`),1)  as World_life_expectancy_trend
FROM world_life_expectancy
group by Year
Order by Year
;

-- Too see the correlation between life expectancy and GDP --
select country , Round(AVG(`Life expectancy`),2) as life_exp, Round(AVG(GDP),2) as GDP
from world_life_expectancy
group by country
having life_exp <> 0 and GDP > 0
order by GDP asc
;

-- look at the difference in life expectancy between Developed and Develpoing country
select status, round(avg(`Life expectancy`),1) as _AVG_life_expectancy
from world_life_expectancy 
group by status
;


-- Now see how well-being affect life expectancy, considering life expectancy with BMI 
-- (BMI could imply that the more people have money to buy food, making them have the more BMI) --

select country , Round(AVG(`Life expectancy`),2) as life_exp, Round(AVG(BMI),1) as BMI
from world_life_expectancy
group by country
having life_exp <> 0 
and BMI > 0
order by BMI desc ;









