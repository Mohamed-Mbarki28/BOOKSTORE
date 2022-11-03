create or replace procedure list_customer_orders
as
cursor c1 is select cust_order.order_id , first_name , last_name from customer , cust_order where customer.customer_id = cust_order.customer_id;
rec_c c1%rowtype;
begin
open c1;
loop
fetch c1 into rec_c;
exit when c1%notfound;
DBMS_OUTPUT.PUT_LINE('Order Id: '||rec_c.order_id|| ', First name: '||rec_c.first_name||', Last name: '||rec_c.last_name);
end loop;
EXCEPTION
WHEN OTHERS THEN
dbms_output.put_line(sqlcode);
dbms_output.put_line(sqlerrm);
end;
execute list_customer_orders;

/**********************************/
/* nb books bought by every gender*/
create or replace function printf_nb_book_per_gender(u_gender customer.gender%type)
return VARCHAR2
as
nb_book number(3);
n_result varchar(1000);
begin
DBMS_OUTPUT.PUT_LINE('********************NUMBER OF BOOKS BOUGHT PER GENDER***************** ');
select COUNT(book.title) into nb_book from book , cust_order , customer
where book.book_id = cust_order.book_id AND customer.customer_id = cust_order.customer_id and customer.gender = u_gender;
n_result := 'Number of books bought by '||u_gender||' = '||nb_book;
return n_result;
end printf_nb_book_per_gender; 

accept m_gender prompt 'enter gender';
begin
dbms_output.put_line(printf_nb_book_per_gender(&m_gender));  
end; 

/*****************************************************/
/*NUMBER OF BOOKS SOLD PER QUARTER*/
CREATE OR REPLACE procedure nb_book_sold_per_quarter
as
cursor c1 is select CUST_ORDER.order_date as od , count(book.book_id) as nb_book from CUST_ORDER , book , order_history where 
CUST_ORDER.book_id = book.book_id and order_history.status_id = 3 group by CUST_ORDER.order_date ;
rec_c c1%rowtype;
first_q NUMBER(2);
second_q NUMBER(2);
fourth_q NUMBER(2);
third_q NUMBER(2);
begin
first_q := 0;
second_q :=0;
third_q :=0;
fourth_q := 0;
open c1;
loop
fetch c1 into rec_c;
exit when c1%notfound;
IF rec_c.od BETWEEN to_date('01/01/2021','mm/dd/yyyy') AND to_date('03/31/2021','mm/dd/yyyy') THEN
first_q := first_q + 1;
elsif rec_c.od BETWEEN to_date('04/01/2021','mm/dd/yyyy') AND to_date('06/30/2021','mm/dd/yyyy') THEN
second_q := second_q +1;
elsif rec_c.od BETWEEN to_date('07/01/2021','mm/dd/yyyy') AND to_date('09/30/2021','mm/dd/yyyy') THEN
third_q := third_q +1;
elsif rec_c.od BETWEEN to_date('10/01/2021','mm/dd/yyyy') AND to_date('12/31/2021','mm/dd/yyyy') THEN
fourth_q := fourth_q +1;
END IF;
end loop;
close c1;
dbms_output.put_line('NUMBER OF BOOKS BOUGHT IN THE FIRST QUARTER');
dbms_output.put_line(first_q);
dbms_output.put_line('NUMBER OF BOOKS BOUGHT IN THE SECOND QUARTER');
dbms_output.put_line(second_q);
dbms_output.put_line('NUMBER OF BOOKS BOUGHT IN THE THIRD QUARTER');
dbms_output.put_line(third_q);
dbms_output.put_line('NUMBER OF BOOKS BOUGHT IN THE FOURTH QUARTER');
dbms_output.put_line(fourth_q);
EXCEPTION
WHEN OTHERS THEN
dbms_output.put_line(sqlcode);
dbms_output.put_line(sqlerrm);
end nb_book_sold_per_quarter;

execute nb_book_sold_per_quarter;
/*****************************************************/

