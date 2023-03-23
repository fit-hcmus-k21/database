-- 01. Cho biết mã sản phẩm, tên, giá tiền, đơn vị tính của những sản phẩm có giá trên 100 (nghìn) đồng --
select Mã sản phẩm, Tên, Giá tiền, Đơn vị tính
from Sản phẩm
where Giá tiền > 100


-- 02. Cho biết những sản phẩm có loại là "Đồ dùng" --
select *
from Sản phẩm
where Mã loại In (select Mã loại from Loại sản phẩm where Tên loại = 'Đồ dùng')


-- 03. Cho biết tên và giá tiền của các sản phẩm "Bàn chải đánh răng" -- 
select Tên, Giá tiền
from Sản phẩm
where Tên like '%Bàn chải đánh răng%'


-- 04. Cho biết tên sản phẩm và tên loại sản phẩm  --
select SP.Tên, LSP.Tên loại
from Sản phẩm SP, Loại sản phẩm LSP
where SP.Mã loại = LSP.Mã loại


-- 05. Cho biết tên sản phẩm và tên loại sản phẩm của những sản phẩm có số lượng tồn > 50 --
select SP.Tên, LSP.Tên loại
from Sản phẩm SP, Loại sản phẩm LSP
where SP.Số lượng tồn > 50 and SP.Mã loại = LSP.Mã loại


-- 06. Cho biết những sản phẩm có đơn vị tính là "túi". --
select *
from Sản phẩm
where Đơn vị tính = 'túi'


-- 07. Cho biết tên loại sản phẩm của mặt hàng "Bột giặc Omo" --
select LSP.Tên loại
from Sản phẩm SP, Loại sản phẩm LSP
where SP.Tên = 'Bột giặc Omo' and SP.Mã loại = LSP.Mã loại


-- 08. Cho biết tên của sản phẩm có giá thấp nhất --
select Tên
from Sản phẩm
where Giá tiền = (select min(Giá tiền) from Sản phẩm)


-- 09. Cho biết tên của sản phẩm có giá cao nhất --
select Tên
from Sản phẩm
where Giá tiền = (select max(Giá tiền) from Sản phẩm)

