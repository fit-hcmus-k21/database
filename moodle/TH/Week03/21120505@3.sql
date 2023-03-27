-- VIẾT CÁC CÂU TRUY VẤN ĐƠN GIẢN

-- Q1: Cho biết họ tên và mức lương của các giáo viên nữ
select HOTEN, LUONG
from GIAOVIEN
where PHAI = N'Nữ'

-- Q2: Cho biết họ tên của các giáo viên và lương của họ sau khi tăng lương 10%
select HOTEN, LUONG * 1.1 as LUONG_SAU_TANG
from GIAOVIEN

-- Q3: Cho biết mã của các giáo viên có họ tên bắt đầu bằng "Nguyễn" và lương trên $2000 hoặc giáo viên là trưởng bộ môn nhận chức sau 1995
select MAGV
from GIAOVIEN
where HOTEN like N'Nguyễn%' and LUONG > 2000
UNION
select BM.TRUONGBM as MAGV
from GIAOVIEN GV join BOMON BM on BM.TRUONGBM = GV.MAGV
where year(BM.NGAYNHANCHUC) > 1995

-- Q4: Cho biết tên những giáo viên khoa công nghệ thông tin
select GV.HOTEN as HOTEN_GV_CNTT, GV.MAGV as MAGV
from GIAOVIEN GV join BOMON BM on (GV.MABM = BM.MABM ) join KHOA K on (BM.MAKHOA = K.MAKHOA)
where K.TENKHOA = N'Công nghệ thông tin'

-- Q5: Cho biết thông tin của bộ môn cùng thông tin giảng viên làm trưởng bộ môn đó
select BM.MABM, BM.TENBM, GV.MAGV as MA_TRUONGBM, GV.HOTEN as HOTEN_TRUONGBM 
from GIAOVIEN GV join BOMON BM on BM.TRUONGBM = GV.MAGV

-- Q6: Với mỗi giáo viên, hãy cho biết thông tin của bộ môn mà họ đang làm việc
select GV.MAGV, GV.HOTEN, BM.*
from GIAOVIEN GV, BOMON BM
where GV.MABM = BM.MABM

-- Q7: Cho biết tên đề tài và giáo viên chủ nhiệm đề tài
select TENDT, GVCNDT
from DETAI

-- Q8: Với mỗi khoa cho biết thông tin trưởng khoa
select K.TENKHOA, GV.MAGV as MAGV_TRUONGKHOA, GV.HOTEN as HOTEN_TRUONGKHOA
from KHOA K, GIAOVIEN GV
where K.TRUONGKHOA = GV.MAGV

-- Q9: Cho biết các giáo viên của bộ môn "Vi sinh" có tham gia đề tài 006
select GV.MAGV as MAGV
from GIAOVIEN GV, BOMON BM
where GV.MABM = BM.MABM and BM.TENBM = N'Vi sinh'
INTERSECT
select GVCNDT as MAGV
from DETAI
where MADT = '006'

-- Q10: Với những đề tài thuộc cấp quản lý "Thành phố", cho biết mã đề tài, đề tài thuộc về chủ đề nào, họ tên người chủ nhiệm đề tài cùng với ngày sinh ngày sinh và địa chỉ của người ấy
select DT.MADT, DT.MACD, GV.HOTEN, GV.NGAYSINH, GV.DIACHI
from DETAI DT join CHUDE CD on DT.MACD = CD.MACD join GIAOVIEN GV on DT.GVCNDT = GV.MAGV
where DT.CAPQL = N'Thành phố'

-- Q11: Tìm họ tên của từng giáo viên và người phụ trách chuyên môn trực tiếp của giáo viên đó
select GV.HOTEN, QLCM.HOTEN as HOTEN_QLCM
from GIAOVIEN as GV, GIAOVIEN as QLCM
where GV.GVQLCM = QLCM.MAGV


-- Q12: Tìm họ tên của từng giáo viên được "Nguyễn Thanh Tùng " phụ trách trực tiếp
select HOTEN
from GIAOVIEN 
where GVQLCM = (select MAGV from GIAOVIEN where HOTEN = N'Nguyễn Thanh Tùng')

