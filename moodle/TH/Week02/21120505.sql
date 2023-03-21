-- Create database Quan Ly Giao Vien Tham Gia De Tai --
use thanhngan22
go

drop database QLGV;
go

create database QLGV;
go

use QLGV 
go

-- create table GiaoVien --
create table GIAOVIEN (
    MAGV char(3) not null,
    HOTEN nvarchar(30),
    LUONG float,
    PHAI nvarchar(3),
    NGAYSINH datetime,
    DIACHI nvarchar(40),
    GVQLCM char(3),
    MABM nvarchar(8)

    primary key (MAGV)
)
go

-- create table GV_DT -- 
create table GV_DT (
    MAGV char(3) not null,
    DIENTHOAI nchar(10) not null

    primary key (MAGV, DIENTHOAI)
)
go


-- create table Khoa --
create table KHOA (
    MAKHOA nchar(5) not null,
    TENKHOA nvarchar(30),
    NAMTL nchar(4),
    PHONG char(3),
    DIENTHOAI nchar(10),
    TRUONGKHOA char(3),
    NGAYNHANCHUC datetime

    primary key(MAKHOA)
)
go

-- create table BoMon --
create table BOMON (
    MABM nvarchar(8) not null,
    TENBM nvarchar(30),
    PHONG char(3),
    DIENTHOAI nchar(10),
    TRUONGBM char(3),
    MAKHOA nchar(5),
    NGAYNHANCHUC datetime

    primary key (MABM)
)
go

-- create table DeTai  --
create table DETAI (
    MADT char (3) not null,
    TENDT nvarchar(40),
    CAPQL nvarchar(20),
    KINHPHI float,
    NGAYBD datetime,
    NGAYKT datetime,
    MACD varchar(8),
    GVCNDT char(3)

    primary key(MADT)
)
go

-- create table ChuDe --
create table CHUDE (
    MACD varchar(8) not null,
    TENCD nvarchar(40)

    primary key(MACD)
)
go


-- create table CongViec --
create table CONGVIEC (
    MADT char(3) not null,
    STT int not null,
    TENCV nvarchar(40),
    NGAYBD datetime,
    NGAYKT datetime

    primary key(MADT, STT)
)
go

-- create table ThamGiaDT --
create table THAMGIADT (
    MAGV char(3) not null,
    MADT char(3) not null,
    STT int not null,
    PHUCAP float,
    KETQUA nvarchar(8)

    primary key(MAGV, MADT, STT)
)
go

-- create table NguoiThan --
create table NGUOITHAN (
    MAGV char(3) not null,
    TEN nvarchar(8) not null,
    NGAYSINH datetime,
    PHAI nvarchar(3)

    primary key(MAGV, TEN)
)
go


-- add constraints  --

-- foreign key --
alter table BOMON 
add constraint FK_BOMON_KHOA 
foreign key (MAKHOA) references KHOA(MAKHOA)
go

alter table GIAOVIEN 
add constraint FK_GIAOVIEN_BOMON
foreign key (MABM) references BOMON(MABM)
go

alter table BOMON
add constraint FK_BOMON_GIAOVIEN
foreign key (TRUONGBM) references GIAOVIEN(MAGV)
go

alter table KHOA 
add constraint FK_KHOA_GIAOVIEN
foreign key (TRUONGKHOA) references GIAOVIEN(MAGV)
go 

alter table GIAOVIEN
add constraint FK_GIAOVIEN_GIAOVIEN
foreign key (GVQLCM) references GIAOVIEN(MAGV)
go 

alter table GV_DT
add constraint FK_GV_DT_GIAOVIEN
foreign key (MAGV) references GIAOVIEN(MAGV)
go 

alter table THAMGIADT
add constraint FK_THAMGIADT_CONGVIEC
foreign key (MADT, STT) references CONGVIEC(MADT, STT)
go

alter table THAMGIADT
add constraint FK_THAMGIADT_GIAOVIEN
foreign key (MAGV) references GIAOVIEN(MAGV)
go 

alter table CONGVIEC
add constraint FK_CONGVIEC_DETAI
foreign key (MADT) references DETAI(MADT)
go

alter table DETAI
add constraint FK_DETAI_CHUDE
foreign key (MACD) references CHUDE(MACD)
go 

alter table DETAI
add constraint FK_DETAI_GIAOVIEN
foreign key (GVCNDT) references GIAOVIEN(MAGV)
go

-- unique --

alter table CHUDE 
add constraint U_TENCD unique (TENCD)
go 

alter table DETAI 
add constraint U_TENDT unique (TENDT)
go 

-- check --

alter table GIAOVIEN 
add constraint C_PHAI check (PHAI in ('Nam', 'Nữ'))
go 


-- insert data --


