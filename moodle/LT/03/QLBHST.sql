use thanhngan22
go


create database QLBHST
go

use QLBHST
go

create table LoaiSP (
    MaLoai char(1),
    TenLoai nvarchar(30),
    primary key (MaLoai)
)
go

create table SanPham (
    MaSP char(4) not null,
    TenSP nvarchar(50),
    GiaTien int,
    SoLuongTon int,
    DonViTinh nvarchar(10),
    MaLoai char(1),
    primary key (MaSP),
    foreign key (MaLoai) references LoaiSP(MaLoai)
)
go

create table KhachHang (
    MaKH char (4) not null,
    HoTen nvarchar(50),
    DiaChi nvarchar(50),
    DienThoai char(11),
    NamSinh char(4),
    GioiTinh nvarchar(3),
    primary key (MaKH)
)
go

create table HoaDon (
    MaHD char(4) not null,
    NgayLap date,
    MaKH char(4),
    primary key (MaHD),
    foreign key (MaKH) references KhachHang(MaKH)
)
go

create table ChiTietHD (
    MaHD char(4),
    MaSP char(4),
    SoLuong int,
    DonGia int,
    primary key(MaHD, MaSP),
    foreign key (MaHD) references HoaDon(MaHD),
    foreign key (MaSP) references SanPham(MaSP)
)
go 


-- insert data

insert into LoaiSP values('A', N'Đồ dùng');
insert into LoaiSP values('B', N'Nồi cơm điện')
insert into LoaiSP values('C', N'Đèn điện')
go

insert into SanPham values('SP01', N'Bột giặc Omo', 30, 70, N'túi', 'A');
insert into SanPham values('SP02', N'Bột giặc Tide', 25, 200, N'túi', 'A');
insert into SanPham values('SP03', N'Đèn bàn Rạng Đông', 100, 90, N'túi', 'C');
insert into SanPham values('SP04', N'Nồi cơm điện SHARP 3041', 2500, 10, N'cái', 'B');
insert into SanPham values('SP05', N'Bàn chải đánh răng PS', 12, 12, N'cái', 'A');
insert into SanPham values('SP06', N'Nồi cơm điện PANASONIC 2097', 2000, 8, N'cái', 'B');
insert into SanPham values('SP07', N'Bàn chải đánh răng Colgate', 16, 100, N'cái', 'A');
go

insert into KhachHang values('KH01', N'Nguyễn Thanh Tùng', N'Hồ Chí Minh', '9-9091-2233', 1984, 'Nam');
insert into KhachHang values('KH02', N'Lê Nhật Nam', N'Hồ Chí Minh', '9-1234-2134', 1972, N'Nữ');
insert into KhachHang values('KH03', N'Nguyễn Thị Thanh', N'Cà Mau', '9-2222-3333', 1981, N'Nữ');
insert into KhachHang values('KH04', N'Lê Thị Lan', N'Bình Dương', '9-1111-1111', 1984, N'Nữ');
insert into KhachHang values('KH05', N'Trần Minh Quang', N'Đồng Nai', '9-2222-5555', 1984, 'Nam');
insert into KhachHang values('KH06', N'Lê Văn Hải', N'Hồ Chí Minh', '9-1234-4321', 1970, 'Nam');
insert into KhachHang values('KH07', N'Dương Văn Hai', N'Đồng Nai', '9-1111-0000', 1988, 'Nam');
go

insert into HoaDon values('HD01', '2011-03-20', 'KH01');
insert into HoaDon values('HD02', '2011-02-15', 'KH02');
insert into HoaDon values('HD03', '2011-01-18', 'KH05');
insert into HoaDon values('HD04', '2010-09-16', 'KH01');
insert into HoaDon values('HD05', '2011-02-27', 'KH02');
go 

insert into ChiTietHD values('HD01', 'SP01', 2, 30);
insert into ChiTietHD values('HD01', 'SP02', 2, 25);
insert into ChiTietHD values('HD02', 'SP01', 3, 30);
insert into ChiTietHD values('HD03', 'SP02', 3, 25);
insert into ChiTietHD values('HD03', 'SP03', 1, 90);
insert into ChiTietHD values('HD03', 'SP01', 3, 30);
insert into ChiTietHD values('HD04', 'SP04', 1, 2400);
insert into ChiTietHD values('HD05', 'SP06', 1, 2000);
insert into ChiTietHD values('HD05', 'SP01', 5, 30);
go 
