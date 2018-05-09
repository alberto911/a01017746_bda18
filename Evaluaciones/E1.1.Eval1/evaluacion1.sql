-- Ejercicio 2
create table LOG_FILM (id int not null auto_increment, tipo varchar(10) not null default 'Update', film_id smallint(5) unsigned not null, last_value varchar(255), new_value varchar(255), last_update timestamp not null default CURRENT_TIMESTAMP, primary key(id));
alter table LOG_FILM add constraint fk_film_id foreign key (film_id) references film(film_id);

-- Ejercicio 3
delimiter $$
create procedure insert_log_film(in f_id smallint(5) unsigned, in last_v varchar(255), in new_v varchar(255))
begin
    insert into LOG_FILM (film_id, last_value, new_value) values (f_id, last_v, new_v);
end$$
delimiter ;

-- Ejercicio 4
create trigger log_film_trigger after update ON film
for each row
call insert_log_film(OLD.film_id, OLD.original_language_id, NEW.original_language_id);


-- Ejercicio 5
delimiter //
create procedure set_original_language()
begin
    declare id smallint(5) unsigned;
    declare lang tinyint(3) unsigned;
    declare done int default FALSE;
    declare cursor1 cursor for select film_id from film_category where category_id = (select category_id from category where name = 'Documentary');
    declare cursor2 cursor for select film_id from film_category where category_id = (select category_id from category where name = 'Foreign');
    declare cursor3 cursor for select film_id from film_actor where actor_id = (select actor_id from actor where first_name = 'SISSY' and last_name = 'SOBIESKI');
    declare cursor4 cursor for select film_id from film_actor where actor_id = (select actor_id from actor where first_name = 'ED' and last_name = 'CHASE');
    declare cursor5 cursor for select film_id from film_actor where actor_id = (select actor_id from actor where first_name = 'AUDREY' and last_name = 'OLIVIER');
    declare cursor6 cursor for select film_id from film where original_language_id is NULL; 
    declare continue handler for not found set done = true;
        
    open cursor1;
    set lang = (select language_id from language where name = 'Italian');
    c1_loop: loop
        fetch cursor1 into id;
        if done then
            leave c1_loop;
        end if;
        update film set original_language_id = lang where film_id = id;
    end loop;
    close cursor1;
    
    open cursor2;
    set done = false;
    set lang = (select language_id from language where name = 'Japanese');
    c2_loop: loop
        fetch cursor2 into id;
        if done then
            leave c2_loop;
        end if;
        update film set original_language_id = lang where film_id = id;
    end loop;
    close cursor2;
    
    open cursor3;
    set done = false;
    set lang = (select language_id from language where name = 'German');
    c3_loop: loop
        fetch cursor3 into id;
        if done then
            leave c3_loop;
        end if;
        update film set original_language_id = lang where film_id = id;
    end loop;
    close cursor3;
    
    open cursor4;
    set done = false;
    set lang = (select language_id from language where name = 'Mandarin');
    c4_loop: loop
        fetch cursor4 into id;
        if done then
            leave c4_loop;
        end if;
        update film set original_language_id = lang where film_id = id;
    end loop;
    close cursor4;
    
    open cursor5;
    set done = false;
    set lang = (select language_id from language where name = 'French');
    c5_loop: loop
        fetch cursor5 into id;
        if done then
            leave c5_loop;
        end if;
        update film set original_language_id = lang where film_id = id;
    end loop;
    close cursor5;
    
    open cursor6;
    set done = false;
    set lang = (select language_id from language where name = 'English');
    c6_loop: loop
        fetch cursor6 into id;
        if done then
            leave c6_loop;
        end if;
        update film set original_language_id = lang where film_id = id;
    end loop;
    close cursor6;
end //
delimiter ;


-- Ejercicio 6
-- Parte 1
create table gomitas (id int not null, sabor varchar(30) not null, precio decimal(5, 2) not null, fecha_inicio date not null, fecha_fin date not null, period business_time(fecha_inicio, fecha_fin), primary key(id, business_time without overlaps))

-- Parte 3
insert into gomitas (id, sabor, precio, fecha_inicio, fecha_fin) values (1, 'Fresa', 15, '2018-01-01', '2019-01-01'), (2, 'Frambuesa', 25, '2018-01-01', '2019-01-01'), (3, 'Limon', 10, '2018-01-01', '2019-01-01'), (4, 'Anis', 45, '2018-01-01', '2019-01-01'), (5, 'Pina', 30, '2018-01-01', '2019-01-01'), (6, 'Naranja', 65, '2018-01-01', '2019-01-01'), (7, 'Rompope', 100, '2018-01-01', '2019-01-01'), (8, 'Vainilla', 85, '2018-01-01', '2019-01-01'), (9, 'Chocolate', 90, '2018-01-01', '2019-01-01'), (10, 'Cajeta', 95, '2018-01-01', '2019-01-01'), (11, 'Zarzamora', 5, '2018-01-01', '2019-01-01'), (12, 'Grosella', 115, '2018-01-01', '2019-01-01')

-- Parte 4
update gomitas for portion of business_time from '2018-02-01' to '2018-02-15' set precio = precio * 1.45
update gomitas for portion of business_time from '2018-02-15' to '2019-01-01' set precio = precio * 1.1
update gomitas for portion of business_time from '2018-04-25' to '2018-05-05' set precio = precio * 1.45
update gomitas for portion of business_time from '2018-05-05' to '2019-01-01' set precio = precio * 1.1
update gomitas for portion of business_time from '2018-10-25' to '2018-11-05' set precio = precio * 1.45
update gomitas for portion of business_time from '2018-11-05' to '2019-01-01' set precio = precio * 1.1

-- Parte 5
select id, sum((days(fecha_fin) - days(fecha_inicio)) * precio) / 365 as precio_promedio from gomitas group by id -- Promedio
select id, max(precio) from gomitas group by id -- Maximo
select id, min(precio) from gomitas group by id -- Minimo