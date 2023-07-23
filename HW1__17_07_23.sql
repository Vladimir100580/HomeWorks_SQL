// 1.	Создайте таблицу с мобильными телефонами (mobile_phones), используя графический интерфейс. Добавьте скриншот на платформу в качестве ответа на ДЗ.

CREATE TABLE `my_first_db`.`mobile_phones` (
  `id1` INT NOT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(45) NOT NULL,
  `manufacturer` VARCHAR(45) NOT NULL,
  `product_count` INT NOT NULL,
  `price` INT NOT NULL,
  PRIMARY KEY (`id1`));

INSERT INTO `my_first_db`.`mobile_phones` (`product_name`, `manufacturer`, `product_count`, `price`) VALUES ('iPhone X', 'Apple', '3', '76000');
INSERT INTO `my_first_db`.`mobile_phones` (`product_name`, `manufacturer`, `product_count`, `price`) VALUES ('iPhone 8', 'Apple', '2', '51000');
INSERT INTO `my_first_db`.`mobile_phones` (`product_name`, `manufacturer`, `product_count`, `price`) VALUES ('Galaxy S9', 'Samsung', '2', '56000');
INSERT INTO `my_first_db`.`mobile_phones` (`product_name`, `manufacturer`, `product_count`, `price`) VALUES ('Galaxy S8', 'Samsung', '1', '41000');
INSERT INTO `my_first_db`.`mobile_phones` (`product_name`, `manufacturer`, `product_count`, `price`) VALUES ('P20 PRO', 'Huawei', '5', '36000');



// 2. 	Выведите название, производителя и цену для товаров, количество которых превышает 2

SELECT product_name, manufacturer, price 
FROM mobile_phones
WHERE product_count > 2;


// 3.  Выведите весь ассортимент товаров марки “Samsung”

SELECT *
FROM mobile_phones
WHERE manufacturer = 'Samsung';


// 4.* 	С помощью регулярных выражений найти:

// 4.1. Товары, в которых есть упоминание "Iphone"
SELECT 	*
FROM mobile_phones
WHERE product_name LIKE '%iPhone%';

// 4.2. Товары, в которых есть упоминание "Samsung"
SELECT 	*
FROM mobile_phones
WHERE manufacturer LIKE '%Samsung%';

// 4.3. Товары, в названии которых есть ЦИФРЫ  (Здесь, скорее всего, есть более оптимальный метод)
SELECT 	*
FROM mobile_phones
WHERE product_name LIKE '%0%' OR product_name LIKE '%1%' OR product_name LIKE '%2%' OR product_name LIKE '%3%' OR product_name LIKE '%4%' OR product_name LIKE '%5%' OR product_name LIKE '%6%' OR product_name LIKE '%7%' OR product_name LIKE '%8%' OR product_name LIKE '%9%';

// 4.4. Товары, в названии которых есть ЦИФРА "8"  
SELECT 	*
FROM selllphones
WHERE product_name LIKE '%8%';
