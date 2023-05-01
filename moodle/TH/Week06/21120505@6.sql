use QLGV
go

-- Viết các câu truy vấn lồng nâng cao --

-- Viết theo 3 cách except, not exists và count --

-- Q58: Cho biết tên giáo viên nào mà tham gia đề tài đủ tất cả các chủ đề
 
-- C1: dùng except
select GV.HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
where not exists ( select MACD from CHUDE
					except
					select MACD 
					from THAMGIADT TGDT2 join DETAI DT on TGDT2.MADT = DT.MADT
					where TGDT2.MAGV = GV.MAGV
					)

-- C2: dùng not exists
select GV.HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
where not exists ( select MACD from CHUDE
					where not exists (
					select MACD 
					from THAMGIADT TGDT2 join DETAI DT on TGDT2.MADT = DT.MADT
					where TGDT2.MAGV = GV.MAGV and DT.MACD = CHUDE.MACD)
					)

-- C3: dùng count
select GV.HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV join DETAI DT on DT.MADT = TGDT.MADT
group by GV.MAGV, GV.HOTEN
having count(distinct MACD) = (select count(*)
								from CHUDE)

-- Q59: Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn HTTT tham gia

-- C1: dùng except 
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists (select GV.MAGV 
					from GIAOVIEN GV
					where GV.MABM = 'HTTT' 
					except 
					select distinct TGDT2.MAGV
					from THAMGIADT TGDT2 join GIAOVIEN GV2 on TGDT2.MAGV = GV2.MAGV
					where GV2.MABM = 'HTTT' and TGDT2.MADT = TGDT.MADT

)

-- C2: dùng not exists
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists (select GV.MAGV 
					from GIAOVIEN GV
					where GV.MABM = 'HTTT'  and not exists 
													( select  TGDT2.MAGV
													from THAMGIADT TGDT2 
														where TGDT2.MADT = TGDT.MADT and TGDT2.MAGV = GV.MAGV )

)

-- C3: dùng count
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT join (select MAGV from GIAOVIEN where GIAOVIEN.MABM = 'HTTT') as T on T.MAGV = TGDT.MAGV
group by DT.MADT, DT.TENDT
having count (distinct TGDT.MAGV) = (select count(*) 
									from GIAOVIEN 
									where GIAOVIEN.MABM = 'HTTT')

-- Q60: Cho biết tên đề tài có tất cả giảng viên bộ môn "Hệ thống thông tin tham gia"

-- C1: dùng except
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists (select GV.MAGV 
					from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
					where BM.TENBM = N'Hệ thống thông tin' 
					except 
					select distinct TGDT2.MAGV
					from THAMGIADT TGDT2 join GIAOVIEN GV2 on TGDT2.MAGV = GV2.MAGV join BOMON BM on BM.MABM = GV2.MABM
					where BM.TENBM = N'Hệ thống thông tin' and TGDT2.MADT = TGDT.MADT

)

-- C2: dùng not exist 
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists (select GV.MAGV 
					from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
					where BM.TENBM = N'Hệ thống thông tin'  and not exists 
													( select  TGDT2.MAGV
													from THAMGIADT TGDT2 
														where TGDT2.MADT = TGDT.MADT and TGDT2.MAGV = GV.MAGV )

)

-- C3: dùng count
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT join (select MAGV from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM where BM.TENBM = N'Hệ thống thông tin') as T on T.MAGV = TGDT.MAGV
group by DT.MADT, DT.TENDT
having count (distinct TGDT.MAGV) = (select count(*) 
									from GIAOVIEN GV1 join BOMON BM1 on GV1.MABM = BM1.MABM
									where BM1.TENBM = N'Hệ thống thông tin')

-- Q61: Cho biết giáo viên nào đã tham gia tất cả các đề tài có mã chủ đề là QLGD

-- C1: dùng except
select distinct TGDT.MAGV
from THAMGIADT TGDT
where not exists (select MADT
					from DETAI
					where MACD = 'QLGD'
					except
					select DT.MADT
					from DETAI DT join THAMGIADT TGDT1 on DT.MADT = TGDT1.MADT
					where TGDT1.MAGV = TGDT.MAGV and DT.MACD = 'QLGD'


)

-- C2: dùng not exist 
select distinct TGDT.MAGV
from THAMGIADT TGDT
where not exists (select MADT
					from DETAI DT1
					where MACD = 'QLGD' and not exists (select *
														from THAMGIADT TGDT1
														where TGDT1.MAGV = TGDT.MAGV and TGDT1.MADT = DT1.MADT 
														
								)
)


