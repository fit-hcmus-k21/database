use QLGV 
go

-- Q75: Cho biết họ tên giáo viên và tên bộ môn họ làm trường bộ môn nếu có
select GV.HOTEN, (select TENBM from BOMON BM where GV.MAGV = BM.TRUONGBM) as TENBM_LATRUONGBM
from GIAOVIEN GV

-- Hay
select HOTEN, TENBM as TENBM_LATRUONGBM
from GIAOVIEN left join BOMON on GIAOVIEN.MAGV = BOMON.TRUONGBM


-- Q76. Cho danh sách tên bộ môn và họ tên trưởng bộ môn đó nếu có
select TENBM, (select HOTEN from GIAOVIEN GV where BM.TRUONGBM = GV.MAGV) as HOTEN_TRUONGBM
from BOMON BM

-- Hay
select TENBM, HOTEN as HOTEN_TRUONGBM
from BOMON BM left join GIAOVIEN GV on BM.TRUONGBM = GV.MAGV

-- Q77. Cho danh sách tên giáo viên và các đề tài giáo viên đó chủ nhiệm nếu có
select HOTEN, TENDT
from GIAOVIEN GV left join DETAI DT on GVCNDT = MAGV

-- Q78. Xuất ra thông tin của giáo viên (MAGV, HOTEN) và mức lương của giáo viên. 
--      Mức lương được xếp theo quy tắc: Lương của giáo viên < $1800 : “THẤP” ; Từ $1800 đến $2200: TRUNG BÌNH; Lương > $2200: “CAO"

select MAGV, HOTEN, LUONG, (CASE 
								WHEN LUONG < 1800 THEN N'THẤP'
								WHEN LUONG <= 2200 THEN N'TRUNG BÌNH'
								WHEN LUONG > 2200 THEN N'CAO'
							END
							) as XEPLOAI_LUONG
from GIAOVIEN

-- Q79. Xuất ra thông tin giáo viên (MAGV, HOTEN) và xếp hạng dựa vào mức lương. Nếu giáo viên có lương cao nhất thì hạng là 1.
select MAGV, HOTEN, (select count(*) from GIAOVIEN GV2 where GV2.LUONG >= GV1.LUONG and GV2.MAGV != GV1.MAGV) as HANG
from GIAOVIEN GV1

-- Q80. Xuất ra thông tin thu nhập của giáo viên. Thu nhập của giáo viên được tính bằng 
--      LƯƠNG + PHỤ CẤP. Nếu giáo viên là trưởng bộ môn thì PHỤ CẤP là 300, và giáo viên là trưởng khoa thì PHỤ CẤP là 600.
select MAGV, HOTEN, (CASE 
						WHEN GV.MAGV IN (select TRUONGBM from BOMON) and GV.MAGV IN (select TRUONGKHOA from KHOA ) THEN LUONG + 300 + 600
						WHEN GV.MAGV IN (select TRUONGBM from BOMON) THEN LUONG + 300
						WHEN GV.MAGV IN (select TRUONGKHOA from KHOA ) THEN LUONG + 600
						ELSE LUONG
					
					  END) as THUNHAP
from GIAOVIEN GV

-- Q81. Xuất ra năm mà giáo viên dự kiến sẽ nghĩ hưu với quy định: Tuổi nghỉ hưu của Nam là 60, của Nữ là 55
select MAGV, HOTEN, (CASE PHAI
					WHEN 'Nam' THEN year(NGAYSINH) + 60
					WHEN N'Nữ' THEN year(NGAYSINH) + 55
					END ) as NAMNGHIHUU_DUKIEN
from GIAOVIEN
-----------------------------

-- Q82. Cho biết danh sách tất cả giáo viên (magv, hoten) và họ tên giáo viên là quản lý chuyên môn của họ.
select GV1.MAGV, GV1.HOTEN, GV2.HOTEN as GVQLCM
from GIAOVIEN GV1 left join GIAOVIEN GV2 on GV1.GVQLCM = GV2.MAGV


-- Q83. Cho biếtdanh sáchtất cả bộ môn (mabm, tenbm), tên trưởng bộ môn cùng số lượng giáo viên của mỗi bộ môn.
select BM.MABM, TENBM ,GV.HOTEN as TRUONGBM, (select count(*) from GIAOVIEN GV2 where GV2.MABM = BM.MABM) as SLGV
from BOMON BM left join GIAOVIEN GV on TRUONGBM = MAGV