/*REVENUES OF EVERY QUARTER - total sum of delivered books*/
CREATE OR REPLACE procedure revenue_per_quarter
as
cursor c1 is select CUST_ORDER.order_date as od , cust_order.total_price as total_sum from CUST_ORDER , order_history where 
cust_order.order_id = order_history.order_id and order_history.status_id = 3;
rec_c c1%rowtype;
first_q_revenue DECIMAL(10, 2);
second_q_revenue DECIMAL(10, 2);
fourth_q_revenue DECIMAL(10, 2);
third_q_revenue DECIMAL(10, 2);
begin
first_q_revenue := 0;
second_q_revenue :=0;
third_q_revenue :=0;
fourth_q_revenue := 0;
open c1;
loop
fetch c1 into rec_c;
exit when c1%notfound;
IF rec_c.od BETWEEN to_date('01/01/2021','dd/mm/yyyy') AND to_date('31/03/2021','dd/mm/yyyy') THEN
first_q_revenue := first_q_revenue + rec_c.total_sum;
elsif rec_c.od BETWEEN to_date('01/04/2021','dd/mm/yyyy') AND to_date('30/06/2021','dd/mm/yyyy') THEN
second_q_revenue := second_q_revenue + rec_c.total_sum;
elsif rec_c.od BETWEEN to_date('01/07/2021','dd/mm/yyyy') AND to_date('30/09/2021','dd/mm/yyyy') THEN
third_q_revenue := third_q_revenue + rec_c.total_sum;
elsif rec_c.od BETWEEN to_date('01/10/2021','dd/mm/yyyy') AND to_date('31/12/2021','dd/mm/yyyy') THEN
fourth_q_revenue := fourth_q_revenue + rec_c.total_sum;
END IF;
end loop;
close c1;
dbms_output.put_line('REVENUES OF THE FIRST QUARTER');
dbms_output.put_line(first_q_revenue||'$');
dbms_output.put_line('REVENUES OF THE SECOND QUARTER');
dbms_output.put_line(second_q_revenue||'$');
dbms_output.put_line('REVENUES OF THE THIRD QUARTER');
dbms_output.put_line(third_q_revenue||'$');
dbms_output.put_line('REVENUES OF THE FOURTH QUARTER');
dbms_output.put_line(fourth_q_revenue||'$');
EXCEPTION
WHEN OTHERS THEN
dbms_output.put_line(sqlcode);
dbms_output.put_line(sqlerrm);
end revenue_per_quarter;

execute revenue_per_quarter;

/****************************************/
/* nb of orders per status*/
create or replace procedure nb_oders_per_status
as
nb_orders NUMBER(3);
statusValue order_status.status_value%type;
cursor c1 is select order_status.status_value ,count(order_history.status_id) from order_history , order_status 
where order_history.status_id = order_status.status_id group by order_status.status_value;

begin
open c1;
loop
fetch c1 into statusValue , nb_orders;
exit when c1%notfound;
DBMS_OUTPUT.PUT_LINE('Number of book of status [ '||statusValue||' ] = '||nb_orders);
end loop;
close c1;
EXCEPTION
WHEN OTHERS THEN
dbms_output.put_line(sqlcode);
dbms_output.put_line(sqlerrm);
end nb_oders_per_status;

execute nb_oders_per_status;

/*****************************************/
/*NUMBER OF BOOKS BOUGHT BY COUNTRY*/
CREATE OR REPLACE PROCEDURE nb_books_buought_by_country
as
cursor c1 is select customer.country as country , count(cust_order.order_id) as nb_book from cust_order , customer
where customer.customer_id = cust_order.customer_id group by customer.country ORDER BY nb_book DESC;
rec_c c1%rowtype;
begin
DBMS_OUTPUT.PUT_LINE('*************NUMBER OF BOOKS BOUGHT BY EVERY COUNTRY*****************');
open c1;
loop
fetch c1 into rec_c;
exit when c1%notfound;
DBMS_OUTPUT.PUT_LINE('COUNTRY NAME : '||rec_c.country||' => NUMBER OF BOOKS BOUGHT : '||rec_c.nb_book);
end loop;
close c1;
EXCEPTION
WHEN OTHERS THEN
dbms_output.put_line(sqlcode);
dbms_output.put_line(sqlerrm);
end nb_books_buought_by_country;

execute nb_books_buought_by_country;

/******************************************/
/* NB of orders between two dates*/
/*date format dd/mm/yyyy*/
CREATE OR REPLACE FUNCTION nb_order_in_period(d_start DATE , d_end DATE)
return VARCHAR2
AS 
nb NUMBER(2);
result varchar(1200);
begin
select count(cust_order.order_id) into nb from cust_order where cust_order.order_date BETWEEN d_start and d_end;
result := 'NUMBER OF ORDER BETWEEN '||d_start||' AND '||d_end||' : '||nb;
return result;
end nb_order_in_period;

