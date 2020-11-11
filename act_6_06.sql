use bank;


/* 6.06 Activity 1
In this activity, you will be still using data from files_for_activities/mysql_dump.sql. 
Refer to the case study files to find more information. Please answer the following questions.
Update the query just created on the class to include another condition to query for duration column from loan table. 
Pick up any value for duration (from the given values in the table loan) to test your code.
*/

drop procedure if exists average_loss_status_regiom_proc;
delimiter $$
create procedure average_loss_status_regiom_proc (in param1 varchar(10), in param2 varchar(100), out param3 varchar(20))
begin
  declare avg_loss_region float default 0.0;
  declare zone varchar(20) default "";
  select round((sum(amount) - sum(payments))/count(*), 2) into avg_loss_region
  from (
    select a.account_id, d.A2 as district, d.A3 as region, l.amount, l.payments, l.status
    from bank.account a
    join bank.district d
    on a.district_id = d.A1
    join bank.loan l
    on l.account_id = a.account_id
    where l.status COLLATE utf8mb4_general_ci = param1
    and d.A3 COLLATE utf8mb4_general_ci = param2
  ) sub1;
-- select avg_loss_region;
  if avg_loss_region > 700000 then
    set zone = 'Red Zone';
  elseif avg_loss_region <= 70000 and avg_loss_region > 40000 then
    set zone = 'Orange Zone';
  else
    set zone = 'Green Zone';
  end if;
  select zone into param3;
  select param1, param2, avg_loss_region, zone;
end $$
delimiter ;

call average_loss_status_regiom_proc("A", "Prague", @x);
select @x;

drop procedure if exists average_loss_status_regiom_proc_dur;
delimiter $$
create procedure average_loss_status_regiom_proc_dur (in param1 varchar(10), in param2 varchar(100), in param4 int, out param3 varchar(20))
begin
  declare avg_loss_region float default 0.0;
  declare zone varchar(20) default "";
  select round((sum(amount) - sum(payments))/count(*), 2) into avg_loss_region
  from (
    select a.account_id, d.A2 as district, d.A3 as region, l.amount, l.payments, l.status
    from bank.account a
    join bank.district d
    on a.district_id = d.A1
    join bank.loan l
    on l.account_id = a.account_id
    where l.status COLLATE utf8mb4_general_ci = param1
    and d.A3 COLLATE utf8mb4_general_ci = param2
    and l.duration >= param4
  ) sub1;
-- select avg_loss_region;
  if avg_loss_region > 700000 then
    set zone = 'Red Zone';
  elseif avg_loss_region <= 70000 and avg_loss_region > 40000 then
    set zone = 'Orange Zone';
  else
    set zone = 'Green Zone';
  end if;
  select zone into param3;
  select param1 as loan_status, param2 as district, param4 as duration, avg_loss_region, zone;
end $$
delimiter ;

call average_loss_status_regiom_proc_dur("A", "Prague", 24, @x);
select @x;
call average_loss_status_regiom_proc_dur("A", "Prague", 36, @x);

/* 6.06 Activity 2
In this activity we will use the trans table in the bank database.
Use the case statements to classify the balances as positive and negative.
Use a stored procedure to execute the query.
*/
select trans_id as transaction, amount, balance from trans 
where balance <0;

select * from trans;
drop procedure if exists  balance_status;
delimiter $$
create procedure balance_status (in param1 int)
begin
	declare transaction_stat varchar(20) default "";
    select account_id, trans_id as transaction, amount, balance, 
	case 
		when balance < 0 then "negative" 
		when balance >=0 then "positive" 
	end as transaction_stat
    from trans
    where trans.account_id = param1;
end $$

delimiter ;

call balance_status(2378);

/* 
6.06 Activity 3
Answer the following questions:
Update the query just created on the class to use continue to exit instead of using declare continue handler.
Did you get there a difference in the output? If yes, what is the difference between the results?
*/


    