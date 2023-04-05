-- cơ sở dữ liệu quản lý du lịch

-- Tạo bảng và tạo ràng buộc khóa chính cho các bảng
create database QLDL ;
go

use QLDL;
go

create table QUOCGIA 
(
    MaQG char(10) primary key,
    TenQG nvarchar(10),
    ThuDo char(10)
)
go

create table TINH_TP 
(
    QuocGia char(10),
    MaTinhThanh char(10),
    TenTT nvarchar(30),
    SoDan int,
    DienTich float,
    DiemDLUaThichNhat char(10),
    primary key (MaTinhThanh, QuocGia)
)
go

create table DIEM_DL (
    MaDiaDiem char(10),
    TenDiaDiem nvarchar(50),
    TinhTP char(10),
    QuocGia char(10),
    DacDiem nvarchar(100),
    primary key (MaDiaDiem, TinhTP, QuocGia)
)
go


-- Tạo ràng buộc khóa ngoại và các ràng buộc dữ liệu cho các bảng
alter table TINH_TP
add constraint FK_TINH_QG foreign key (QuocGia) references QUOCGIA(MaQG);
go

alter table DIEM_DL
add constraint FK_DIEMDL_TINHTP foreign key (TinhTP) references TINH_TP(MaTinhThanh);
go

alter table DIEM_DL
add constraint FK_DIEM_QG foreign key (QuocGia) references QUOCGIA(MaQG);
go

alter table QuocGia
add constraint UTenQG unique (TenQG);
go

alter table TINH_TP
add constraint PosSoDan check (SoDan > 0);
go

alter table TINH_TP
add constraint PosDienTich check (DienTich > 0);
go

-- Nhập các dòng dữ liệu vào bảng
insert into QUOCGIA values('QG001', N'Việt Nam', 'TT001');
insert into QUOCGIA values('QG002', N'Nhật Bản', 'TT003');
go

insert into TINH_TP values('QG001', 'TT001', N'Hà Nội', 2500000, 927.39, 'DD001');
insert into TINH_TP values('QG001', 'TT002', N'Huế', 5344000, 5009, 'DD002');
insert into TINH_TP values('QG002', 'TT001', N'Tokyo', 12084000, 2187, null);
insert into TINH_TP values('QG002', 'TT002', N'Osaka', 18000000, 221.96, 'DD001');
go

insert into DIEM_DL values('DD001', N'Văn Miếu', 'TT001', 'QG001', N'Di tích cổ');
insert into DIEM_DL values('DD001', N'Hoàng Lăng', 'TT002', 'QG001', N'Di tích cổ');
insert into DIEM_DL values('DD001', N'Núi Fuji', 'TT001', 'QG002', N'Núi lửa ngưng hoạt động cao nhất Nhật Bản');
insert into DIEM_DL values('DD001', N'Minami', 'TT002', 'QG002', N'Quê hương của cây cầu Shinsaibashi');
insert into DIEM_DL values('DD002', N'Lâu đài Osaka', 'TT002', 'QG002', N'Chứa bảo tàng thông tin lịch sử của lâu đài và Toyotomi Hideyoshi');
go
