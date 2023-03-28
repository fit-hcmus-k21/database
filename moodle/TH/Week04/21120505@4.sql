use QLGV;
go

-- viết các câu truy vấn sử dụng hàm kết hợp và gom nhóm

-- Q27: Cho biết SLGV và tổng lương của họ --
select count(*) as SLGV, SUM(LUONG) as TongLuong
from GIAOVIEN

-- Q28: Cho biết SLGV và lương TB của từng bộ môn --
select count(*) as SLGV, AVG(LUONG) as LuongTB
from GIAOVIEN
group by MABM

-- Q29: Cho biết tên chủ đề và số lượng đề tài thuộc về chủ đề đó --
select CD.TENCD, count(*) as SLDT
from CHUDE CD join DETAI DT on CD.MACD = DT.MACD
group by CD.MACD, CD.TENCD

-- Q30: Cho biết tên giáo viên và số lượng đề tài giáo viên đó tham gia --
select GV.HOTEN, count (DISTINCT TGDT.MADT) as SLDTTG
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
group by GV.MAGV, GV.HOTEN

-- Q31: Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó làm chủ nhiệm --
select GV.HOTEN, count(*) as SLDTCN
from GIAOVIEN GV join DETAI DT on GV.MAGV = DT.GVCNDT
group by GV.MAGV, GV.HOTEN

-- Q32: Với mỗi giáo viên, cho tên giáo viên và số người thân của giáo viên đó --
select GV.HOTEN, count(NT.TEN) as SO_NGUOI_THAN
from GIAOVIEN GV left join NGUOITHAN NT on GV.MAGV = NT.MAGV
group by GV.MAGV, GV.HOTEN

-- Q33: Cho biết tên những giáo viên đã tham gia từ 3 đề tài trở lên --
select GV.HOTEN 
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
group by GV.MAGV, GV.HOTEN
having count(DISTINCT TGDT.MADT) >= 3


-- Q34: Cho biết số lượng giáo viên đã tham gia vào đề tài Ứng dụng hóa học xanh --
select count(DISTINCT TGDT.MAGV) as SLGV_THAMGIA_UDHHX
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where DT.TENDT = N'Ứng dụng hóa học xanh'
group by DT.MADT
