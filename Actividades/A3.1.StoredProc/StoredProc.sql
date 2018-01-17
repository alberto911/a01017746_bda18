delimiter $$

create procedure show_products(in linea_producto varchar(50))
begin
    declare line varchar(50);
    set line = concat('%', linea_producto, '%');
    select * from products where productLine like line; 
end$$

create procedure customers_starting_with(in letra varchar(1))
begin
    select count(*) from customers where customerName like concat(letra, '%');
end$$

create procedure show_maxmin_products()
begin
    select max(buyPrice), min(buyPrice) from products;
end$$

delimiter ;