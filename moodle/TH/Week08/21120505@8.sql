-- Viết các stored procedure --

-- P1. Xuất ra toàn bộ danh sách giáo viên.
create procedure SP_PrintDSGV
as 
		select * from GIAOVIEN 
go

exec SP_PrintDSGV
go

-- P2. Tính số lượng đề tài mà một giáo viênđang thực hiện. 
create procedure SP_CountSLDT
					@MaGV char(3),
					@SLDT int out
as
BEGIN
	set @SLDT = (select count(distinct MADT) from THAMGIADT where MAGV = @MaGV group by MAGV )
END
go

declare @SL int
exec SP_CountSLDT '001', @SL out
print @SL
go

-- P3. In thông tin chi tiết của một giáo viên(sử dụng lệnh print): Thông tin cá nhân, Số lượng đề tài tham gia, Số lượng thân nhân của giáo viên đó.
create procedure SP_PrintInfoGV
				@MaGV char(3)
as
BEGIN
	declare @sldt int
	declare @sltn int

	if (exists (select * from GIAOVIEN where MAGV = @MaGV))
	BEGIN
		-- Lấy thông tin đưa vào bảng tạm
		select * 
		into #TEMP
		from GIAOVIEN
		where MAGV = @MaGV 

		-- Đếm sldt tham gia và số thân nhân
		set @sldt = (select count(distinct MADT) from THAMGIADT TGDT where MAGV = @MaGV)
		set @sltn = (select count(*) from NGUOITHAN where MAGV = @MaGV)


		declare @temp nvarchar(30)

		PRINT N'Thông tin cá nhân của giáo viên có mã ' + @MaGV + ':'
		set @temp = (select HOTEN from #TEMP)
		PRINT N'Họ tên: ' + @temp
		set @temp = CONVERT(NVARCHAR(30), (SELECT NGAYSINH FROM #TEMP), 121)
		PRINT N'Ngày sinh: ' + @temp
		set @temp = (SELECT PHAI FROM #TEMP)
		PRINT N'Giới tính: ' + @temp
		set @temp = (SELECT DIACHI FROM #TEMP)
		PRINT N'Địa chỉ: ' + @temp
		PRINT N'Số lượng đề tài tham gia: ' + convert(nchar(10),@sldt)
		PRINT N'Số lượng thân nhân: ' + convert(nchar(10), @sltn)

		DROP TABLE #TEMP

	END
	else print N'Không tồn tại giáo viên ' + @MaGV
	
END
go

exec SP_PrintInfoGV '007'
go

-- P4. Kiểm tra xem một giáo viên có tồn tại hay không (dựa vào HOTEN, NGSINH, DIACHI).
create procedure SP_CheckExistsGV 
				@hoten nvarchar(30),
				@ngaysinh nchar(10),
				@diachi nvarchar(40)
AS
BEGIN
	select MAGV 
	into #TEMP
	from GIAOVIEN 
	where HOTEN = @hoten and DIACHI = @diachi and NGAYSINH = convert(date, @ngaysinh)

	if (select count(*) from #TEMP ) = 0 print N'Không tồn tại giáo viên có họ tên: ' + @hoten + N', Ngày sinh: ' + @ngaysinh + N', Địa chỉ: ' + @diachi
	else print N'Tồn tại giáo viên có họ tên: ' + @hoten + N', Ngày sinh: ' + @ngaysinh + N', Địa chỉ: ' + @diachi
	
	drop table #TEMP
END
go

exec SP_CheckExistsGV N'Nguyễn Hoài An', '1973-02-15',N'25/3 Lạc Long Quân, Q.10, TP HCM' 
go
exec SP_CheckExistsGV N'Nguyễn Hoài Nam', '1973-02-15',N'25/3 Lạc Long Quân, Q.10, TP HCM' 
go



-- P5. Kiểm tra quy định của một giáo viên: Chỉ được thực hiện các đề tài cùng bộ môn với giáo viên làm chủ nhiệm đề tài đó..
create procedure SP_CheckQDTGDT 
				@magv char(3),
				@madt char(3),
				@canJoin int out
AS
BEGIN
	if (@madt in (select MADT as CAC_DT_DUOC_TG
				from DETAI DT join GIAOVIEN GV on DT.GVCNDT = GV.MAGV
				where MABM = (select MABM from GIAOVIEN where MAGV = @magv)
				)) set @canJoin = 1 else set @canJoin = 0

END
go

declare @canJoin int
exec SP_CheckQDTGDT '008','005', @canJoin out
print @canJoin
go



-- P6. Thực hiện thêm một phân công cho giáo viên thực hiện một công việc của đề tài:
--     Kiểm tra thông tin đầu vào hợp lệ: giáo viên phải tồn tại, công việc phải tồn tại, thời gian tham gia phải >0 
--     Giáo viên chỉ tham gia đề tài cùng bộ môn với giáo viên làm chủ nhiệm đề tài đó..
create procedure SP_PhanCongCV 
				@magv char(3),
				@madt char(3),
				@stt int
				-- bảng THAMGIADT không có thời gian tham gia, đề bài không nói về column PHUCAP và KETQUA nên ignore 
AS
BEGIN
	-- kiểm tra giáo viên tồn tại hay không, công việc tồn tại hay không
	if (not exists (select * from GIAOVIEN where MAGV = @magv)) 
	BEGIN
		raiserror(N'Lỗi: Giáo viên không tồn tại !', 16, 1)
		RETURN
	END

	if (not exists (select * from CONGVIEC where MADT = @madt and STT = @stt))
	BEGIN
		raiserror(N'Lỗi: Công việc không tồn tại !', 16, 1)
		RETURN
	END

	-- Kiểm tra chỉ tham gia đề tài cùng bộ môn với giáo viên làm chủ nhiệm đề tài đó..
	declare @canJoin int 
	exec SP_CheckQDTGDT @magv, @madt, @canJoin out
	if @canJoin = 0 
	BEGIN
		raiserror(N'Lỗi: Giáo viên chỉ được tham gia đề tài cùng bộ môn với giao viên làm chủ nhiệm đề tài đó', 16, 1)
		RETURN
	END

	-- Thêm công việc 
	insert into THAMGIADT (MAGV, MADT, STT) values(@magv, @madt, @stt)
	print N'Thêm công việc thành công !'

END
go

exec SP_PhanCongCV '009','007','001'
exec SP_PhanCongCV '008','005','001'
exec SP_PhanCongCV '003','006','001'
exec SP_PhanCongCV '006','006','001'
go		

-- P7. Thực hiện xoá một giáo viên theo mã. Nếu giáo viên có thông tin liên quan (Có thân nhân, có làm đề tài, …) thì báo lỗi.
create procedure SP_DeleteGVWithID 
				@magv char(3)
AS
BEGIN
	-- Kiểm tra thông tin các bảng có liên quan 
	declare @haveError int
	set @haveError = 0
	if not exists (select * from GIAOVIEN where MAGV = @magv) 
	BEGIN
		raiserror(N'Lỗi: Giáo viên không tồn tại !', 16, 1) 
		set @haveError = 1
	END

	if exists (select * from BOMON where TRUONGBM = @magv) 
			Begin
				raiserror(N'Lỗi: Giáo viên có thông tin liên quan bảng BOMON !', 16, 1) 
				set @haveError = 1
			End
	if exists (select * from KHOA where TRUONGKHOA = @magv) 
			Begin
				raiserror(N'Lỗi: Giáo viên có thông tin liên quan bảng KHOA !', 16, 1) 
				set @haveError = 1
			End
	if exists (select * from GV_DT where MAGV = @magv) 
			Begin
				raiserror(N'Lỗi: Giáo viên có thông tin liên quan bảng GV_DT !', 16, 1) 
				set @haveError = 1
			End
	if exists (select * from THAMGIADT where MAGV = @magv)  
			Begin
				raiserror(N'Lỗi: Giáo viên có thông tin liên quan bảng THAMGIADT !', 16, 1) 
				set @haveError = 1
			End
	if exists (select * from NGUOITHAN where MAGV = @magv) 
			Begin
				raiserror(N'Lỗi: Giáo viên có thông tin liên quan bảng NGUOITHAN !', 16, 1) 
				set @haveError = 1
			End
	if exists (select * from DETAI where GVCNDT = @magv)  
			Begin
				raiserror(N'Lỗi: Giáo viên có thông tin liên quan bảng DETAI !', 16, 1) 
				set @haveError = 1
			End
	
	if @haveError = 1 RETURN

	DELETE from GIAOVIEN where MAGV = @magv
	print N'Xóa giáo viên ' + @magv + N' thành công !'
END
go

exec SP_DeleteGVWithID '001'
go

-- P8. In ra danh sách giáo viên của một phòng ban nào đó cùng với số lượng đề tài mà giáo viên tham gia, số thân nhân, số giáo viên mà giáo viên đó quản lý nếu có, …
create procedure SP_PrintInfoAnyRoom 
				@phong char(3)
AS
BEGIN
	-- Kiểm tra phòng ban có tồn tại không
	if not exists (select * from BOMON where PHONG = @phong) 
	BEGIN
		raiserror(N'Lỗi: Phòng không tồn tại', 16, 1)
		return
	END
	declare @tenbm nvarchar(30)
	set @tenbm = (select TENBM from BOMON where PHONG = @phong)
	print N'Thông tin giáo viên thuộc phòng ban ' + @phong +N' - Bộ môn ' + @tenbm

	-- Lấy ra MAGV, HOTEN , MABM của các giảng viên thuộc phòng ban và lưu vào bảng tạm
	declare @mabm nvarchar(5)
	set @mabm = (select MABM from BOMON where PHONG = @phong)

	select MAGV, HOTEN, MABM
	into #TEMP
	from GIAOVIEN
	where MABM = @mabm

	select MAGV, HOTEN, (select count(distinct MADT) from THAMGIADT where MAGV = T.MAGV) as SLDTTG, (select count(*) from NGUOITHAN where MAGV = T.MAGV) as SoThanNhan, (select count(*) from GIAOVIEN where GVQLCM = T.MAGV) as SoGVQL
	from #TEMP T

	drop table #TEMP

END
go

exec SP_PrintInfoAnyRoom 'B15'
exec SP_PrintInfoAnyRoom 'B13'
exec SP_PrintInfoAnyRoom 'B16'
go

-- P9. Kiểm tra quy định của 2 giáo viên a, b: Nếu a là trưởng bộ môn của b thì lương của a phải cao hơn lương của b. (a, b: mã giáo viên)
create procedure SP_CheckQD_2GV 
				@magv1 char(3),
				@magv2 char(3)
AS 
BEGIN

	if @magv1 = @magv2 
	Begin
		raiserror(N'Lỗi: mã bộ môn của hai giáo viên phải khác nhau', 16,1)
		return
	End

	-- Tìm trưởng bộ môn của a và b
	declare @TruongBM_a char(3)
	declare @TruongBM_b char(3)

	set @TruongBM_a = (select TRUONGBM from BOMON where MABM = (select MABM from GIAOVIEN where MAGV = @magv1))
	set @TruongBM_b = (select TRUONGBM from BOMON where MABM = (select MABM from GIAOVIEN where MAGV = @magv2))

	if @TruongBM_a = @magv2
	BEGIN
		if (select LUONG from GIAOVIEN where MAGV = @magv1)  >= (select LUONG from GIAOVIEN where MAGV = @magv2) 
		BEGIN
			raiserror(N'Lỗi: Lương của giáo viên thứ 2 phải > Lương của giáo viên thứ 1', 16, 1)
			return 
		END
	END

	if @TruongBM_b = @magv1
	BEGIN
		if (select LUONG from GIAOVIEN where MAGV = @magv1)  <= (select LUONG from GIAOVIEN where MAGV = @magv2) 
		BEGIN
			raiserror(N'Lỗi: Lương của giáo viên thứ 1 phải > Lương của giáo viên thứ 2', 16, 1)
			return 
		END
	END

	print N'Thỏa quy định lương của trưởng bộ môn lớn hơn lương của giáo viên thuộc bộ môn đó !'

END
go

exec SP_CheckQD_2GV '002', '003'
exec SP_CheckQD_2GV '001', '009'
go

-- P10. Khi thêm một giáo viên cần kiểm tra các quy định: Không trùng tên, tuổi > 18, lương > 0
create procedure SP_CheckAddGV 
				@hoten nvarchar(30),
				@ngaysinh nchar(10),
				@luong int
AS
BEGIN

	if exists (select * from GIAOVIEN where HOTEN = @hoten) 
	BEGIN
		raiserror(N'Lỗi: Trùng họ tên với giáo viên trong bảng !', 16, 1)
		return 
	END

	declare @birthday date
	set @birthday = convert(date, @ngaysinh)
	if year(getdate()) - year(@birthday) <= 18 
	BEGIN
		raiserror(N'Lỗi: Tuổi phải > 18 !', 16, 1)
		return 
	END

	if @luong <= 0 
	BEGIN
		raiserror(N'Lỗi: Lương phải > 0 !', 16, 1)
		return 
	END

	print N'Thông tin giáo viên cần thêm hợp lệ !'

END
go

exec SP_CheckAddGV  N'Nguyễn Hoài An', '2003-5-19', '0'
exec SP_CheckAddGV  N'Nguyễn Hoài Nam', '2003-5-19', '-5'
exec SP_CheckAddGV  N'Nguyễn An Nan', '2003-5-19', '1'
exec SP_CheckAddGV  N'Nguyễn Thanh An', '2011-5-19', '0'
go


-- P11. Mã giáo viên được phát sinh tự động theo quy tắc: Nếu đã có giáo viên 001, 002, 003 thì MAGV của giáo viên mới sẽ là 004. Nếu đã có giáo viên 001, 002, 005 thì MAGV của giáo viên mới là 003.
create procedure SP_GenerateMAGV 
				@magv char(3) out
AS
BEGIN
	declare @found int 
	set @found = 0

	declare @temp nchar(3)
	set @temp = '001'

	while @found != 1
	BEGIN
		if exists (select * from GIAOVIEN where MAGV = @temp) 
		BEGIN
			declare @nextNumber int
			set @nextNumber = cast(@temp as int) + 1
			set @temp = (select format(@nextNumber, '000'))
		END
		else 
		BEGIN
			set @magv = @temp
			set @found = 1
		END
	END
END
go

declare @magv char(3)
exec SP_GenerateMAGV @magv out
print @magv
go



-------------------P2 | Bài tập về nhà -----------------------

-- 1:
create procedure spDatPhong
				@makh char(5),
				@maphong char(5),
				@ngaydat date
AS
BEGIN
	-- Kiểm tra mã khách hàng phải hợp lệ
	if not exists (select * from KHACH where MaKH = @makh) 
	Begin
		raiserror(N'Lỗi: Mã Khách hàng không hợp lệ, không tồn tại trong bảng KHACH !', 16, 1)
		return
	End

	-- Kiểm tra mã phòng hợp lệ
	if not exists (select * from PHONG where MaPhong = @maphong)
	Begin
		raiserror(N'Lỗi: Mã Khách phòng không hợp lệ, không tồn tại trong bảng PHONG !', 16, 1)
		return
	End

	-- Chỉ được đặt phòng nếu tình trạng phòng rảnh
	if (select TinhTrang from PHONG where MaPhong = @maphong) = N'Bận'
	Begin
		raiserror(N'Lỗi: Tình trạng phòng bận, đã được đặt trước! ', 16, 1)
		return
	End

	-- Đặt phòng
	--			Tạo mã đặt phòng 
	declare @id int
	set @id = (select MAX(Ma) from DATPHONG) + 1
	
	-- Ghi nhận thông tin đặt hàng xuống CSDL
	insert into DATPHONG (Ma, MaKH, MaPhong, NgayDP) values (@id, @makh, @maphong, @ngaydat)

	-- Cập nhật tình trạng phòng bận
	update PHONG
	set TinhTrang = N'Bận' 
	where MaPhong = @maphong
	
END
go


-- 2:
create procedure spTraPhong
				@madp int,
				@makh char(5)
AS
BEGIN
	-- Kiểm tra tính hợp lệ của mã đặt phòng, mã KH
	if not exists (select * from DATPHONG where Ma = @madp and MaKH = @makh) 
	Begin
		raiserror(N'Lỗi: không có thông tin đặt phòng', 16, 1)
		return
	End
	-- Ngày trả phòng là ngày hiện hành
	declare @ngaytra date
	set @ngaytra = getdate()

	-- Tiền thanh toán được tính theo công thức: Tien = So ngay * Don gia
	declare @songay int
	declare @dongia int
	
	set @dongia = (select DonGia from PHONG where MaPhong = (select MaPhong from DATPHONG where Ma = @madp))
	set @songay = day(@ngaytra) - day(select NgayDP from DATPHONG where Ma = @madp)

	declare @TongTien int
	set @TongTien = @dongia * @songay

	-- Cập nhật thông tin trả phòng vào database
		update DATPHONG
		set NgayTra = @ngaytra and ThanhTien = @TongTien
		where Ma = @madp

	-- Cập nhật tình trạng rảnh
	UPDATE PHONG 
	set TinhTrang = N'Rảnh'
	where MaPhong = (select MaPhong from DATPHONG where Ma = @madp)

END
go