accept d_starts prompt 'date 1';
accept d_ends prompt 'date 2';
begin
DBMS_OUTPUT.PUT_LINE(nb_order_in_period(&d_starts,&d_ends));
end;

/********************************************/
/* TOTAL SPENDING FOR EVERY CUSTOMER*/
CREATE OR REPLACE FUNCTION total_spending_per_customer(c_id cust_order.customer_id%type)
return VARCHAR2
AS
result varchar2(1200);
begin
DBMS_OUTPUT.PUT_LINE('***********TOTAL SPENDING PER CUSTOMER**************');
for cur_var in (
select first_name , last_name , sum(total_price) as total_spending from cust_order , customer
where cust_order.customer_id = c_id and cust_order.customer_id = customer.customer_id group by first_name,last_name)
loop
result := cur_var.first_name||' '||cur_var.last_name||' has spent: '||cur_var.total_spending||'$';
end loop;
return result;
end total_spending_per_customer;

accept customer prompt 'Enter Customer ID';
begin
dbms_output.put_line(total_spending_per_customer(&customer));
end;

/******************************************/
/* Number of books bought by every customer*/
CREATE OR REPLACE PROCEDURE top_buyers
IS 
begin
DBMS_OUTPUT.PUT_LINE('LIST OF TOP BUYERS');
for cur_var in (select customer.first_name as fn , count(cust_order.order_id) as nb_order from customer , cust_order where customer.customer_id = cust_order.customer_id
group by customer.first_name ORDER BY count(cust_order.order_id) DESC)
loop
DBMS_OUTPUT.PUT_LINE(cur_var.fn || '      '||cur_var.nb_order);
end loop;
EXCEPTION
WHEN OTHERS THEN
dbms_output.put_line(sqlcode);
dbms_output.put_line(sqlerrm);
end;

execute top_buyers;

/************************************/
/* NB copies sold per book*/
CREATE OR REPLACE PROCEDURE nb_copy_sold_per_book
AS
begin
for c1 in (select book.title as title , count(cust_order.order_id) as nb from cust_order , book
where cust_order.book_id = book.book_id group by book.title)
loop
dbms_output.put_line('Book Title: '||c1.title||' =>      Number of Copies: '||c1.nb);
end loop;
EXCEPTION
WHEN OTHERS THEN
dbms_output.put_line(sqlcode);
dbms_output.put_line(sqlerrm);
end nb_copy_sold_per_book;

execute nb_copy_sold_per_book;

/****************************************/
/* Number of book per shipping method*/
CREATE OR REPLACE PROCEDURE nb_books_per_method
AS
cursor c1 is select shipping_method.method_name as shipping_name ,count(cust_order.order_id) as nb_order from cust_order , shipping_method 
where cust_order.method_id = shipping_method.method_id group by shipping_method.method_name;
rec_c c1%rowtype;
begin
open c1;
loop
fetch c1 into rec_c;
exit when c1%notfound;
DBMS_OUTPUT.PUT_LINE(rec_c.nb_order||' Order has been shipping with '||rec_c.shipping_name);
end loop;
close c1;
EXCEPTION
WHEN OTHERS THEN
dbms_output.put_line(sqlcode);
dbms_output.put_line(sqlerrm);
end nb_books_per_method;

execute nb_books_per_method;

/*****************************************/
/* best seller book*/
CREATE OR REPLACE PROCEDURE best_seller_book
IS
cursor c1 is select book.title, author.author_name , count(cust_order.book_id) as nb_of_books from cust_order , book,author
where cust_order.book_id = book.book_id AND author.author_id = book.author_id 
group by book.title,author.author_name ORDER BY nb_of_books DESC;
c_rec c1%rowtype;
begin
open c1;
loop
fetch c1 into c_rec;
exit when c1%rowcount=2;
dbms_output.put_line('*****************BEST SELLER BOOK*******************');
dbms_output.put_line('Title : '||c_rec.title);
dbms_output.put_line('Number of sales: '||c_rec.nb_of_books);
dbms_output.put_line('Author: '||c_rec.author_name);
end loop;
close c1;
EXCEPTION
WHEN OTHERS THEN
dbms_output.put_line(sqlcode);
dbms_output.put_line(sqlerrm);
end;

execute best_seller_book;

