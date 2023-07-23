-- ---------------- ЗАДАЧА 1. Создать БД vk, исполнив скрипт _vk_db_creation.sql (в материалах к уроку)

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'юзеры';

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

ALTER TABLE profiles ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE -- (значение по умолчанию)
    ON DELETE RESTRICT; -- (значение по умолчанию)

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'), # DEFAULT 'requested',
    -- `status` TINYINT(1) UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- можно будет даже не упоминать это поле при обновлении
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
    -- CHECK (initiator_user_id <> target_user_id)
);
-- чтобы пользователь сам себе не отправил запрос в друзья
-- ALTER TABLE friend_requests 
-- ADD CHECK(initiator_user_id <> target_user_id);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), -- индексу можно давать свое имя (communities_name_idx)
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), -- записей мало, поэтому в индексе нет необходимости
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body TEXT,
    filename VARCHAR(255),
    -- file BLOB,    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);

-- ---------------- ЗАДАЧА 2. (В ЭТОМ ЗАДАНИИ ВОСПОЛЬЗОВАЛСЯ ПОДАСКАЗКОЙ)
-- Написать скрипт, добавляющий в созданную БД vk 2-3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей) (CREATE TABLE)

-- добавим таблицу фотоальбомов
DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
	`id` SERIAL,
	`name` varchar(255),
    `user_id` BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- добавим таблицу фотографий
DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
	id SERIAL,
	`album_id` BIGINT unsigned,
	`media_id` BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

-- добавим таблицу городов
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	id SERIAL,
	`name` varchar(255) NOT NULL
);

-- добавим поле с идентификатором города
ALTER TABLE profiles ADD COLUMN city_id BIGINT UNSIGNED NOT NULL ;

-- сделаем это поле внешним ключом
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_city_id
    FOREIGN KEY (city_id) REFERENCES cities(id);
    
    -- ЗАДАЧА 3.
-- Написать скрипт, добавляющий в созданную БД vk 2-3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей) (CREATE TABLE)
use vk;

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) VALUES ('1', 'Reuben', 'Nienow', 'arlo50@example.org', '9374071116');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) VALUES ('2', 'Frederik', 'Upton', 'terrence.cartwright@example.org', '9127498182');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) VALUES ('3', 'Unique', 'Windler', 'rupert55@example.org', '9921090703');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) VALUES ('4', 'Norene', 'West', 'rebekah29@example.net', '9592139196');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) VALUES ('5', 'Frederick', 'Effertz', 'von.bridget@example.net', '9909791725');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) VALUES ('6', 'Victoria', 'Medhurst', 'sstehr@example.net', '9456642385');

INSERT INTO messages VALUES 
('1','2','4', 'Hello!', '1988-10-14 18:47:39'),
('2','4','2', 'Good day!', '1988-10-14 14:08:30'),         -- Ну очень древнее сообщение! (пока не учитываем, но получается, что оно отправлено раньше регистрации самого user-а)
('3','3','5', 'Hello!!', '1994-07-10 16:07:03'),
('4','5','3', 'Good evening!', '1994-07-12 20:32:08'),
('5','6','3', 'Hello!!!', '2029-09-10 06:36:01'),          -- Из "будущего"
('6','3','6', 'Good morning!', '2029-09-10 07:27:31'),     -- Из "будущего"
('7','1','4', 'Hello sir!', '2017-04-24 23:30:19'),
('8','4','1', 'Good night!', '2017-04-24 23:40:22'),
('9','5','2', 'Hello sir!!', '2027-04-24 23:40:22'),       -- Из "будущего"
('10','2','5', 'Good day!', '2027-04-25 12:21:40'),        -- Из "будущего"
('11','4','3', 'Hello sir!!!', '2008-12-17 13:03:56'),
('12','3','4', 'Good evening!', '2008-12-17 21:22:38'),
('13','6','1', 'Hello sir!!!!', '2015-09-07 23:34:21'),
('14','1','6', 'Good morning!', '2015-09-08 06:38:27')
; 

INSERT INTO cities VALUES
('1', 'Sochi'),
('2', 'Murmansk'),
('3', 'Arkhangelsk'),
('4', 'Vladivostok')
;

INSERT INTO profiles VALUES
('1','M','2015-09-07', NULL, '2020-07-13 21:22:38', 'Murmansk', '2'),
('2','M','1998-02-12', NULL, '2004-02-02 21:22:38', 'Sochi', '1'),
('3','W','2009-11-23', NULL, '2018-11-19 21:22:38', 'Arkhangelsk', '3'),
('4','W','1970-07-29', NULL, '2003-08-21 21:22:38', 'Sochi', '1'),
('5','M','2001-05-21', NULL, '2011-11-15 21:22:38', 'Murmansk', '2'),
('6','W','2010-04-30', NULL, '2019-04-29 21:22:38', 'Vladivostok', '4')
;

 -- ЗАДАЧА 4*. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). При необходимости предварительно добавить такое поле в таблицу profiles со значением по умолчанию = false (или 0) (ALTER TABLE + UPDATE) (timestampdiff(birthday, now()))
ALTER TABLE profiles 
ADD COLUMN is_active BOOLEAN DEFAULT True;

UPDATE profiles
SET is_active = False
WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18;

-- Проверяем 
SELECT *
FROM profiles
WHERE is_active = True;

-- ЗАДАЧА 5*. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней) (DELETE)

DELETE FROM messages
WHERE TIMESTAMPDIFF(SECOND, created_at, NOW()) < 0;

-- Проверяем оставшиеся сообщения
SELECT *
FROM messages;