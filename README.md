# Практическое задание 9. Геопространственный анализ
## Цель: ознакомиться с принципами и технологиями создания и использования временных таблиц в SQL для хранения и обработки промежуточных данных. Научиться выполнять операции добавления, выборки и анализа данных во временных таблицах, а также освоить основы интеграции подготовленных данных с облачным инструментом визуализации Yandex DataLens.
Определение ближайшего дилерского центра для каждого клиента.
Маркетологи компании пытаются повысить вовлеченность клиентов,
необходимо им помочь найти ближайший дилерский центр.
Разработчикам продукта также интересно знать, каково среднее
расстояние между каждым клиентом и ближайшим к нему дилерским
центром.
## Ход работы
1. Проверить наличие геопространственных данных в базе данных.
2. Создать временную таблицу с координатами долготы и широты для каждого клиента.
3. Создать аналогичную таблицу для каждого дилерского центра.
4. Соединить эти таблицы, чтобы рассчитать расстояние от каждого клиента до каждого
дилерского центра (в киллометрах).
5. Определить ближайший дилерский центр для каждого клиента.
6. Провести выгрузку полученного результата из временной таблицы в CSV.
7. Построить карту клиентов и сервисных центров в облачной визуализации Yandex DataLence.
8. Удалить временные таблицы


## 1. Создаем временную таблицу с координатами долготы и широты для каждого клиента.
````
create temp table customer_points as(
select customer_id, 
point(longitude, latitude) as lng_lat_point
from customers
where longitude is not null
and latitude is not null);
````
Выполняем запрос и получаем следующий результат:

![image](https://github.com/user-attachments/assets/1d95be8e-384d-4fe9-83bc-3c117bbf273b)

Проверим вывод данных из созданной ранее временной таблицы:
````
select * from customer_points
````
Получаем результат:

![image](https://github.com/user-attachments/assets/e353d12e-cddd-41c8-93d4-293f51431351)

## 2. Создаем аналогичную таблицу для каждого дилерского центра.
````
create temp table dealership_points as(
select dealership_id,
point(longitude, latitude) as lng_lat_point
from dealerships);
````
Выполняем запрос и получаем следующий результат:

![image](https://github.com/user-attachments/assets/b0f02a8f-ff0e-48a7-aeb7-853b90aca0a6)

Проверим вывод данных из созданной временной таблицы:
````
select * from dealership_points
````
Получаем результат:

![image](https://github.com/user-attachments/assets/f5122567-1fef-4e61-88dd-4a6a3ce39a3d)

## 3. Теперь нужно соединить эти таблицы, чтобы рассчитать расстояние от каждого клиента до каждого дилерского центра (в киллометрах).
````
create temp table customer_dealership_distance as(
select customer_id,
dealership_id,
c.lng_lat_point <@> d.lng_lat_point as distance
from customer_points c
cross join dealership_points d)
````
Выполняем запрос и получаем следующий результат:

![image](https://github.com/user-attachments/assets/3cd2f1f3-3790-407f-8f9f-a3022e28451d)

Проверим вывод данных из созданной временной таблицы:
````
select * from customer_dealership_distance
````
Получаем результат:

![image](https://github.com/user-attachments/assets/1a99595d-e60d-4128-ba0f-656893d01a73)

## 4. Определяем ближайший дилерский центр для каждого клиента.
````
create temp table closest_dealerships as(
select distinct on (customer_id)
customer_id,
dealership_id,
distance
from customer_dealership_distance
order by customer_id, distance)
````
Выполняем запрос и получаем следующий результат:

![image](https://github.com/user-attachments/assets/bba22cd4-9ed6-4255-8cff-3f6291f6c214)

Проверим вывод данных из созданной временной таблицы:
````
select * from closest_dealerships
````
Получаем результат:

![image](https://github.com/user-attachments/assets/c2e34394-d08c-439f-9799-16587ef29826)

## 5. Проведем выгрузку полученного результата из временной таблицы в CSV
Получаем результат:

![image](https://github.com/user-attachments/assets/3c26eb16-4695-404f-b32a-c09e6aa15580)

## 6. Построим карту клиентов и сервисных центров в облачной визуализации Yandex DataLence.
Переходим в систему Yandex DataLence и создаем подключение с сервером PostgreSQL. После зодаем новый датасет, выбираем источник(таблицы), из которых будем брать данные, далее создаем новые поля customer и dealership с координатами и переходим к созданию чарта. Создаем новый чарт, с типоп карта, создаем два слоя и  перетаскиваем в тултипы каждого из них то, что хотим увидеть на карте, затем получаем следующий результат:

![image](https://github.com/user-attachments/assets/259e896d-fd15-49a9-9c0b-5372ec78f627)

Карту можно рассмотреть по ссылке:
https://datalens.yandex.cloud/preview/n1vh97drkiuy9

После выполнения задания удаляем все временные таблицы.

## Вывод: в ходе работы мы смогли ознакомиться с принципами и технологиями создания и использования временных таблиц в SQL для хранения и обработки промежуточных данных, научились выполнять операции добавления, выборки и анализа данных во временных таблицах, а также освоили основы интеграции подготовленных данных с облачным инструментом визуализации Yandex DataLens.
