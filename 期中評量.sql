USE [Northwind]

--1 列出各產品的供應商名稱
select ProductID,ProductName,CompanyName from Suppliers s
 inner join Products p on p.SupplierID = s.SupplierID
--2 列出各產品的種類名稱
select ProductID,ProductName,CategoryName from Products p
inner join Categories c on c.CategoryID=p.CategoryID
--3 列出各訂單的顧客名字
select OrderID,CompanyName from Orders o
inner join Customers c on c.CustomerID=o.CustomerID
--4 列出各訂單的所負責的物流商名字以及員工名字
select OrderID,CompanyName,ShipName from Shippers s
inner join Orders o on o.ShipVia = s.ShipperID
--5 列出1998年的訂單
select OrderID,OrderDate from Orders where YEAR(OrderDate)=1998
--6 各產品，UnitsInStock < UnitsOnOrder 顯示'供不應求'，否則顯示'正常'
select ProductID,UnitsInStock,UnitsOnOrder,
iif(UnitsInStock < UnitsOnOrder,'供不應求','正常')as ans from Products 

--7 取得訂單日期最新的9筆訂單
select top 9 
OrderID,OrderDate from Orders
order by OrderDate desc
--8 產品單價最便宜的第4~8名
select ProductID,ProductName,UnitPrice from Products order by UnitPrice
offset 3 rows            --跳過3行
fetch next 5 rows only   --抓之後的五行
--9 列出每種類別中最高單價的商品
select top 1 CategoryName,UnitPrice from Products p 
inner join Categories c on c.CategoryID=p.CategoryID order by UnitPrice desc
--10 列出每個訂單的總金額
select o.OrderID,UnitPrice,Quantity,(UnitPrice*Quantity)as totalprice from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
--11 列出每個物流商送過的訂單筆數
select CompanyName,COUNT(OrderID)  from Orders o
inner join Shippers s on o.ShipVia = s.ShipperID group by CompanyName
--12 列出被下訂次數小於9次的產品
select ProductName,count(o.OrderID) from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.ProductID=od.ProductID 
group by p.ProductName
having count(o.OrderID)<9 
-- (13、14、15請一起寫)
--13 新增物流商(Shippers)：
-- 公司名稱: 青杉人才，電話: (02)66057606
-- 公司名稱: 青群科技，電話: (02)14055374
select *from Shippers
SET IDENTITY_INSERT Shippers ON;
INSERT INTO Shippers (ShipperID, CompanyName, Phone)
VALUES (4, '青杉人才', '(02)66057606'),
       (5, '青群科技', '(02)14055374');
SET IDENTITY_INSERT Shippers OFF;
--14 方才新增的兩筆資料，電話都改成(02)66057606，公司名稱結尾加'有限公司'
update Shippers
set CompanyName='青杉人才有限公司',Phone='(02)66057606'
where ShipperID=4
update Shippers
set CompanyName='青群科技有限公司',Phone='(02)66057606'
where ShipperID=5
--15 刪除剛才兩筆資料
DELETE FROM Shippers
WHERE ShipperID=4;
DELETE FROM Shippers
WHERE ShipperID=5;
