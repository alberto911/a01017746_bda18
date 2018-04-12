delimiter //
create procedure rename_films()
begin
    declare newtitle varchar(281);
    declare id int;
    declare done int default FALSE;
    declare cursor1 cursor for select film.film_id, concat(category.name, "_", film.title) from film join film_category on film.film_id = film_category.film_id join category on film_category.category_id = category.category_id;
    declare continue handler for not found set done = true;
        
    open cursor1;
    read_loop: loop
        fetch cursor1 into id, newtitle;
        if done then
            leave read_loop;
        end if;
        update film set title = newtitle where film_id = id;
    end loop;
    
    close cursor1;
end //