USE [Northwind]

--1 �C�X�U���~�������ӦW��
select ProductID,ProductName,CompanyName from Suppliers s
 inner join Products p on p.SupplierID = s.SupplierID
--2 �C�X�U���~�������W��
select ProductID,ProductName,CategoryName from Products p
inner join Categories c on c.CategoryID=p.CategoryID
--3 �C�X�U�q�檺�U�ȦW�r
select OrderID,CompanyName from Orders o
inner join Customers c on c.CustomerID=o.CustomerID
--4 �C�X�U�q�檺�ҭt�d�����y�ӦW�r�H�έ��u�W�r
select OrderID,CompanyName,ShipName from Shippers s
inner join Orders o on o.ShipVia = s.ShipperID
--5 �C�X1998�~���q��
select OrderID,OrderDate from Orders where YEAR(OrderDate)=1998
--6 �U���~�AUnitsInStock < UnitsOnOrder ���'�Ѥ����D'�A�_�h���'���`'
select ProductID,UnitsInStock,UnitsOnOrder,
iif(UnitsInStock < UnitsOnOrder,'�Ѥ����D','���`')as ans from Products 

--7 ���o�q�����̷s��9���q��
select top 9 
OrderID,OrderDate from Orders
order by OrderDate desc
--8 ���~����̫K�y����4~8�W
select ProductID,ProductName,UnitPrice from Products order by UnitPrice
offset 3 rows            --���L3��
fetch next 5 rows only   --�줧�᪺����
--9 �C�X�C�����O���̰�������ӫ~
select top 1 CategoryName,UnitPrice from Products p 
inner join Categories c on c.CategoryID=p.CategoryID order by UnitPrice desc
--10 �C�X�C�ӭq�檺�`���B
select o.OrderID,UnitPrice,Quantity,(UnitPrice*Quantity)as totalprice from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
--11 �C�X�C�Ӫ��y�Ӱe�L���q�浧��
select CompanyName,COUNT(OrderID)  from Orders o
inner join Shippers s on o.ShipVia = s.ShipperID group by CompanyName
--12 �C�X�Q�U�q���Ƥp��9�������~
select ProductName,count(o.OrderID) from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.ProductID=od.ProductID 
group by p.ProductName
having count(o.OrderID)<9 
-- (13�B14�B15�Ф@�_�g)
--13 �s�W���y��(Shippers)�G
-- ���q�W��: �C���H�~�A�q��: (02)66057606
-- ���q�W��: �C�s��ޡA�q��: (02)14055374
select *from Shippers
SET IDENTITY_INSERT Shippers ON;
INSERT INTO Shippers (ShipperID, CompanyName, Phone)
VALUES (4, '�C���H�~', '(02)66057606'),
       (5, '�C�s���', '(02)14055374');
SET IDENTITY_INSERT Shippers OFF;
--14 ��~�s�W���ⵧ��ơA�q�ܳ��令(02)66057606�A���q�W�ٵ����['�������q'
update Shippers
set CompanyName='�C���H�~�������q',Phone='(02)66057606'
where ShipperID=4
update Shippers
set CompanyName='�C�s��ަ������q',Phone='(02)66057606'
where ShipperID=5
--15 �R����~�ⵧ���
DELETE FROM Shippers
WHERE ShipperID=4;
DELETE FROM Shippers
WHERE ShipperID=5;