-- table GIAOVIEN --
insert into  GIAOVIEN values('001', 'Nguyễn Hoài An', 2000.0, 'Nam', '1973-02-15', '25/3 Lạc Long Quân, Q.10, TP HCM', null, null);
insert into  GIAOVIEN values('002', 'Trần Trà Hương', 2500.0, 'Nữ', '1960-06-20', '125 Trần Hưng Đạo, Q.1, TP HCM', null, null);
insert into  GIAOVIEN values('003', 'Nguyễn Ngọc Ánh', 2200.0, 'Nữ', '1975-05-11', '12/21 Võ Văn Ngân Thủ Đức, TP HCM', '002', null);
insert into  GIAOVIEN values('004', 'Trương Nam Sơn', 2300.0, 'Nam', '1959-06-20', '215 Lý Thường Kiệt, TP Biên Hòa', null, null);
insert into  GIAOVIEN values('005', 'Lý Hoàng Hà', 2500.0, 'Nam', '1954-10-23', '22/5 Nguyễn Xí, Q.Bình Thạnh, TP HCM', null, null);
insert into  GIAOVIEN values('006', 'Trần Bạch Tuyết', 1500.0, 'Nữ', '1980-05-20', '127 Hùng Vương, TP Mỹ Tho', '004', null);
insert into  GIAOVIEN values('007', 'Nguyễn An Trung', 2100.0, 'Nam', '1976-06-05', '234 3/2, TP Biên Hòa', null, null);
insert into  GIAOVIEN values('008', 'Trần Trung Hiếu', 1800.0, 'Nam', '1977-08-06', '22/11 Lý Thường Kiệt, TP Mỹ Tho', '007', null);
insert into  GIAOVIEN values('009', 'Trần Hoàng Nam', 2000.0, 'Nam', '1975-11-22', '234 Trấn Não, An Phú, TP HCM', '001', null);
insert into  GIAOVIEN values('010', 'Phạm Nam Thanh', 1500.0, 'Nam', '1980-12-12', '221 Hùng Vương, Q.5, TP HCM', '007', null);
go


-- table KHOA --
insert into KHOA values('CNTT', 'Công nghệ thông tin', '1995', 'B11', '0838123456', '002', '2005-02-20');
insert into KHOA values('HH', 'Hóa học', '1980', 'B41', '0838456456', '007', '2001-10-15');
insert into KHOA values('SH', 'Sinh học', '1980', 'B31', '0838454545', '004', '2000-10-11');
insert into KHOA values('VL', 'Vật lý', '1976', 'B21', '0838223223', '005', '2003-09-18');
go

-- table BOMON --
insert into BOMON values('CNTT', 'Công nghệ tri thức', 'B15', '0838126126', null, 'CNTT', null);
insert into BOMON values('HHC', 'Hóa hữu cơ', 'B44', '0838222222', null, 'HH', null);
insert into BOMON values('HL', 'Hóa lý', 'B42', '0838878787', null, 'HH', null);
insert into BOMON values('HPT', 'Hóa phân tích', 'B43', '0838777777', '007', 'HH', '2007-10-15');
insert into BOMON values('HTTT', 'Hệ thống thông tin', 'B13', '0838125125', '002', 'CNTT', '2004-09-20');
insert into BOMON values('MMT', 'Mạng máy tính', 'B16', '0838676767', '001', 'CNTT', '2005-05-15');
insert into BOMON values('SH', 'Sinh hóa', 'B33', '0838898989', null, 'SH', null);
insert into BOMON values('VLĐT', 'Vật lý điện tử', 'B23', '0838234234', null, 'VL', null);
insert into BOMON values('VLUD', 'Vật lý ứng dụng', 'B24', '0838454545', '005', 'VL', '2006-02-18');
insert into BOMON values('VS', 'Vi sinh', 'B32', '0838909090', '004', 'SH', '2007-01-01');
go

-- update table GIAOVIEN --
update  GIAOVIEN set MABM = 'MMT' where MAGV = '001';
update  GIAOVIEN set MABM = 'HTTT' where MAGV = '002';
update  GIAOVIEN set MABM = 'HTTT' where MAGV = '003';
update  GIAOVIEN set MABM = 'VS' where MAGV = '004';
update  GIAOVIEN set MABM = 'VS' where MAGV = '005';
update  GIAOVIEN set MABM = 'VLĐT' where MAGV = '006';
update  GIAOVIEN set MABM = 'VS' where MAGV = '007';
update  GIAOVIEN set MABM = 'HPT' where MAGV = '008';
update  GIAOVIEN set MABM = 'MMT' where MAGV = '009';
update  GIAOVIEN set MABM = 'HPT' where MAGV = '010';
go

-- table GV_DT --
insert into GV_DT values('001', '0838912112');
insert into GV_DT values('001', '0903123123');
insert into GV_DT values('002', '0913454545');
insert into GV_DT values('003', '0838121212');
insert into GV_DT values('003', '0903656565');
insert into GV_DT values('003', '0937125125');
insert into GV_DT values('006', '0937888888');
insert into GV_DT values('008', '0653717171');
insert into GV_DT values('008', '0913232323');
go

