use QLBHST
go

-- Q22: Cho biết số lượng khách hàng của từng phái
select GioiTinh, count(MaKH) as SoLuong
from KhachHang
group by GioiTinh

-- Q23: Cho biết số lượng khách hàng ở từng tỉnh thành
select DiaChi, count(MaKH) as SoLuong
from KhachHang
group by DiaChi

-- Q24: Cho biết tỉnh thành có nhiều khách hàng nhất
select DiaChi
from KhachHang
group by DiaChi
having count(DiaChi) >= ALL (select count(DiaChi) from KhachHang group by DiaChi)

-- Q25: Cho tên, địa chỉ, điện thoại biết khách hàng cao tuổi nhất
select HoTen, DiaChi, DienThoai
from KhachHang
where NamSinh <= ALL (select NamSinh from KhachHang)

-- Q26: Cho biết số lượng khách hàng sinh ra trong từng năm
select year(NamSinh) as NamSinh, count(NamSinh) as SoLuong
from KhachHang
group by NamSinh

-- Q27: Cho biết mã khách hàng của những khách hàng chưa tùng mua hàng
select MaKH
from KhachHang
except (select MaKH from HoaDon)

-- Q28: Cho biết mã khách hàng và tên của những khách hàng chưa từng mua hàng
select MaKH, HoTen
from KhachHang
where MaKH in (select MaKH
from KhachHang
except (select MaKH from HoaDon))

-- Q29: Cho biết mã khách hàng và số lần mua hàng của khách hàng đó
select MaKH, count(MaKH) as SLMH
from HoaDon
group by MaKH

-- Q30: Cho biết mã khách hàng, tên và số lần mua hàng của mỗi khách hàng
select KH.HoTen, KHMN.MaKH, KHMN.SLMH
from KhachHang KH, (select MaKH, count(MaKH) as SLMH
					from HoaDon
					group by MaKH) as KHMN
where KH.MaKH = KHMN.MaKH



-- Q31: Cho biết mã khách hàng của khách hàng đã mua hàng nhiều lần nhất
select MaKH
from HoaDon
group by MaKH 
having count(MaKH) >= ALL (select count(MaKH)
from HoaDon
group by MaKH )

-- Q32: Cho biết mã khách hàng và tên của những khách hàng đã mua nhiều lần nhất
select HoTen, MaKH
from KhachHang
where MaKH in (select MaKH
from HoaDon
group by MaKH 
having count(MaKH) >= ALL (select count(MaKH)
from HoaDon
group by MaKH ))