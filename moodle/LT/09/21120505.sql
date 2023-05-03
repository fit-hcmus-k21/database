-- cơ sở dữ liệu super sea game

-- 1. Cho biết số lần các cặp đội thi đấu cùng nhau
select MaDoi1, MaDoi2, count(*) as SoLanThiDau
from TRANDAU
group by MaDoi1, MaDoi2

-- 2. Cho biết số trận đấu diễn ra tại mỗi sân vận động
select SanVD, count(*) as SoTran
from TRANDAU
group by SanVD

-- 3. Cho biết sân vận động nào diễn ra nhiều trận đấu nhất
select SanVD as SanVD_NhieuTranNhat
from TRANDAU
group by SanVD
having count(*) = (select top 1 count(*)
                  from TRANDAU
                  group by SanVD)

-- 4. Cho biết cầu thủ nào từng tham gia ở cả hai vị trí tiền đạo và tiền vệ
select TG.MaSo, TG.HoTen, TG.MaDoi
from (select MaSo, HoTen, MaDoi
      from THAMGIA
      where ViTriThiDau = N'Tiền Đạo') as T1 join (select MaSo, HoTen, MaDoi
                                                  from THAMGIA
                                                  where ViTriThiDau = N'Tiền Vệ') as T2
on T1.MaSo = T2.MaSo and T1.MaDoi = T2.MaDoi join THAMGIA TG on T1.MaSo = TG.MaSo and T1.MaDoi = TG.MaDoi
group by TG.MaSo, TG.MaDoi, TG.HoTen

-- 5. Cho biết đội nào đã thi đấu qua tất cả các sân vận động
select MaDoi
from ((select MaDoi1 as MaDoi, SanVD
      from TRANDAU) UNION (select MaDoi2 as MaDoi, SanVD
                                  from TRANDAU)) as TD
group by MaDoi
having count(distinct SanVD) = (select count(distinct SanVD)
                                from TRANDAU)