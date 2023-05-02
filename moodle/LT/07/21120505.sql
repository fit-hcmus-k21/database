-- Làm các câu từ 1 - 8

-- 1
create procedure sp1_PhanCongCV
				@magv char(3),
				@madt char(3),
				@stt int
AS
BEGIN
	if not exists (select * from GIAOVIEN where MAGV = @magv) 
	Begin
		raiserror(N'Lỗi: MaGV không tồn tại !', 16, 1)
		return
	End

	if not exists (select * from CONGVIEC where MADT = @madt and STT = @stt)
	Begin
		raiserror(N'Lỗi: Công việc không tồn tại !', 16, 1)
		return
	End

	if exists (select * from THAMGIADT where MAGV = @magv and MADT = @madt and STT = @stt)
	Begin
		raiserror(N'Lỗi: Công việc đã tham gia trước đó !', 16, 1)
		return
	End

	-- chỉ được tham gia 3 công việc của 1 đề tài
	if (select count(STT) from THAMGIADT where MAGV = @magv and MADT = @madt group by MADT ) >= 3
	Begin
		raiserror(N'Lỗi: Mỗi giảng viên chỉ được thma gia tối đa 3 công việc của 1 đề tài !', 16, 1)
		return
	End

	insert into THAMGIADT (MAGV, MADT, STT) values (@magv, @madt, @stt)
END
go


-- 2
create procedure sp2_CapNhatNgayKetThucDuAn
			@madt char(3),
			@ngayKT date
AS
BEGIN
	if not exists (select * from DETAI where MADT = @madt) 
	Begin
		raiserror(N'Lỗi: Dự án không tồn tại !', 16, 1)
		return
	End

	declare @capql nvarchar(20)
	set @capql = (select CAPQL from DETAI where MADT = @madt)

	declare @sothang int
	set @sothang = month(@ngayKT) - month((select NGAYBD from DETAI where MADT = @madt))

	if @capql = N'Trường'
	Begin
		if @sothang < 3 or @sothang > 6
		Begin
			raiserror(N'Lỗi: Đề tài cấp trường thời gian thực hiện tối thiểu 3 tháng, tối đa 6 tháng !', 16, 1)
			return
		End
	End
	else if @capql = N'ĐHQG'
	Begin
		if @sothang < 6 or @sothang > 9
		Begin
			raiserror(N'Lỗi: Đề tài cấp ĐHQG thời gian thực hiện tối thiểu 6 tháng, tối đa 9 tháng !', 16, 1)
			return
		End
	End
	else 
		Begin
			raiserror(N'Lỗi: Đề tài cấp nhà nước thời gian thực hiện tối thiểu 12 tháng, tối đa 24 tháng !', 16, 1)
			return
		End

	update DETAI
	set NGAYKT = @ngayKT
	where MADT = @madt
	
END
go

-- 3
create procedure sp3_CapNhatGVQLCM
			@magv char(3),
			@magvQLCM char(3)
AS
BEGIN
	if (select MABM from GIAOVIEN where MAGV = @magv) != (select MABM from GIAOVIEN where MAGV = @magvQLCM)
	Begin
			raiserror(N'Lỗi: Giáo viên quản lý chuyên môn phải cùng bộ môn với giáo viên đó !', 16, 1)
			return
	End
	
	update GIAOVIEN
	set GVQLCM = @magvQLCM
	where MAGV = @magv

END
go


-- 4
create procedure sp4_CapNhatTruongKhoa
				@truongkhoa char(3),
				@makhoa nchar(5)
AS
BEGIN
	declare @makhoaTK nchar(5)
	set @makhoaTK = (select MAKHOA from GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM where MAGV = @truongkhoa)

	if @makhoaTK != @makhoa
	Begin
		raiserror(N'Trưởng khoa phải cùng khoa !',16,1)
		return
	End 
	if @truongkhoa in (select TRUONGBM from BOMON) or @truongkhoa in (select GVQLCM from GIAOVIEN)
	Begin
		raiserror(N'Trưởng khoa phải không kiêm nhiệm !',16,1)
		return
	End

	update KHOA
	set TRUONGKHOA = @truongkhoa
	where MAKHOA = @makhoa

END
go

-- 5
create procedure sp5_DemSLCV_Dat
			@madt char(3),
			 @slDat int out

AS
BEGIN
	/* select MADT , (select count(*) from THAMGIADT where KETQUA = N'Đạt' and MADT = TGDT.MADT  group by MADT) as SLCV_DAT
	from THAMGIADT TGDT
	group by MADT */

	set @slDat = (select count(*) from THAMGIADT where KETQUA = N'Đạt' and MADT = @madt  group by MADT)
END
go

-- 6
create procedure sp6_DemSLCV_KhongDat
			@madt char(3),
			@slKhongDat int out

AS
BEGIN
	/* select MADT , (select count(*) from THAMGIADT where KETQUA = N'Không đạt' and MADT = TGDT.MADT  group by MADT) as SLCV_KhongDat
	from THAMGIADT TGDT
	group by MADT */

	set @slKhongDat = (select count(*) from THAMGIADT where KETQUA = N'Không đạt' and MADT = @madt  group by MADT)
END
go

-- 7
create procedure sp7_DemSLCV_ChuaCoKQ
			@madt char(3),
			@slChuaCoKQ int out

AS
BEGIN
	/* select MADT , (select count(*) from THAMGIADT where KETQUA = NULL and MADT = TGDT.MADT  group by MADT) as SLCV_ChuaCoKQ
	from THAMGIADT TGDT
	group by MADT */

	set @slChuaCoKQ = (select count(*) from THAMGIADT where KETQUA = NULL and MADT = @madt  group by MADT)
END
go

-- 8
create procedure sp8_KetQuaNghiemThuDT
			@madt char(3)

AS
BEGIN
	declare @SLDT_Dat int
	declare @SLDT_KhongDat int
	declare @SLDT_ChuaCoKQ int
	declare @TongSLDT int

	 exec sp5_DemSLCV_Dat @madt, @SLDT_Dat out 
	 exec sp6_DemSLCV_KhongDat @madt, @SLDT_KhongDat out
	 exec sp7_DemSLCV_ChuaCoKQ @madt, @SLDT_ChuaCoKQ out

	 set @TongSLDT = @SLDT_Dat + @SLDT_KhongDat + @SLDT_ChuaCoKQ

	 declare @temp nvarchar(30)

	 print N'Kết quả nghiệm thu đề tài ' + @madt + ': '
	 set @temp = convert(nchar(5), @SLDT_Dat) + '/' + convert(nchar(5), @TongSLDT)
	 print N'Tỷ lệ đạt : ' + @temp
	 set @temp = convert(nchar(5), @SLDT_KhongDat) + '/' + convert(nchar(5), @TongSLDT)
	 print N'Tỷ lệ không đạt : ' + @temp
	 set @temp = convert(nchar(5), @SLDT_ChuaCoKQ) + '/' + convert(nchar(5), @TongSLDT)
	 print N'Tỷ lệ chưa hoàn thành : ' + @temp

	 declare @percent float
	 set @percent = @SLDT_Dat / @TongSLDT
	 if @percent = 1
		print N'Xếp loại đề tài : Giỏi'
	else if @percent >= 0.8 and @SLDT_ChuaCoKQ = 0
		print N'Xếp loại đề tài : Khá'
	else if @percent = 0.7 and @SLDT_ChuaCoKQ = 0
		print N'Xếp loại đề tài : Trung bình'
	else if @percent <= 0.5 and @SLDT_ChuaCoKQ > 0
		print N'Xếp loại đề tài : Failed'

END
go