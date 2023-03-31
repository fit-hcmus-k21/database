-- 1: Xác định khóa chính, khóa ngoại, các ràng buộc dữ liệu
-- DOIBONG : khóa chính là MaDoi, not null
-- TRANDAU: khóa chính là MaTD, not null
--          Khóa ngoại: MaDoi1, MaDoi2
-- THAMGIA: khóa chính là MaDoi, MaTD, MaSo, 
--           Ràng buộc: HoTen: unique, 
--           Khóa ngoại: MaDoi, MaTD

-- 2: viết sql tạo csdl
create database QLCT;
go

use QLCT;
go

create table TRANDAU
(
    MaTD char(3) not null,
    MaDoi1 char(3) not null,
    MaDoi2 char(3) not null,
    SanVD nvarchar(50),
    NgayTD date,
    ThanhPho nvarchar(50),

    primary key (MaTD),
);
go

create table DOIBONG
(
    MaDoi char(3) not null,
    TenQuocGia nvarchar(50)

    primary key (MaDoi)
);
go



create table THAMGIA
(
    MaDoi char(3) not null,
    MaTD char(3) not null,
    MaSo char(3) not null,
    PhutVaoSan int,
    PhutRoiSan int,
    HoTen nvarchar(50) unique,
    NgaySinh date,
    ViTriThiDau nvarchar(30),

    primary key (MaDoi, MaTD, MaSo),
    foreign key (MaDoi) references DOIBONG(MaDoi),
    foreign key (MaTD) references TRANDAU(MaTD)
);
go

alter table TRANDAU 
add constraint FK_MaDoi1 foreign key (MaDoi1) references DOIBONG(MaDoi);
go

alter table TRANDAU
add constraint FK_MaDoi2 foreign key (MaDoi2) references DOIBONG(MaDoi);
go


-- 3: cho biết danh sách các cầu thủ (mã đội, mã cầu thủ, họ tên, ngày sinh) 
-- đã thi đấu ở vị trí hậu vệ trong trận đấu giữa đội Việt Nam (đội nhà) và đội Thái Lan(đội khách) vào 30/04/2022
select MaDoi, MaSo, HoTen, NgaySinh
from THAMGIA TG join TRANDAU TD on TG.MaTD = TD.MaTD 
where TD.NgayTD = '2022-04-30' and ViTriThiDau = N'Hậu Vệ' and 
                                                               TD.MaDoi1 = (select MaDoi from DOIBONG where TenQuocGia = N'Việt Nam') 
                                                            and 
                                                                TD.MaDoi2 = (select MaDoi from DOIBONG where TenQuocGia = N'Thái Lan');

-- 4. Cho biết cầu thủ đã tham gia nhều trận đấu nhất
select Top 1 HoTen, count(distinct MaTD) as SoTranDaThiDau
from THAMGIA
group by HoTen, MaSo
order by SoTranDaThiDau desc;