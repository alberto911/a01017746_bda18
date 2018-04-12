create trigger check_salary no cascade before update on employee referencing old as old_values new as new_values for each row mode db2sql when (new_values.salary / old_values.salary > 1.3) begin atomic signal sqlstate '75001' ('No se permite ese aumento'); end

create table ordenes(pid varchar(10) not null, quantity int not null, delivered char(1) not null default '0')
alter table ordenes add constraint fk_ordenes foreign key (pid) references product(pid)

create trigger check_inventory no cascade before insert on ordenes referencing new as new_values for each row mode db2sql when (new_values.quantity > (select quantity from inventory where pid = new_values.pid)) begin atomic signal sqlstate '75001' ('No hay suficiente inventario'); end

create trigger update_inventory after update on ordenes referencing old as old_values new as new_values for each row mode db2sql when (new_values.delivered = '1' and old_values.delivered = '0') begin atomic update inventory set quantity = quantity - old_values.quantity where pid = old_values.pid; end