-- Q84. Cho biết danh sách tất cả các giáo viên nam và thông tin các công việc mà họ đã tham gia.
select GV.MAGV, HOTEN, TENCV, NGAYBD, NGAYKT
from GIAOVIEN GV left join THAMGIADT TGDT on TGDT.MAGV = GV.MAGV join CONGVIEC CV on CV.MADT = TGDT.MADT and CV.SOTT = TGDT.STT 
where GV.PHAI = 'Nam'

-- Q85. Cho biết danh sách tất cả các giáo viên và thông tin các công việc thuộc đề tài 001 mà họ tham gia.
select GV.MAGV, GV.HOTEN, TENCV, NGAYBD, NGAYKT
from GIAOVIEN GV join THAMGIADT TGDT on GV.MAGV = TGDT.MAGV join CONGVIEC CV on CV.MADT = TGDT.MADT and CV.STT = TGDT.STT 
where TGDT.MADT = '001'

-- Q86. Cho biết thông tin các trưởng bộ môn (magv, hoten) sẽ về hưu vào năm 2014. Biết rằng độ tuổi về hưu của giáo viên nam là 60 còn giáo viên nữ là 55.
select GV.MAGV, GV.HOTEN
from GIAOVIEN GV join BOMON BM on BM.TRUONGBM = GV.MAGV
where (CASE PHAI
		WHEN 'Nam' THEN year(NGAYSINH) + 60
		WHEN N'Nữ' THEN year(NGAYSINH) + 55
	   END ) = 2014

-- Q87. Cho biết thông tin các trưởng khoa (magv) và năm họ sẽ về hưu.
select K.TRUONGKHOA, GV.HOTEN, K.TENKHOA, (CASE PHAI
											WHEN 'Nam' THEN year(NGAYSINH) + 60
											WHEN N'Nữ' THEN year(NGAYSINH) + 55
										   END) as NAMVEHUU
from GIAOVIEN GV join KHOA K on GV.MAGV = K.TRUONGKHOA

-- Q88. Tạo bảng DANHSACHTHIDUA (magv, sodtdat, danhhieu) gồm thông tin mã giáo viên, số đề tài họ tham gia đạt kết quả và danh hiệu thi đua:
--      a. Insert dữ liệu cho bảng này (để trống cột danh hiệu)
--      b. Dựa vào cột sldtdat (số lượng đề tài tham gia có kết quả là “đạt”) để cập nhật dữ liệu cho cột danh hiệu theo quy định:
--          i. Sodtdat = 0 thì danh hiệu “chưa hoàn thành nhiệm vụ”
--          ii. 1 <= Sodtdat <= 2 thì danh hiệu “hoàn thành nhiệm vụ”
--          iii. 3 <= Sodtdat <= 5 thì danh hiệu “tiên tiến”
--          iv. Sodtdat >= 6 thì danh hiệu “lao động xuất sắc”

-- Q89. Cho biết magv, họ tên và mức lương các giáo viên nữ của khoa “Công nghệ thông tin”, mức lương trung bình, mức lương lớn nhất và nhỏ nhất của các giáo viên này.

-- Q90. Cho biết makhoa, tenkhoa, số lượng gv từng khoa, số lượng gv trung bình, lớn nhất và nhỏ nhất của các khoa này.

-- Q91. Cho biết danh sách các tên chủ đề, kinh phí cho chủ đề (là kinh phí cấp cho các đề tài thuộc chủ đề), tổng kinh phí, kinh phí lớn nhất và nhỏ nhất cho các chủ đề.

-- Q92. Cho biết madt, tendt, kinh phí đề tài, mức kinh phí tổng và trung bình của các đề tài này theo từng giáo viên chủ nhiệm.

-- Q93. Cho biết madt, tendt, kinh phí đề tài, mức kinh phí tổng và trung bình của các đề tài này theo từng cấp độ đề tài.

-- Q94. Tổng hợp số lượng các đề tài theo (cấp độ, chủ đề), theo (cấp độ), theo (chủ đề).

-- Q95. Tổng hợp mức lương tổng của các giáo viên theo (bộ môn, phái), theo (bộ môn).

-- Q96. Tổng hợp số lượng các giáo viên của khoa CNTT theo (bộ môn, lương), theo (bộ môn), theo (lương).


