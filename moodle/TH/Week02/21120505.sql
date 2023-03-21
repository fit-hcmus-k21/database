-- Create database Quan Ly Giao Vien Tham Gia De Tai --
create database QLGV;
go

use QLGV 
go

-- create table GiaoVien --
create table GIAOVIEN {
    MAGV char(3) ,
    HOTEN nvarchar(30),
    LUONG float,
    PHAI nvarchar(3),
    NGAYSINH datetime,
    DIACHI nvarchar(40),
    GVQLCM char(3),
    MABM nvarchar(8)

    primary key (MAGV)
}
go

-- create table GV_DT -- 
create table GV_DT {
    MAGV char(3),
    DIENTHOAI nchar(10)

    primary key (MAGV, DIENTHOAI)
}
go


-- create table Khoa --
create table KHOA {
    MAKHOA nchar(5),
    TENKHOA nvarchar(30),
    NAMTL nchar(4),
    PHONG char(3),
    DIENTHOAI nchar(10),
    TRUONGKHOA char(3),
    NGAYNHANCHUC datetime

    primary key(MAKHOA)
}
go

-- create table BoMon --
create table BOMON {
    MABM nvarchar(8),
    TENBM nvarchar(30),
    PHONG char(3),
    DIENTHOAI nchar(10),
    TRUONGBM char(3),
    MAKHOA nchar(5),
    NGAYNHANCHUC datetime

    primary key (MABM)
}
go

-- create table DeTai  --
create table DETAI {
    MADT char (3),
    TENDT nvarchar(40),
    CAPQL nvarchar(20),
    KINHPHI float,
    NGAYBD datetime,
    NGAYKT datetime,
    MACD varchar(8),
    GVCNDT char(3)

    primary key(MADT)
}
go

-- create table ChuDe --
create table CHUDE {
    MACD varchar(8),
    TENCHUDE nvarchar(40)

    primary key(MACD)
}
go


-- create table CongViec --
create table CONGVIEC {
    MADT char(3),
    SOTT int,
    TENCV nvarchar(40),
    NGAYBD datetime,
    NGAYKT datetime

    primary key(MADT, STT)
}
go

-- create table ThamGiaDT --
create table THAMGIADT {
    MAGV char(3),
    MADT char(3),
    STT int,
    PHUCAP float,
    KETQUA nvarchar(8)

    primary key(MAGV, MADT, STT)
}
go

-- create table NguoiThan --
create table NGUOITHAN {
    MAGV char(3),
    TEN nvarchar(8),
    NGAYSINH datetime,
    PHAI nvarchar(3)

    primary key(MAGV, TEN)
}
go


-- add references --
alter table BOMON 
add constraint FK_BOMON_KHOA foreign key (MAKHOA) references KHOA(MAKHOA)

alter table 



-- insert data --

insert into CONGVIEC values('001', 1, 'Khởi tạo và Lập kế hoạch', '2007-10-20...',  )