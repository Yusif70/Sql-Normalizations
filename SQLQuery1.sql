-- task 1
create table Groups(
	Id int primary key identity,
	Name nvarchar(10) not null
)
create table Students(
	Id int primary key identity,
	FullName nvarchar(50) not null,
	GroupId int foreign key references Groups(Id)
)
create table Exams(
	Id int primary key identity,
	SubjectName nvarchar(20) not null,
	StartDate datetime not null,
	EndDate datetime not null,
	constraint check_end_date check (EndDate > StartDate)
)
create table StudentExams(
	StudentId int foreign key references Students(Id),
	ExamId int foreign key references Exams(Id),
	ResultPoint decimal
)
insert into Groups
values('backend'),('frontend')
insert into Students
values('Yusif Pirquliyev',80,1),('Azima Qadirli',90,1),('Nijat Soltanov',90,2)
insert into Exams
values('frontend react','7-29-2024 10:00:00','7-29-2024 12:00:00'),('backend c#','8-1-2024 10:00:00','8-1-2024 12:30:00')
insert into StudentExams
values(2,2,90),(3,1,100),(3,2,90)
--- Butun student datalari gorsenir ve her bir student datasinin yaninda oxudugu qrupun No deyeri gorsenir
select s.FullName, g.Name from Students s
join Groups g
on s.GroupId = g.Id
--- Butun Student datalari gorsenir ve her bir studentin yaninda o studentin examlerinin sayi gorsenir
select s.Id, s.FullName, AVG(se.ResultPoint) [Point], COUNT(se.ExamId) [Number of exams] from Students s
join StudentExams se
on s.Id = se.StudentId
group by s.Id, s.FullName
--- Hec bir exam-i olmayan subject datalarini select eden query
select * from Students s
left join StudentExams se
on s.Id = se.StudentId
where se.StudentId is null
--- Dunen bas vermis butun examleri select eden query ve her bir exam datasinin yaninda studentlerinin sayi ve subjectinin adi gorsensin
select e.Id,SubjectName, s.FullName [Student] from Exams e
join StudentExams se
on e.Id = se.ExamId
join Students s
on se.StudentId = s.Id
where DAY(GETDATE()-StartDate) = 1
--- Butun studentExam datalari select eden query ve her bir studentExam datasinin yaninda onun studentinin fullname deyeri ve o studentin qrup nomresi gorsenir
select se.StudentId,s.FullName [Student],se.ResultPoint, g.Name [Group name] from StudentExams se
join Students s
on se.StudentId = s.Id
join Groups g
on s.GroupId = g.Id
--- Butun studentleri select eden query ve her bir studentin yaninda onun butun imtahanlarinin ortalama result deyeri gorsenir
select s.FullName,AVG(se.ResultPoint) [Average result point] from Students s
join StudentExams se
on s.Id = se.StudentId
group by s.FullName
-- task 2
create table Departments(
	Id int primary key identity,
	Name nvarchar(30) not null,
)
create table Employees(
	Id int primary key identity,
	FirstName nvarchar(20) not null,
	LastName nvarchar(30) not null,
	DepartmentId int foreign key references Departments(Id)
)

insert into Departments
values('Information technologies'),('English language')
insert into Employees
values('Yusif','Pirquliyev',1),('Azima','Qadirli',2),('Nijat','Soltanov',1)
---Retrieve the list of all employees along with their department names.
select FirstName, LastName, d.Name [Department name] from Employees e
join Departments d
on e.DepartmentId = d.Id
---Retrieve the list of all departments along with the count of employees in each department.
select DepartmentId, Name, COUNT(e.Id) [number of employees] from Departments d
join Employees e
on d.Id = e.DepartmentId
group by DepartmentId, Name