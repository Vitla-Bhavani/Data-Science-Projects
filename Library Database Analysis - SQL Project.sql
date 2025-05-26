create database librarydb;
use librarydb;
create table publisher(Publisher_Name varchar(255) primary key,
                       Publisher_Address varchar(255),
                       Publisher_Phone varchar(255));

create table Borrower(Borrower_CardNo tinyint primary key,
                      Borrower_Name	varchar(255),
                      Borrower_Address varchar(255),
                      Borrower_Phone varchar(255));

create table Library_Branch(library_branch_id tinyint primary key auto_increment,
							library_Branch_Name	varchar(255),
							library_Branch_Address varchar(255));
                            
create table books(Book_ID	tinyint primary key auto_increment,
                   book_Title varchar(255),
                   Book_Publisher_Name varchar(255),
                   foreign key(Book_Publisher_Name) references publisher(Publisher_Name)
                   on update cascade on delete cascade);

create table Book_loans(Book_Loans_ID smallint primary key auto_increment,
                        book_loans_Book_ID	tinyint,
                        book_loans_Branch_ID tinyint,
                        book_loans_CardNo tinyint,
                        book_loans_Date_Out	varchar(255),
                        book_loans_Due_Date varchar(255),
                        foreign key(book_loans_Book_ID) references books(Book_ID) on update cascade on delete cascade,
                        foreign key(book_loans_Branch_ID) references Library_Branch(library_branch_id) on update cascade on delete cascade,
                        foreign key(book_loans_CardNo) references Borrower(Borrower_CardNo) on update cascade on delete cascade);

create table Book_copies(book_copies_id tinyint primary key auto_increment,
                         book_copies_BookID	tinyint,
                         book_copies_BranchID tinyint,
                         book_copies_No_Of_Copies tinyint,
						 foreign key(book_copies_BookID) references books(Book_ID) on update cascade on delete cascade,
                         foreign key(book_copies_BranchID) references Library_Branch(library_branch_id) on update cascade on delete cascade);
                         
create table authors( book_author_id tinyint primary key auto_increment,
					  book_author_BookID tinyint,
                      book_author_Author_Name varchar(255),
                      foreign key(book_author_BookID) references books(Book_ID) on update cascade on delete cascade);

select * from publisher;
select * from borrower;
select * from library_branch;
select * from books;
select * from book_loans;
select * from book_copies;
select * from authors;

# Task Questions

-- 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select book_title, book_copies_No_Of_Copies, library_Branch_Name from books
       inner join book_copies on books.Book_ID = book_copies.book_copies_bookid
	   inner join library_branch on book_copies.book_copies_branchid = library_branch.library_branch_id
       where library_branch_name = "Sharpstown" and book_title = "The Lost Tribe";

-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select book_title, book_copies_No_Of_Copies, library_Branch_Name from books
       inner join book_copies on books.Book_ID = book_copies.book_copies_bookid
	   inner join library_branch on book_copies.book_copies_branchid = library_branch.library_branch_id
       where book_title = "The Lost Tribe";
       
-- 3. Retrieve the names of all borrowers who do not have any books checked out. 
select borrower_name from borrower
        left join book_loans on borrower.Borrower_cardNo = book_loans.book_loans_CardNo
        where book_loans_id is null;

/* 4. For each book that is loaned out from the "Sharpstown" branch and whose
DueDate is 2/3/18, retrieve the book title, the borrower's name, and the
borrower's address.*/
select library_branch_name,book_loans_due_date,book_title,borrower_name,Borrower_address from library_branch
         left join book_loans on library_branch.library_branch_id = book_loans.book_loans_branch_id
         left join books on book_loans.book_loans_book_id = books.book_id
         left join borrower on book_loans.book_loans_cardno = borrower.borrower_cardno
         where library_branch_name = "Sharpstown" and book_loans_due_date = "2/3/18";

/* 5. For each library branch, retrieve the branch name and the total number of books 
loaned out from that branch.*/
select library_branch_name,count(*) as Total_no_of_books from library_branch
       left join book_loans on library_branch.library_branch_id = book_loans.book_loans_branch_id
       group by library_branch_name;

/* 6. Retrieve the names, addresses, and number of books checked out for all
borrowers who have more than five books checked out.*/
select borrower_name,borrower_address,count(*) as No_of_books_checked_out from borrower
       left join book_loans on borrower.borrower_cardno = book_loans.book_loans_cardno
	   group by borrower_name, borrower_address
       having no_of_books_checked_out > 5
       order by no_of_books_checked_out;

/* 7. For each book authored by "Stephen King", retrieve the title and the number of
copies owned by the library branch whose name is "Central".*/
select book_author_author_name,book_title,book_copies_no_of_copies,library_branch_name from authors
      left join books on authors.book_author_bookid = books.book_id
      left join book_copies on books.book_id = book_copies.book_copies_bookid
      left join library_branch on book_copies.book_copies_branchid = library_branch.library_branch_id
      where book_author_author_name = "Stephen King" and library_branch_name = "Central";
      