-- Q13: CHo biết tên giáo viên là trưởng bộ môn "Hệ thống thông tin"
select GV.HOTEN as TRUONGBM_HTTT
from GIAOVIEN GV join BOMON BM on GV.MAGV = BM.TRUONGBM
where BM.TENBM = N'Hệ thống thông tin'

-- Q14: Cho biết tên người chuur nhiệm đề tài của những đề tài thuộc chủ đề quản lý giáo dục
select DiSTINCT GV.HOTEN
from GIAOVIEN GV, DETAI DT, CHUDE CD
where GV.MAGV = DT.GVCNDT and DT.MACD = CD.MACD and CD.TENCD = N'Quản lý giáo dục'

-- Q15: Cho biết tên các công việc của đề tài HTTT quản lý các trường ĐH có thời gian bắt đầu trong tháng 3/2008
select CV.TENCV
from CONGVIEC CV join DETAI DT on CV.MADT = DT.MADT
where DT.TENDT = N'HTTT quản lý các trường ĐH' and month(CV.NGAYBD) = 3 and year(CV.NGAYBD) = 2008

-- Q16: Cho biết tên giáo viên và tên người quản lý chuyên môn của giáo viên đó
select GV.HOTEN, QLCM.HOTEN as HOTEN_QLCM
from GIAOVIEN as GV, GIAOVIEN as QLCM
where GV.GVQLCM = QLCM.MAGV


-- Q17: Cho các công việc bắt đầu trong khoảng từ 01/01/2007 đến 01/08/2007
select *
from CONGVIEC
where NGAYBD between '2007-01-01' and '2007-08-01'

-- Q18: Cho biết họ tên các giáo viên cùng bộ môn với giáo viên "Trần Trà Hương"
select HOTEN
from GIAOVIEN
where HOTEN != N'Trần Trà Hương' and MABM = (select MABM from GIAOVIEN where HOTEN = N'Trần Trà Hương' )

-- Q19: Tìm những giáo viên vừa là trưởng bộ môn vừa chủ nhiệm đề tài
select DISTINCT GV.HOTEN as TRUONGBM_CNDT
from GIAOVIEN GV, DETAI DT, BOMON BM
where BM.TRUONGBM = DT.GVCNDT and GV.MAGV = BM.TRUONGBM

-- Q20: Cho biết tên những giáo viên vừa là trưởng khoa vừa là trưởng bộ môn
select DISTINCT GV.HOTEN
from GIAOVIEN GV, KHOA K, BOMON BM
where K.TRUONGKHOA = BM.TRUONGBM and GV.MAGV = K.TRUONGKHOA

-- Q21: Cho biết tên những trưởng bộ môn mà vừa chủ nhiệm đề tài
select DISTINCT GV.HOTEN as TRUONGBM_CNDT
from GIAOVIEN GV, DETAI DT, BOMON BM
where BM.TRUONGBM = DT.GVCNDT and GV.MAGV = BM.TRUONGBM

-- Q22: Cho nbieets mã số các trưởng khoa có chủ nhiệm đề tài
select DISTINCT DT.GVCNDT as TRUONGKHOA_CNDT
from DETAI DT, KHOA K
where K.TRUONGKHOA = DT.GVCNDT

-- Q23: Cho biết mã số các giáo viên thuộc bộ môn "HTTT" hoặc có tham gia đề tài mã 001
select GV.MAGV
from GIAOVIEN GV
where MABM = 'HTTT'
UNION 
select MAGV
from THAMGIADT
where MADT = '001'

-- Q24: Cho biết giáo viên làm việc cùng bộ môn với giáo viên 002
select MAGV
from GIAOVIEN
where MAGV != '002' and MABM = (select MABM from GIAOVIEN where MAGV = '002')


-- Q25: Tìm những giáo viên là trưởng bộ môn
select GV.MAGV, GV.HOTEN
from GIAOVIEN GV, BOMON BM
where BM.TRUONGBM = GV.MAGV

-- Q26: Cho biết họ tên và mức lương của các giáo viên
select HOTEN, LUONG
from GIAOVIEN