-- C3: dùng count
select TGDT.MAGV
from THAMGIADT TGDT join DETAI DT on TGDT.MADT = DT.MADT and DT.MACD = 'QLGD'
group by (MAGV)
having count(distinct DT.MADT) = (select count(*)
									from DETAI
									where MACD = 'QLGD'
									group by MACD

)



-- Q62: Cho biết tên giáo viên nào tham gia tất cả các đề tài mà giáo viên Trần Trà Hương đã tham gia

-- C1: dùng except
select distinct GV.HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
where GV.HOTEN != N'Trần Trà Hương' and  not exists (select distinct TGDT1.MADT
													from THAMGIADT TGDT1 join GIAOVIEN GV1 on TGDT1.MAGV = GV1.MAGV and GV1.HOTEN = N'Trần Trà Hương'
													except 
													select distinct TGDT2.MADT
													from THAMGIADT TGDT2 join GIAOVIEN GV2 on TGDT2.MAGV = GV2.MAGV 
													where TGDT2.MAGV = TGDT.MAGV and TGDT2.MADT in (select distinct TGDT1.MADT
																									from THAMGIADT TGDT1 join GIAOVIEN GV1 on TGDT1.MAGV = GV1.MAGV and GV1.HOTEN = N'Trần Trà Hương'
													)

)

-- C2: dùng not exist 
select distinct GV.HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
where GV.HOTEN != N'Trần Trà Hương' and  not exists (select distinct TGDT1.MADT
													from THAMGIADT TGDT1 join GIAOVIEN GV1 on TGDT1.MAGV = GV1.MAGV and GV1.HOTEN = N'Trần Trà Hương'
													where not exists (select *
																	from THAMGIADT TGDT2
																	where TGDT.MAGV = TGDT2.MAGV and TGDT1.MADT = TGDT2.MADT
													)

)

-- C3: dùng count
select distinct GV.HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV and GV.HOTEN != N'Trần Trà Hương'
where TGDT.MADT in (select distinct MADT from THAMGIADT TGDT2 join GIAOVIEN GV2 on GV2.MAGV = TGDT2.MAGV and GV2.HOTEN = N'Trần Trà Hương')
group by GV.MAGV, GV.HOTEN
having count(distinct TGDT.MADT) = (select count(distinct MADT) from THAMGIADT TGDT2 join GIAOVIEN GV2 on GV2.MAGV = TGDT2.MAGV and GV2.HOTEN = N'Trần Trà Hương')

-- Q63: Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn Hóa hữu cơ tham gia

-- C1: dùng except
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists (select GV.MAGV 
					from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
					where BM.TENBM = N'Hóa hữu cơ' 
					except 
					select distinct TGDT2.MAGV
					from THAMGIADT TGDT2 join GIAOVIEN GV2 on TGDT2.MAGV = GV2.MAGV join BOMON BM on BM.MABM = GV2.MABM
					where BM.TENBM = N'Hóa hữu cơ'  and TGDT2.MADT = TGDT.MADT

)

-- C2: dùng not exist 
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists (select GV.MAGV 
					from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
					where BM.TENBM = N'Hóa hữu cơ'   and not exists 
													( select  TGDT2.MAGV
													from THAMGIADT TGDT2 
														where TGDT2.MADT = TGDT.MADT and TGDT2.MAGV = GV.MAGV )

)

-- C3: dùng count
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT join (select MAGV from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM where BM.TENBM = N'Hóa hữu cơ' ) as T on T.MAGV = TGDT.MAGV
group by DT.MADT, DT.TENDT
having count (distinct TGDT.MAGV) = (select count(*) 
									from GIAOVIEN GV1 join BOMON BM1 on GV1.MABM = BM1.MABM
									where BM1.TENBM = N'Hóa hữu cơ' )

-- Q64: Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài 006

-- C1: dùng except
select distinct GV.HOTEN 
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV 
where TGDT.MADT = '006' and not exists (select SOTT from CONGVIEC where MADT = '006'
										except 
										select STT
										from THAMGIADT TGDT1 
										where MADT = '006' and TGDT1.MAGV = TGDT.MAGV

)

-- C2: dùng not exist 
select distinct GV.HOTEN 
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV 
where TGDT.MADT = '006' and not exists (select CV1.SOTT from CONGVIEC CV1 where MADT = '006' and not exists (select * 
																											from THAMGIADT TGDT1
																											where TGDT1.MAGV = TGDT.MAGV and TGDT1.MADT = '006' and TGDT1.SOTT = CV1.SOTT
															)

)


