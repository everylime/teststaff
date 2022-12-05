--1. Создание таблицы
CREATE TABLE book(book_id INT PRIMARY KEY AUTO_INCREMENT, 
    title VARCHAR(30),
    author VARCHAR(30),
    price DECIMAL(8, 2),
    amount INT);

--2. Вставка записи в таблицу
INSERT INTO book(title, author, price, amount)
VALUES ('Мастер и Маргарита', 'Булгаков М.А.', '670.99', '3');

--3. Выборка всех данных из таблицы
select * from book

--4. Выборка отдельных столбцов
SELECT author, title, price FROM book

--5. Выборка новых столбцов и присвоение им новых имен
SELECT title AS Название, author AS Автор
FROM book;

--6.Выборка данных по условию
SELECT author, title, price
FROM book
WHERE amount < 10;

--7.Выборка данных с сортировкой
SELECT author, title
FROM book
WHERE amount BETWEEN 2 and 14
ORDER BY author DESC, title ASC;

--8.Групповые функции, WHERE и HAVING
SELECT author, SUM(price*amount) AS Стоимость
FROM book
WHERE title <> 'Идиот' AND title <> 'Белая гвардия'
GROUP BY author
HAVING SUM(price*amount) > 5000
ORDER BY Стоимость DESC;

--9. Добавление записей из другой таблицы
INSERT INTO book (title, author, price, amount)
SELECT title, author, price, amount
FROM supply
WHERE author NOT IN ('Булгаков М.А.', 'Достоевский Ф.М.');

--10.Запросы на обновление
UPDATE book, supply
SET book.amount = book.amount + supply.amount,
book.price = ((book.price + supply.price) / 2)
WHERE book.title = supply.title AND book.author = supply.author; 

--11. Создание таблицы с внешними ключами
CREATE TABLE book (
        book_id INT PRIMARY KEY AUTO_INCREMENT, 
        title VARCHAR(50),
        author_id INT NOT NULL, 
        genre_id INT, 
        price DECIMAL(8,2), 
        amount INT, 
        FOREIGN KEY (author_id)  REFERENCES author (author_id),
        FOREIGN KEY (genre_id)  REFERENCES genre (genre_id) );

--12. Соединение INNER JOIN
-- Задание:"Вывести абитуриентов, которые хотят поступать на образовательную программу «Мехатроника и робототехника» в отсортированном по фамилиям виде."
SELECT name_enrollee
FROM enrollee JOIN program_enrollee USING(enrollee_id) JOIN program USING(program_id)
WHERE name_program = 'Мехатроника и робототехника'
ORDER BY name_enrollee;

--Задание:"Вывести студентов (различных студентов), имеющих максимальные результаты попыток. Информацию отсортировать в алфавитном порядке по фамилии студента."
SELECT name_student, result
FROM student JOIN attempt USING(student_id)
WHERE result = (SELECT MAX(result) from attempt)
ORDER BY 1

--13. Внешнее соединение LEFT и RIGHT OUTER JOIN
SELECT name_subject, COUNT(result) AS Количество, ROUND(AVG(result),2) AS Среднее
FROM attempt RIGHT JOIN subject USING(subject_id)
GROUP BY 1
ORDER BY 3 DESC

--14. Удаление записей из таблиц
DELETE FROM supply 
WHERE title IN (
        SELECT title 
        FROM book);

--15. Каскадное удаление записей связанных таблиц
DELETE FROM author
WHERE author_id IN (    
    SELECT author_id
    FROM book
    WHERE author.author_id = book.author_id
    GROUP BY author_id
    HAVING SUM(amount) < 20);
