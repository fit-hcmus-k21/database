-- Viết các câu truy vấn lồng --

-- Q35: Cho biết mức lương cao nhất của các giảng viên --
-- C1: 
select MAX(LUONG) as MAX_LUONG
from GIAOVIEN

-- C2: 
select DISTINCT LUONG as MAX_Luong
from GIAOVIEN GV
where LUONG >= ALL (select LUONG
					from GIAOVIEN)


-- Q36: Cho biết những giáo viên có lương cao nhất --
-- C1
select GV.MAGV, GV.HOTEN, GV.LUONG
from GIAOVIEN GV
where LUONG = (select MAX(LUONG) 
				from GIAOVIEN)

-- C2
select GV.MAGV, GV.HOTEN, GV.LUONG
from GIAOVIEN GV
where GV.LUONG >= ALL (select LUONG
						from GIAOVIEN)


-- Q37: Cho biết lương cao nhất trong bộ môn HTTT --
--C1
select MAX(LUONG) as LUONG_MAX_HTTT
from (select * 
		from GIAOVIEN
		where MABM = 'HTTT') as GV_HTTT

--C2
select DISTINCT LUONG as MAX_LUONG_HTTT
from GIAOVIEN
where LUONG >= ALL (select LUONG
					from GIAOVIEN
					where MABM = 'HTTT')


-- Q38: Cho biết tên giáo viên lớn tuổi nhất của bộ môn Hệ thống thông tin --
--C1
select top 1 GV.HOTEN as GV_GIA_NHAT
from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
where BM.TENBM = N'Hệ thống thông tin'
order by GV.NGAYSINH

--C2
select HOTEN
from (select * 
		from GIAOVIEN
		where MABM IN (select MABM
						from BOMON
						where TENBM = N'Hệ thống thông tin')) as GV
where GV.NGAYSINH = (select MIN((GV2.NGAYSINH))
							from GIAOVIEN GV2 join BOMON BM on GV2.MABM = BM.MABM
							where BM.TENBM = N'Hệ thống thông tin')
							


-- Q39: Cho biết tên giáo viên nhỏ tuổi nhất khoa CNTT --
--C1
select top 1 GV.HOTEN as GV_GIA_NHAT
from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
where BM.MAKHOA = 'CNTT'
order by GV.NGAYSINH DESC

--C2
select HOTEN
from (select * 
		from GIAOVIEN
		where MABM IN (select MABM
						from BOMON
						where MAKHOA = 'CNTT')) as GV
where GV.NGAYSINH IN (select MAX((GV2.NGAYSINH))
							from GIAOVIEN GV2 join BOMON BM on GV2.MABM = BM.MABM
							where BM.MAKHOA = 'CNTT')


-- Q40: Cho biết tên giáo viên và tên khoa của gv có lương cao nhất --
--C1
select GV.HOTEN, K.TENKHOA, GV.LUONG
from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM join KHOA K on K.MAKHOA = BM.MAKHOA
where GV.LUONG = (select MAX(LUONG)
					from GIAOVIEN)

--C2
select GV.HOTEN, K.TENKHOA, GV.LUONG
from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM join KHOA K on K.MAKHOA = BM.MAKHOA
where GV.LUONG >= ALL (select (LUONG)
					from GIAOVIEN)

-- Q41: Cho biết những giáo viên có lương lớn nhất trong bộ môn của họ --
select GV.MAGV, GV.HOTEN, GV.MABM, GV.LUONG
from GIAOVIEN GV
where GV.LUONG = (select MAX(LUONG)
					from GIAOVIEN GV2
					where GV.MABM = GV2.MABM)


-- Q42: Cho biết tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia --
select TENDT
from DETAI
where MADT not in (select DISTINCT MADT
					from THAMGIADT
					where MAGV = (select MAGV
									from GIAOVIEN
									where HOTEN = N'Nguyễn Hoài An'))

-- Q43: Cho biết những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia.
--      Xuất ra tên đề tài và tên người chủ nhiệm đề tài --
select TENDT, HOTEN as GVCNDT
from DETAI DT join GIAOVIEN GV on GV.MAGV = DT.GVCNDT
where MADT not in (select DISTINCT MADT
					from THAMGIADT
					where MAGV = (select MAGV
									from GIAOVIEN
									where HOTEN = N'Nguyễn Hoài An'))

-- Q44: Cho biết tên những giáo viên khoa công thệ thông tin mà chưa tham gia đề tài nào --
select GV.HOTEN
from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM join KHOA K on BM.MAKHOA = K.MAKHOA
where K.TENKHOA = N'Công nghệ thông tin' and GV.MAGV not in (select DISTINCT MAGV
															from THAMGIADT)