/*****************************************************/
/* Trigger to update order_history and book when inserting new order*/
create or replace trigger updatetables
after insert on cust_order
for each row
BEGIN
update book set quantity = quantity -1 where book_id =:new.book_id;
insert into order_history values (:new.order_id,:new.customer_id,1,:new.order_date);
end if;
end;

/*Check book quantity*/
create or replace trigger check_book_stock
before insert on cust_order
for each row
DECLARE
qt NUMBER(2);
BEGIN
select quantity into qt from book where book_id = :new.book_id;
if qt = 0 then
    raise_application_error(-20030,'ERROR : quantity = 0 , book out of stock');
end if;
end;

/*update tables when deleting the order*/
create or replace trigger update_deleted_order
after delete on cust_order
for each row
BEGIN
update book set quantity = quantity +1 where book_id =:old.book_id;
delete from order_history where order_id = :old.order_id;
end;

/**PACKAGE*/

create or replace PACKAGE bookstore_package
IS
procedure list_customer_orders;
function printf_nb_book_per_gender(u_gender customer.gender%type) return VARCHAR2;
procedure nb_book_sold_per_quarter;
procedure revenue_per_quarter;
procedure nb_oders_per_status;
PROCEDURE nb_books_buought_by_country;
FUNCTION nb_order_in_period(d_start DATE , d_end DATE) return VARCHAR2;
FUNCTION total_spending_per_customer(c_id cust_order.customer_id%type) return VARCHAR2;
PROCEDURE top_buyers;
PROCEDURE nb_copy_sold_per_book;
PROCEDURE nb_books_per_method;
PROCEDURE best_seller_book;
end bookstore_package;

/*PACKAGE BODY*/
create or replace PACKAGE BODY bookstore_package
IS
---- PROCEDURE 1 ------
    procedure list_customer_orders
        IS
        cursor c1 is select cust_order.order_id , first_name , last_name from customer , cust_order where customer.customer_id = cust_order.customer_id;
        rec_c c1%rowtype;
        begin
        open c1;
        loop
        fetch c1 into rec_c;
        exit when c1%notfound;
        DBMS_OUTPUT.PUT_LINE('Order Id: '||rec_c.order_id|| ', First name: '||rec_c.first_name||', Last name: '||rec_c.last_name);
        end loop;
        EXCEPTION
        WHEN OTHERS THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
    end;

---- PROCEDURE 2 ------
    function printf_nb_book_per_gender(u_gender customer.gender%type)
        return VARCHAR2
        as
        nb_book number(3);
        n_result varchar(1000);
        begin
        DBMS_OUTPUT.PUT_LINE('********************NUMBER OF BOOKS BOUGHT PER GENDER***************** ');
        select COUNT(book.title) into nb_book from book , cust_order , customer
        where book.book_id = cust_order.book_id AND customer.customer_id = cust_order.customer_id and customer.gender = u_gender;
        n_result := 'Number of books bought by '||u_gender||' = '||nb_book;
        return n_result;
    end printf_nb_book_per_gender;

---- PROCEDURE 3------
    procedure nb_book_sold_per_quarter
        as
        cursor c1 is select CUST_ORDER.order_date as od , count(book.book_id) as nb_book from CUST_ORDER , book , order_history where 
        CUST_ORDER.book_id = book.book_id and order_history.status_id = 3 group by CUST_ORDER.order_date ;
        rec_c c1%rowtype;
        first_q NUMBER(2);
        second_q NUMBER(2);
        fourth_q NUMBER(2);
        third_q NUMBER(2);
        begin
        first_q := 0;
        second_q :=0;
        third_q :=0;
        fourth_q := 0;
        open c1;
        loop
        fetch c1 into rec_c;
        exit when c1%notfound;
        IF rec_c.od BETWEEN to_date('01/01/2021','mm/dd/yyyy') AND to_date('03/31/2021','mm/dd/yyyy') THEN
        first_q := first_q + 1;
        elsif rec_c.od BETWEEN to_date('04/01/2021','mm/dd/yyyy') AND to_date('06/30/2021','mm/dd/yyyy') THEN
        second_q := second_q +1;
        elsif rec_c.od BETWEEN to_date('07/01/2021','mm/dd/yyyy') AND to_date('09/30/2021','mm/dd/yyyy') THEN
        third_q := third_q +1;
        elsif rec_c.od BETWEEN to_date('10/01/2021','mm/dd/yyyy') AND to_date('12/31/2021','mm/dd/yyyy') THEN
        fourth_q := fourth_q +1;
        END IF;
        end loop;
        close c1;
        dbms_output.put_line('NUMBER OF BOOKS BOUGHT IN THE FIRST QUARTER');
        dbms_output.put_line(first_q);
        dbms_output.put_line('NUMBER OF BOOKS BOUGHT IN THE SECOND QUARTER');
        dbms_output.put_line(second_q);
        dbms_output.put_line('NUMBER OF BOOKS BOUGHT IN THE THIRD QUARTER');
        dbms_output.put_line(third_q);
        dbms_output.put_line('NUMBER OF BOOKS BOUGHT IN THE FOURTH QUARTER');
        dbms_output.put_line(fourth_q);
        EXCEPTION
        WHEN OTHERS THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
    end nb_book_sold_per_quarter;

