-- Cài đặt các RBTV bằng triggers

-- T1. Tên đề tài phải duy nhất 
create trigger TR_U_TenDT
on DETAI
for insert, update
AS
if update(TENDT)
BEGIN
		if exists (select * from inserted I group by (TENDT) having count(*) > 1)
		Begin
			raiserror(N'Lỗi: Tên đề tài phải duy nhất !', 16, 1)
			rollback
		End
END
go

-- T2. Trưởng bộ môn phải sinh sau 1975 
create trigger TR_BOMON_CheckNS_TrBM
on BOMON
for update
AS
if update(TRUONGBM)
BEGIN
	if exists (select * from inserted I join GIAOVIEN GV on GV.MAGV = I.TRUONGBM where year(NGSINH) <= 1975)
	BEGIN
		raiserror(N'Lỗi: Trưởng bộ môn phải sinh sau 1975 !', 16, 1)
		rollback
	END
	
END
go

create trigger TR_GIAOVIEN_CheckNS_TrBM
on GIAOVIEN
for update
AS
if update(NGAYSINH)
BEGIN
	if exists (select * from inserted I join BOMON BM on BM.TRUONGBM = I.MAGV where year(I.NGSINH) <= 1975)
	Begin
		raiserror(N'Lỗi: Ngày sinh của trưởng bộ môn phải sau 1975 !', 16, 1)
		rollback
	End

END
go


-- T3. Một bộ môn có tối thiểu 1 giáo viên nữ
create trigger TR_T3
on GIAOVIEN
for update, delete, insert 
AS
if update(PHAI) or update(MABM) 
BEGIN
	
	
END


-- T4. Một giáo viên phải có ít nhất 1 số điện thoại 


-- T5. Một giáo viên có tối đa 3 số điện thoại 


-- T6. Một bộ môn phải có tối thiểu 4 giáo viên 


-- T7. Trưởng bộ môn phải là người lớn tuổi nhất trong bộ môn. 


-- T8. Nếu một giáo viên đã là trưởng bộ môn thì giáo viên đó không làm người quản lý chuyên môn.


-- T9. Giáo viên và giáo viên quản lý chuyên môn của giáo viên đó phải thuộc về 1 bộ môn. 


-- T10.Mỗi giáo viên chỉ có tối đa 1 vợ chồng 


-- T11.Giáo viên là Nam thì chỉ có vợ là Nữ hoặc ngược lại. 


-- T12.Nếu thân nhân có quan hệ là “con gái” hoặc “con trai” với giáo viên thì năm sinh của giáo viên phải nhỏ hơn năm sinh của thân nhân. 


-- T13.Một giáo viên chỉ làm chủ nhiệm tối đa 3 đề tài. 


-- T14.Một đề tài phải có ít nhất một công việc 


-- T15.Lương của giáo viên phải nhỏ hơn lương người quản lý của giáo viên đó. 


-- T16.Lương của trưởng bộ môn phải lớn hơn lương của các giáo viên trong bộ môn. 


-- T17.Bộ môn ban nào cũng phải có trưởng bộ môn và trưởng bộ môn phải là một giáo viên trong trường.


-- T18.Một giáo viên chỉ quản lý tối đa 3 giáo viên khác. 


-- T19.Giáo viên chỉ tham gia những đề tài mà giáo viên chủ nhiệm đề tài là người cùng bộ môn với giáo viên đó