-- C3: dùng count
select distinct GV.HOTEN 
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
where TGDT.MADT = '006'
group by GV.MAGV, GV.HOTEN
having count (*) = (select count(*)
					from CONGVIEC
					where MADT = '006'
				)

-- Q65: Cho biết các giáo viên nào đã tham gia tất cả các đề tài của chủ đề Ứng dụng công nghệ

-- C1: dùng except
select distinct TGDT.MAGV
from THAMGIADT TGDT
where not exists (select MADT
					from DETAI
					where MACD = (select MACD from CHUDE where TENCD = N'Ứng dụng công nghệ')
					except
					select DT.MADT
					from DETAI DT join THAMGIADT TGDT1 on DT.MADT = TGDT1.MADT
					where TGDT1.MAGV = TGDT.MAGV and DT.MACD = (select MACD from CHUDE where TENCD = N'Ứng dụng công nghệ')


)

-- C2: dùng not exist 
select distinct TGDT.MAGV
from THAMGIADT TGDT
where not exists (select MADT
					from DETAI DT1
					where MACD = (select MACD from CHUDE where TENCD = N'Ứng dụng công nghệ') and not exists (select *
														from THAMGIADT TGDT1
														where TGDT1.MAGV = TGDT.MAGV and TGDT1.MADT = DT1.MADT 
														
								)
)


-- C3: dùng count
select TGDT.MAGV
from THAMGIADT TGDT join DETAI DT on TGDT.MADT = DT.MADT and DT.MACD = (select MACD from CHUDE where TENCD = N'Ứng dụng công nghệ')
group by (MAGV)
having count(distinct DT.MADT) = (select count(*)
									from DETAI
									where MACD = (select MACD from CHUDE where TENCD = N'Ứng dụng công nghệ')
									group by MACD

)

-- Q66: Cho biết tên giáo viên nào đã tham gia tất cả các đề tài do Trần Trà Hương làm chủ nhiệm

-- C1: dùng except
select distinct GV.HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
where GV.HOTEN != N'Trần Trà Hương' and  not exists (select DT1.MADT
													from DETAI DT1 
													where DT1.GVCNDT = (select MAGV from GIAOVIEN where HOTEN = N'Trần Trà Hương' )
													except 
													select distinct TGDT2.MADT
													from THAMGIADT TGDT2 join GIAOVIEN GV2 on TGDT2.MAGV = GV2.MAGV 
													where TGDT2.MAGV = TGDT.MAGV and TGDT2.MADT in (select DT2.MADT
																									from DETAI DT2 
																									where DT2.GVCNDT = (select MAGV from GIAOVIEN where HOTEN = N'Trần Trà Hương')
													)

)

-- C2: dùng not exist 
select distinct GV.HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
where GV.HOTEN != N'Trần Trà Hương' and  not exists (select DT1.MADT
													from DETAI DT1 
													where DT1.GVCNDT = (select MAGV from GIAOVIEN where HOTEN = N'Trần Trà Hương')
													and not exists (select *
																	from THAMGIADT TGDT2
																	where TGDT.MAGV = TGDT2.MAGV and DT1.MADT = TGDT2.MADT
													)

)

-- C3: dùng count
select distinct GV.HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV and GV.HOTEN != N'Trần Trà Hương'
where TGDT.MADT in (select MADT from DETAI where GVCNDT = (select MAGV from GIAOVIEN where HOTEN = N'Trần Trà Hương'))
group by GV.MAGV, GV.HOTEN
having count(distinct TGDT.MADT) = (select count(*) from DETAI where GVCNDT = (select MAGV from GIAOVIEN where HOTEN = N'Trần Trà Hương'))

-- Q67: Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa CNTT tham gia

-- C1: dùng except 
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists (select GV.MAGV 
					from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
					where  BM.MAKHOA = 'CNTT' 
					except 
					select distinct TGDT2.MAGV
					from THAMGIADT TGDT2 join GIAOVIEN GV2 on TGDT2.MAGV = GV2.MAGV join BOMON BM on GV2.MABM = BM.MABM
					where BM.MAKHOA = 'CNTT' and TGDT2.MADT = TGDT.MADT

)