---- PROCEDURE 4 ------
    procedure revenue_per_quarter
        as
        cursor c1 is select CUST_ORDER.order_date as od , cust_order.total_price as total_sum from CUST_ORDER , order_history where 
        cust_order.order_id = order_history.order_id and order_history.status_id = 3;
        rec_c c1%rowtype;
        first_q_revenue DECIMAL(10, 2);
        second_q_revenue DECIMAL(10, 2);
        fourth_q_revenue DECIMAL(10, 2);
        third_q_revenue DECIMAL(10, 2);
        begin
        first_q_revenue := 0;
        second_q_revenue :=0;
        third_q_revenue :=0;
        fourth_q_revenue := 0;
        open c1;
        loop
        fetch c1 into rec_c;
        exit when c1%notfound;
        IF rec_c.od BETWEEN to_date('01/01/2021','dd/mm/yyyy') AND to_date('31/03/2021','dd/mm/yyyy') THEN
        first_q_revenue := first_q_revenue + rec_c.total_sum;
        elsif rec_c.od BETWEEN to_date('01/04/2021','dd/mm/yyyy') AND to_date('30/06/2021','dd/mm/yyyy') THEN
        second_q_revenue := second_q_revenue + rec_c.total_sum;
        elsif rec_c.od BETWEEN to_date('01/07/2021','dd/mm/yyyy') AND to_date('30/09/2021','dd/mm/yyyy') THEN
        third_q_revenue := third_q_revenue + rec_c.total_sum;
        elsif rec_c.od BETWEEN to_date('01/10/2021','dd/mm/yyyy') AND to_date('31/12/2021','dd/mm/yyyy') THEN
        fourth_q_revenue := fourth_q_revenue + rec_c.total_sum;
        END IF;
        end loop;
        close c1;
        dbms_output.put_line('REVENUES OF THE FIRST QUARTER');
        dbms_output.put_line(first_q_revenue||'$');
        dbms_output.put_line('REVENUES OF THE SECOND QUARTER');
        dbms_output.put_line(second_q_revenue||'$');
        dbms_output.put_line('REVENUES OF THE THIRD QUARTER');
        dbms_output.put_line(third_q_revenue||'$');
        dbms_output.put_line('REVENUES OF THE FOURTH QUARTER');
        dbms_output.put_line(fourth_q_revenue||'$');
        EXCEPTION
        WHEN OTHERS THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
    end revenue_per_quarter;


---- PROCEDURE 5 ------
    procedure nb_oders_per_status
        as
        nb_orders NUMBER(3);
        statusValue order_status.status_value%type;
        cursor c1 is select order_status.status_value ,count(order_history.status_id) from order_history , order_status 
        where order_history.status_id = order_status.status_id group by order_status.status_value;

        begin
        open c1;
        loop
        fetch c1 into statusValue , nb_orders;
        exit when c1%notfound;
        DBMS_OUTPUT.PUT_LINE('Number of book of status [ '||statusValue||' ] = '||nb_orders);
        end loop;
        close c1;
        EXCEPTION
        WHEN OTHERS THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
    end nb_oders_per_status;
---- PROCEDURE 6 ------
    PROCEDURE nb_books_buought_by_country
        as
        cursor c1 is select customer.country as country , count(cust_order.order_id) as nb_book from cust_order , customer
        where customer.customer_id = cust_order.customer_id group by customer.country ORDER BY nb_book DESC;
        rec_c c1%rowtype;
        begin
        DBMS_OUTPUT.PUT_LINE('*************NUMBER OF BOOKS BOUGHT BY EVERY COUNTRY*****************');
        open c1;
        loop
        fetch c1 into rec_c;
        exit when c1%notfound;
        DBMS_OUTPUT.PUT_LINE('COUNTRY NAME : '||rec_c.country||' => NUMBER OF BOOKS BOUGHT : '||rec_c.nb_book);
        end loop;
        close c1;
        EXCEPTION
        WHEN OTHERS THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
    end nb_books_buought_by_country;
