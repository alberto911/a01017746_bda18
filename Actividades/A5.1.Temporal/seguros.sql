create table autos (numero_serie varchar(20) primary key not null, numero_motor varchar(20) not null, modelo varchar(20) not null, marca varchar(20) not null, anio integer not null, precio_factura decimal(9,2) not null)

create table clientes (numero_cliente int primary key not null, nombre varchar(40) not null, fecha_nacimiento date not null, direccion varchar(50) not null, sys_start timestamp(12) generated always as row begin not null, sys_end timestamp(12) generated always as row end not null, trans_start timestamp(12) generated always as transaction start id implicitly hidden, period system_time(sys_start, sys_end))

create table polizas (numero_poliza int primary key not null, costo decimal(7,2) not null, cobertura int not null, auto varchar(20) not null, cliente int not null, fecha_inicio date not null, fecha_fin date not null, sys_start timestamp(12) generated always as row begin not null, sys_end timestamp(12) generated always as row end not null, trans_start timestamp(12) generated always as transaction start id implicitly hidden, period business_time(fecha_inicio, fecha_fin), period system_time(sys_start, sys_end))
alter table polizas add constraint fk_cliente foreign key (cliente) references clientes(numero_cliente)
alter table polizas add constraint fk_auto foreign key (auto) references autos(numero_serie)

create table clientes_history like clientes
create table polizas_history like polizas

alter table clientes add versioning use history table clientes_history 
alter table polizas add versioning use history table polizas_history

-- Se registran los cambios de direccion en clientes_history
insert into clientes (numero_cliente, nombre, fecha_nacimiento, direccion) values (1, 'John Doe', '1980-11-09', 'Reforma 125'), (2, 'Juan Perez', '1970-01-02', 'Palmas 754')
update clientes set direccion = 'Av Santa Fe 1' where numero_cliente = 1

insert into autos values ('A123', 'X987', 'Civic', 'Honda', 2015, 280000), ('B123', 'Y987', 'Accord', 'Honda', 2017, 390000)

insert into polizas (numero_poliza, costo, cobertura, auto, cliente, fecha_inicio, fecha_fin) values (100, 12000, 1, 'A123', 1, '2017-01-01', '2018-01-01'), (200, 24000, 3, 'B123', 2, '2017-07-01', '2018-07-01') 

create trigger checar_cobertura no cascade before update on polizas referencing old as old_values new as new_values for each row mode db2sql when (new_values.cobertura < old_values.cobertura) begin atomic signal sqlstate '75001' ('No se puede reducir cobertura'); end