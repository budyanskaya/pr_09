-- 1. Создаем временную таблицу с координатами долготы и широты для каждого клиента.
create temp table customer_points as(
select customer_id, 
point(longitude, latitude) as lng_lat_point
from customers
where longitude is not null
and latitude is not null);

-- Проверка
select * from customer_points



-- 2. Создаем аналогичную таблицу для каждого дилерского центра
create temp table dealership_points as(
select dealership_id,
point(longitude, latitude) as lng_lat_point
from dealerships);

-- Проверка
select * from dealership_points;


-- 3. Объединить эти таблицы, чтобы рассчитать расстояние от каждого клиента до каждого дилерского центра (в милях):

create temp table customer_dealership_distance as(
select customer_id,
dealership_id,
c.lng_lat_point <@> d.lng_lat_point as distance
from customer_points c
cross join dealership_points d);

-- Проверка

select * from customer_dealership_distance;

-- 4. Определяем ближайший дилерский центр для каждого клиента.

create temp table closest_dealerships as(
select distinct on (customer_id)
customer_id,
dealership_id,
distance
from customer_dealership_distance
order by customer_id, distance);

-- Проверка
select * from closest_dealerships;