-- table NGUOITHAN --
insert into NGUOITHAN values('001', 'Hùng', '1990-01-14', 'Nam');
insert into NGUOITHAN values('001', 'Thủy', '1994-12-08', 'Nữ');
insert into NGUOITHAN values('003', 'Hà', '1998-09-03', 'Nữ');
insert into NGUOITHAN values('003', 'Thu', '1998-09-03', 'Nữ');
insert into NGUOITHAN values('007', 'Mai', '2003-03-26', 'Nữ');
insert into NGUOITHAN values('007', 'Vy', '2000-02-14', 'Nữ');
insert into NGUOITHAN values('008', 'Nam', '1991-05-06', 'Nam');
insert into NGUOITHAN values('009', 'An', '1996-08-19', 'Nam');
insert into NGUOITHAN values('010', 'Nguyệt', '2006-01-14', 'Nữ');
go


-- table CHUDE --
insert into CHUDE values('NCPT', 'Nghiên cứu phát triển');
insert into CHUDE values('QLGD', 'Quản lý giáo dục');
insert into CHUDE values('UDCN', 'Ứng dụng công nghệ');
go 


-- table DETAI --
insert into DETAI values('001', 'HTTT quản lý các trường ĐH', 'ĐHQG', 20.0, '2007-10-20', '2008-10-20', 'QLGD', '002');
insert into DETAI values('002', 'HTTT quản lý giáo vụ cho một khoa', 'Trường', 20.0, '2000-10-12', '2001-10-12', 'QLGD', '002');
insert into DETAI values('003', 'Nghiên cứu chế tạo sợi Nanô Platin', 'ĐHQG', 300.0, '2008-05-15', '2010-05-15', 'NCPT', '005');
insert into DETAI values('004', 'Tạo vật liệu sinh học bằng màng ối người', 'Nhà nước', 100.0, '2007-01-01', '2009-12-31', 'NCPT', '004');
insert into DETAI values('005', 'Ứng dụng hóa học xanh', 'Trường', 200.0, '2007-10-20', '2004-12-10', 'UDCN', '007');
insert into DETAI values('006', 'Nghiên cứu tế bào gốc', 'Nhà nước', 4000.0, '2007-10-20', '2009-10-20', 'NCPT', '004');
insert into DETAI values('007', 'HTTT quản lý thư viện ở các trường ĐH', 'Trường', 20.0, '2009-05-10', '2010-05-10', 'QLGD', '001');
go




-- table CONGVIEC ---
insert into CONGVIEC values('001', 1, 'Khởi tạo và Lập kế hoạch', '2007-10-20', '2008-12-20');
insert into CONGVIEC values('001', 2, 'Xác định yêu cầu', '2008-12-21', '2008-03-21');
insert into CONGVIEC values('001', 3, 'Phân tích hệ thống', '2008-03-22', '2008-05-22');
insert into CONGVIEC values('001', 4, 'Thiết kế hệ thống', '2008-05-23', '2008-06-23'); 
insert into CONGVIEC values('001', 5, 'Cài đặt thử nghiệm', '2008-06-24', '2008-10-20'); 
insert into CONGVIEC values('002', 1, 'Khởi tạo và lập kế hoạch', '2009-05-10', '2009-07-10'); 
insert into CONGVIEC values('002', 2, 'Xác định yêu cầu', '2009-07-11', '2009-10-11'); 
insert into CONGVIEC values('002', 3, 'Phân tích hệ thống', '2009-10-12', '2009-12-20'); 
insert into CONGVIEC values('002', 4, 'Thiết kế hệ thống', '2009-12-21', '2010-03-22'); 
insert into CONGVIEC values('002', 5, 'Cài đặt thử nghiệm', '2010-03-23', '2010-05-10'); 
insert into CONGVIEC values('006', 1, 'Lấy mẫu', '2006-10-20', '2007-02-20'); 
insert into CONGVIEC values('006', 2, 'Nuôi cấy', '2007-02-21', '2008-08-21'); 
go


-- table THAMGIADT --
insert into THAMGIADT values('001', '002', 1, 0.0, null);
insert into THAMGIADT values('001', '002', 2, 2.0, null);
insert into THAMGIADT values('002', '001', 4, 2.0, 'Đạt');
insert into THAMGIADT values('003', '001', 1, 1.0, 'Đạt');
insert into THAMGIADT values('003', '001', 2, 0.0, 'Đạt');
insert into THAMGIADT values('003', '001', 4, 1.0, 'Đạt');
insert into THAMGIADT values('003', '002', 2, 0.0, null);
insert into THAMGIADT values('004', '006', 1, 0.0, 'Đạt');
insert into THAMGIADT values('004', '006', 2, 1.0, 'Đạt');
insert into THAMGIADT values('006', '006', 2, 1.5, 'Đạt');
insert into THAMGIADT values('009', '002', 3, 0.5, null);
insert into THAMGIADT values('009', '002', 4, 1.5, null);
go 