---- PROCEDURE 7 ------
    FUNCTION nb_order_in_period(d_start DATE , d_end DATE)
        return VARCHAR2
        AS 
        nb NUMBER(2);
        result varchar(1200);
        begin
        select count(cust_order.order_id) into nb from cust_order where cust_order.order_date BETWEEN d_start and d_end;
        result := 'NUMBER OF ORDER BETWEEN '||d_start||' AND '||d_end||' : '||nb;
        return result;
    end nb_order_in_period;
---- PROCEDURE 8 ------
    FUNCTION total_spending_per_customer(c_id cust_order.customer_id%type)
        return VARCHAR2
        AS
        result varchar2(1200);
        begin
        DBMS_OUTPUT.PUT_LINE('***********TOTAL SPENDING PER CUSTOMER**************');
        for cur_var in (
        select first_name , last_name , sum(total_price) as total_spending from cust_order , customer
        where cust_order.customer_id = c_id and cust_order.customer_id = customer.customer_id group by first_name,last_name)
        loop
        result := cur_var.first_name||' '||cur_var.last_name||' has spent: '||cur_var.total_spending||'$';
        end loop;
        return result;
    end total_spending_per_customer;
---- PROCEDURE 9 ------
    PROCEDURE top_buyers
        IS 
        begin
        DBMS_OUTPUT.PUT_LINE('LIST OF TOP BUYERS');
        for cur_var in (select customer.first_name as fn , count(cust_order.order_id) as nb_order from customer , cust_order where customer.customer_id = cust_order.customer_id
        group by customer.first_name ORDER BY count(cust_order.order_id) DESC)
        loop
        DBMS_OUTPUT.PUT_LINE(cur_var.fn || '      '||cur_var.nb_order);
        end loop;
        EXCEPTION
        WHEN OTHERS THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
    end;
---- PROCEDURE 10 ------
	PROCEDURE nb_copy_sold_per_book
		AS
		begin
		for c1 in (select book.title as title , count(cust_order.order_id) as nb from cust_order , book
		where cust_order.book_id = book.book_id group by book.title)
		loop
		dbms_output.put_line('Book Title: '||c1.title||' =>      Number of Copies: '||c1.nb);
		end loop;
		EXCEPTION
		WHEN OTHERS THEN
		dbms_output.put_line(sqlcode);
		dbms_output.put_line(sqlerrm);
	end nb_copy_sold_per_book;
	
---- PROCEDURE 11 ------
	PROCEDURE nb_books_per_method
		AS
		cursor c1 is select shipping_method.method_name as shipping_name ,count(cust_order.order_id) as nb_order from cust_order , shipping_method 
		where cust_order.method_id = shipping_method.method_id group by shipping_method.method_name;
		rec_c c1%rowtype;
		begin
		open c1;
		loop
		fetch c1 into rec_c;
		exit when c1%notfound;
		DBMS_OUTPUT.PUT_LINE(rec_c.nb_order||' Order has been shipping with '||rec_c.shipping_name);
		end loop;
		close c1;
		EXCEPTION
		WHEN OTHERS THEN
		dbms_output.put_line(sqlcode);
		dbms_output.put_line(sqlerrm);
	end nb_books_per_method;
---- PROCEDURE 12 ------
    PROCEDURE best_seller_book
        IS
        cursor c1 is select book.title, author.author_name , count(cust_order.book_id) as nb_of_books from cust_order , book,author
        where cust_order.book_id = book.book_id AND author.author_id = book.author_id 
        group by book.title,author.author_name ORDER BY nb_of_books DESC;
        c_rec c1%rowtype;
        begin
        open c1;
        loop
        fetch c1 into c_rec;
        exit when c1%rowcount=2;
        dbms_output.put_line('*****************BEST SELLER BOOK*******************');
        dbms_output.put_line('Title : '||c_rec.title);
        dbms_output.put_line('Number of sales: '||c_rec.nb_of_books);
        dbms_output.put_line('Author: '||c_rec.author_name);
        end loop;
        close c1;
        EXCEPTION
        WHEN OTHERS THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
    end;
end bookstore_package;