-- C2: dùng not exists
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists (select GV.MAGV 
					from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
					where BM.MAKHOA = 'CNTT'  and not exists 
													( select  TGDT2.MAGV
													from THAMGIADT TGDT2 
														where TGDT2.MADT = TGDT.MADT and TGDT2.MAGV = GV.MAGV )

)

-- C3: dùng count
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT join (select MAGV from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM where BM.MAKHOA = 'CNTT') as T on T.MAGV = TGDT.MAGV
group by DT.MADT, DT.TENDT
having count (distinct TGDT.MAGV) = (select count(*) 
									from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
									where BM.MAKHOA = 'CNTT')

-- Q68: Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài Nghiên cứu tế bào gốc

-- C1: dùng except
select distinct GV.HOTEN 
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV 
where TGDT.MADT = (select MADT from DETAI where TENDT = N'Nghiên cứu tế bào gốc') and not exists (select SOTT from CONGVIEC where MADT = (select MADT from DETAI where TENDT = N'Nghiên cứu tế bào gốc')
										except 
										select STT
										from THAMGIADT TGDT1 
										where MADT = (select MADT from DETAI where TENDT = N'Nghiên cứu tế bào gốc') and TGDT1.MAGV = TGDT.MAGV

)

-- C2: dùng not exist 
select distinct GV.HOTEN 
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV 
where TGDT.MADT = (select MADT from DETAI where TENDT = N'Nghiên cứu tế bào gốc') and not exists (select CV1.SOTT from CONGVIEC CV1 where MADT = TGDT.MADT and not exists (select * 
																											from THAMGIADT TGDT1
																											where TGDT1.MAGV = TGDT.MAGV and TGDT1.MADT = CV1.MADT and TGDT1.SOTT = CV1.SOTT
															)

)


-- C3: dùng count
select distinct GV.HOTEN 
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
where TGDT.MADT = (select MADT from DETAI where TENDT = N'Nghiên cứu tế bào gốc')
group by GV.MAGV, GV.HOTEN
having count (*) = (select count(*)
					from CONGVIEC
					where MADT = (select MADT from DETAI where TENDT = N'Nghiên cứu tế bào gốc')
				)

-- Q69: Tìm tên các giáo viên được phân công làm tất cả các đề tài có kinh phí trên 100 triệu

-- C1: dùng except
select distinct GV.HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on TGDT.MAGV = GV.MAGV
where not exists  (select MADT from DETAI where KINHPHI > 100
					except 
					select distinct TGDT1.MADT
					from THAMGIADT TGDT1
					where TGDT1.MAGV = TGDT.MAGV and TGDT1.MADT in (select MADT from DETAI where KINHPHI > 100)

)

-- C2: dùng not exist 
select distinct GV.HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on TGDT.MAGV = GV.MAGV
where not exists  (select MADT from DETAI where KINHPHI > 100 
					and not exists  (select *
									from THAMGIADT TGDT1
									where TGDT1.MAGV = TGDT.MAGV and TGDT1.MADT = DETAI.MADT
									)
)

-- C3: dùng count
select distinct HOTEN
from GIAOVIEN GV join THAMGIADT TGDT on TGDT.MAGV = GV.MAGV join DETAI DT on TGDT.MADT = DT.MADT
where TGDT.MADT in (select MADT from DETAI where KINHPHI > 100)
group by GV.MAGV, GV.HOTEN
having count(distinct TGDT.MADT) = (select count(*) from DETAI where KINHPHI > 100) 


-- Q70: Cho biết tên đề tài nào nào mà được tất cả các giáo viên của khoa Sinh học tham gia


-- C1: dùng except 
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists (select GV.MAGV 
					from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
					where  BM.MAKHOA = (select MAKHOA from KHOA where TENKHOA = N'Sinh học')
					except 
					select distinct TGDT2.MAGV
					from THAMGIADT TGDT2 join GIAOVIEN GV2 on TGDT2.MAGV = GV2.MAGV join BOMON BM on GV2.MABM = BM.MABM
					where BM.MAKHOA = (select MAKHOA from KHOA where TENKHOA = N'Sinh học') and TGDT2.MADT = TGDT.MADT

)

-- C2: dùng not exists
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists (select GV.MAGV 
					from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
					where BM.MAKHOA = (select MAKHOA from KHOA where TENKHOA = N'Sinh học')  and not exists 
													( select  TGDT2.MAGV
													from THAMGIADT TGDT2 
														where TGDT2.MADT = TGDT.MADT and TGDT2.MAGV = GV.MAGV )

)

