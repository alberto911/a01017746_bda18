-- Business time

create table courses(course_number int not null, title varchar(20) not null, credits smallint not null default 3, price decimal(6,2) not null, cstart date not null, cend date not null, period business_time(cstart, cend), primary key(course_number, business_time without overlaps))

select * from courses for business_time as of '2018-01-01'
select * from courses for business_time from '2017-01-01' to '2018-01-01'

update courses for portion of business_time from '2018-04-01' to '2018-05-01' set price = 200 where course_number = 4

delete from courses for portion of business_time from '2018-02-01' to '2018-03-01' where course_number = 3

-- System time:
    -- 3 campos timestamp (inicio, fin, fecha de transacción)
    -- Crear tabla de históricos
    -- Modificar tabla para soportar versiones
    
create table course_sys (course_number int primary key not null, title varchar(20) not null, credits smallint not null default 3, price decimal(6,2), sys_start timestamp(12) generated always as row begin not null, sys_end timestamp(12) generated always as row end not null, trans_start timestamp(12) generated always as transaction start id implicitly hidden, period system_time(sys_start, sys_end))
create table course_sys_history like course_sys
alter table course_sys add versioning use history table course_sys_history

insert into course_sys (course_number, title, credits, price) values (500, 'Intro to sql', 2, 200), (600, 'Intro to ruby', 2, 250), (650, 'Advanced ruby', 3, 400)
update course_sys set price = 250 where course_number = 650