-- Q45: Tìm những giáo viên không tham gia bất kỳ đề tài nào --
select * 
from GIAOVIEN
where MAGV not in (select distinct MAGV 
					from THAMGIADT)

-- Q46: Cho biết giáo viên có lương lớn hơn hương của giáo viên Nguyễn Hoài An --
select *
from GIAOVIEN
where LUONG > (select LUONG
				from GIAOVIEN
				where HOTEN = N'Nguyễn Hoài An')

-- Q47: Tìm những trưởng bộ môn tham gia tối thiểu 1 đề tài --
select GV.MAGV, GV.HOTEN
from GIAOVIEN GV right join BOMON BM on BM.TRUONGBM = GV.MAGV
where GV.MAGV in (select distinct MAGV
					from THAMGIADT)

-- Q48: Tìm giáo viên trùng tên và cùng giới tính với giáo viên khác trong cùng bộ môn --
select * 
from GIAOVIEN GV1
where MAGV in (select MAGV
				from GIAOVIEN GV2
				where GV1.HOTEN = GV2.HOTEN and GV1.PHAI = GV2.PHAI and GV1.MABM = GV2.MABM and GV1.MAGV != GV2.MAGV)



-- Q49: Tìm những giáo viên có lương lớn hơn lương của ít nhất một giáo viên bộ môn "Công nghệ phần mềm" --
select MAGV, HOTEN, LUONG, GV.MABM
from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
where TENBM != N'Công nghệ phần mềm' and LUONG > ANY (select LUONG
					from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
					where TENBM = N'Công nghệ phần mềm')

-- Q50: Tìm những giáo viên có lương lớn hơn lương của tất cả giáo viên thuộc bộ môn "Hệ thống thông tin" --
select *
from GIAOVIEN GV join BOMON BM on BM.MABM = GV.MABM
where TENBM != N'Hệ thống thông tin' and  LUONG > ALL (select LUONG
					from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
					where BM.TENBM = N'Hệ thống thông tin')

-- Q51: Cho biết tên khoa có đông giáo viên nhất --
select K.TENKHOA
from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM join KHOA K on K.MAKHOA = BM.MAKHOA
group by K.TENKHOA, K.MAKHOA
having count(*) >= ALL (select count(*)
					from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM join KHOA K on K.MAKHOA = BM.MAKHOA
					group by K.TENKHOA, K.MAKHOA)

-- Q52: Cho biết họ tên giáo viên chủ nhiệm nhiều đề tài nhất --
select HOTEN
from GIAOVIEN
where MAGV in (select GVCNDT
				from DETAI DT
				group by GVCNDT
				having count(*) >= ALL (select count(*)
										from DETAI
										group by GVCNDT)
				
				)

-- Q53: Cho biết mã bộ môn có nhiều giáo viên nhất --
select MABM
from GIAOVIEN
group by MABM
having count(*) >= ALL (select count(*)
						from GIAOVIEN
						group by MABM)


-- Q54: Cho biết tên giáo viên và tên bộ môn của giáo viên tham gia nhiều đề tài nhất --
select HOTEN, TENBM
from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
where GV.MAGV in (select MAGV
					from THAMGIADT
					group by MAGV
					having count(distinct MADT) >= ALL (select count(distinct MADT)
														from THAMGIADT
														group by MAGV)
					)

-- Q55: Cho biết tên giáo viên tham gia nhiều đề tài nhất của bộ môn HTTT --
select HOTEN 
from GIAOVIEN 
where MAGV in (select GV.MAGV
				from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
				where GV.MABM = 'HTTT'
				group by GV.MAGV
				having count(distinct MADT) >= ALL (select count(distinct MADT)
													from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
													where GV.MABM = 'HTTT'
													group by GV.MAGV)
				)

-- Q56: Cho biết tên giáo viên và tên bộ môn của giáo viên có nhiều người thân nhất --
select HOTEN, TENBM
from GIAOVIEN join BOMON on GIAOVIEN.MABM = BOMON.MABM
where MAGV in (select MAGV
				from NGUOITHAN
				group by MAGV
				having count(*) >= ALL (select count(*)
										from NGUOITHAN
										group by MAGV)
				)

-- Q57: Cho biết tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất --
select GIAOVIEN.HOTEN
from BOMON left join GIAOVIEN on BOMON.MABM = GIAOVIEN.MABM join DETAI on DETAI.GVCNDT = GIAOVIEN.MAGV 
group by DETAI.GVCNDT, GIAOVIEN.HOTEN
having count(*) >= ALL (select count(*)
						from BOMON left join GIAOVIEN on BOMON.MABM = GIAOVIEN.MABM join DETAI on DETAI.GVCNDT = GIAOVIEN.MAGV 
						group by DETAI.GVCNDT)