-- C3: dùng count
select distinct DT.TENDT
from DETAI DT join THAMGIADT TGDT on DT.MADT = TGDT.MADT join (select MAGV from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM where BM.MAKHOA = (select MAKHOA from KHOA where TENKHOA = N'Sinh học')) as T on T.MAGV = TGDT.MAGV
group by DT.MADT, DT.TENDT
having count (distinct TGDT.MAGV) = (select count(*) 
									from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
									where BM.MAKHOA = (select MAKHOA from KHOA where TENKHOA = N'Sinh học'))


-- Q71: Cho biết mã số, họ tên, ngày sinh của giáo viên tham gia tất cả các công việc của đề tài Ứng dụng hóa học xanh

-- C1: dùng except
select distinct GV.MAGV, GV.HOTEN, GV.NGAYSINH  
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV 
where TGDT.MADT = (select MADT from DETAI where TENDT = N'Ứng dụng hóa học xanh') and not exists (select SOTT from CONGVIEC where MADT = TGDT.MADT
										except 
										select STT
										from THAMGIADT TGDT1 
										where MADT = TGDT.MADT and TGDT1.MAGV = TGDT.MAGV

)

-- C2: dùng not exist 
select distinct GV.MAGV, GV.HOTEN, GV.NGAYSINH
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV 
where TGDT.MADT = (select MADT from DETAI where TENDT = N'Ứng dụng hóa học xanh') and not exists (select CV1.SOTT from CONGVIEC CV1 where MADT = TGDT.MADT and not exists (select * 
																											from THAMGIADT TGDT1
																											where TGDT1.MAGV = TGDT.MAGV and TGDT1.MADT = CV1.MADT and TGDT1.SOTT = CV1.SOTT
															)

)


-- C3: dùng count
select distinct GV.MAGV, GV.HOTEN, GV.NGAYSINH
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV
where TGDT.MADT = (select MADT from DETAI where TENDT = N'Ứng dụng hóa học xanh')
group by GV.MAGV, GV.HOTEN
having count (*) = (select count(*)
					from CONGVIEC
					where MADT = (select MADT from DETAI where TENDT = N'Ứng dụng hóa học xanh')
				)


-- Q72: Cho biết mã số, họ tên, tên bộ môn và tên người quản lý chuyên môn của giáo viên tham gia tất cả các đề tài thuộc chủ đề Nghiên cứu phát triển


-- C1: dùng except
select MAGV, HOTEN, BM.TENBM, (select GV2.HOTEN from GIAOVIEN GV2 where GV2.MAGV = GV.GVQLCM) as TEN_GVQLCM
from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
where GV.MAGV in (select distinct TGDT.MAGV
					from THAMGIADT TGDT
					where not exists (select MADT
						from DETAI
						where MACD = (select MACD from CHUDE where TENCD = N'Nghiên cứu phát triển')
						except
						select DT.MADT
						from DETAI DT join THAMGIADT TGDT1 on DT.MADT = TGDT1.MADT
						where TGDT1.MAGV = TGDT.MAGV and DT.MACD = (select MACD from CHUDE where TENCD = N'Nghiên cứu phát triển')


))

-- C2: dùng not exist 
select MAGV, HOTEN, BM.TENBM, (select GV2.HOTEN from GIAOVIEN GV2 where GV2.MAGV = GV.GVQLCM) as TEN_GVQLCM
from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
where GV.MAGV in (
select distinct TGDT.MAGV
from THAMGIADT TGDT
where not exists (select MADT
					from DETAI DT1
					where MACD = (select MACD from CHUDE where TENCD = N'Nghiên cứu phát triển') and not exists (select *
														from THAMGIADT TGDT1
														where TGDT1.MAGV = TGDT.MAGV and TGDT1.MADT = DT1.MADT 
														
								)
)
)

-- C3: dùng count
select MAGV, HOTEN, BM.TENBM, (select GV2.HOTEN  from GIAOVIEN GV2 where GV2.MAGV = GV.GVQLCM) as TEN_GVQLCM
from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
where GV.MAGV in (
select TGDT.MAGV
from THAMGIADT TGDT join DETAI DT on TGDT.MADT = DT.MADT and DT.MACD = (select MACD from CHUDE where TENCD = N'Nghiên cứu phát triển')
group by (MAGV)
having count(distinct DT.MADT) = (select count(*)
									from DETAI
									where MACD = (select MACD from CHUDE where TENCD = N'Nghiên cứu phát triển')
									group by MACD

)
)