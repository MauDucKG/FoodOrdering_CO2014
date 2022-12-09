-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 09, 2022 at 03:33 AM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `app`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_khach_hang` (IN `userKH` VARCHAR(15), IN `nameKH` VARCHAR(256), IN `adKH` VARCHAR(256), IN `phoneKH` VARCHAR(256), IN `imgKH` VARCHAR(256), IN `pointKH` INT(11))   proc_label:BEGIN
	IF (NOT EXISTS (SELECT * FROM tai_khoan WHERE tenDangNhap = userKH)) THEN
    	signal sqlstate '45000' set message_text = 'Khach hang chua co ten dang nhap';
    ELSEIF (EXISTS (SELECT * FROM khach_hang WHERE tenDangNhap = userKH) || EXISTS (SELECT * FROM nha_hang WHERE tenDangNhap = userKH)) 		THEN
    	signal sqlstate '45000' set message_text = 'Ten dang nhap da ton tai';
    ELSEIF (SELECT LENGTH(phoneKH) <> 10 || phoneKH NOT REGEXP "^0[0-9]{9}") THEN
    	signal sqlstate '45000' set message_text = 'So dien thoai bat dau bang so 0 dinh dang 10 chu so';
    ELSE
    	INSERT INTO khach_hang (tenDangNhap, tenKhachHang, diaChi, sdt, anhDaiDien, diemTichLuy) VALUES (userKH, nameKH, adKH, phoneKH, imgKH, pointKH);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_mon_an` (IN `nameMA` VARCHAR(50), IN `codeMA` VARCHAR(15), IN `desMA` VARCHAR(100), IN `priceMA` INT(11))   proc_label:BEGIN
IF (EXISTS (SELECT * FROM mon_an WHERE codeMA = maMonAn)) THEN
 signal sqlstate '45000' set message_text = 'Mã món ăn đã tồn tại';
 ELSEIF (SELECT LENGTH(codeMA) <> 4 || codeMA NOT REGEXP "^[a-zA-Z0-9]{4}") 
THEN
 signal sqlstate '45000' set message_text = 'Mã món ăn bao gồm 4 ký tự chữ hoặc số';
 ELSEIF (priceMA < 0) THEN
 signal sqlstate '45000' set message_text = 'Giá món ăn tối thiểu là 0';
 ELSE
 INSERT INTO mon_an (tenMonAn, maMonAn, moTaMonAn, giaNiemYet) VALUES 
(nameMA, codeMA, desMA, priceMA);
 END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_tai_khoan` (IN `userKH` VARCHAR(15), IN `passKH` VARCHAR(256))   proc_label:BEGIN
	IF(EXISTS (SELECT * FROM tai_khoan WHERE tenDangNhap = userKH)) THEN
    	signal sqlstate '45000' set message_text = 'Tên đăng nhập đã tồn tại';
    ELSEIF(SELECT LENGTH(passKH) < 8) THEN
    	signal sqlstate '45000' set message_text = 'Mật khẩu ít nhất 8 ký tự';
    ELSE
            INSERT INTO tai_khoan (tenDangNhap, matKhau) VALUES (userKH, passKH);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `count_mon_an` (IN `Gia_lon_hon` INT(11))   proc_label:BEGIN
	SELECT nhom_mon_an.tenNhomMonAn, Gia_lon_hon, COUNT(*) AS soLuong
    FROM (nhom_mon_an LEFT JOIN mon_an_thuoc_nhom ON mon_an_thuoc_nhom.maNhomMonAn = nhom_mon_an.maNhomMonAn)
    LEFT JOIN mon_an ON mon_an.maMonAn = mon_an_thuoc_nhom.maMonAn     
    WHERE mon_an.giaNiemYet >= Gia_lon_hon
    GROUP BY nhom_mon_an.tenNhomMonAn
    HAVING soLuong >= 1 
    ORDER BY soLuong, nhom_mon_an.tenNhomMonAn;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_khach_hang` (IN `userKH` VARCHAR(15))   proc_label:BEGIN
	IF (NOT EXISTS (SELECT * FROM khach_hang WHERE tenDangNhap = userKH)) THEN
    	signal sqlstate '45000' set message_text = 'Ten dang nhap khong ton tai';
    ELSE
    	DELETE FROM khach_hang WHERE tenDangNhap = userKH;
        DELETE FROM tai_khoan WHERE tenDangNhap = userKH;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_mon_an` (IN `codeMA` VARCHAR(15))   proc_label:BEGIN
IF (NOT EXISTS (SELECT * FROM mon_an WHERE maMonAn = codeMA)) 
THEN
 signal sqlstate '45000' set message_text = 'Mã món ăn không tồn tại';
 ELSE
 DELETE FROM mon_an WHERE maMonAn = codeMA;
 END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_tai_khoan` (IN `userKH` VARCHAR(15), IN `passKH` VARCHAR(256))   proc_label:BEGIN
	IF(NOT EXISTS (SELECT * FROM tai_khoan WHERE tenDangNhap <> userKH)) THEN
    	signal sqlstate '45000' set message_text = 'Tên đăng nhập không tồn tại';
    ELSE
    	DELETE FROM tai_khoan WHERE tenDangNhap = userKH;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Phan_loai_auto` ()   SELECT tenMonAn, giaNiemYet, Phan_loai(giaNiemYet) AS Phan_loai
FROM mon_an$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `point_khach_hang` (IN `point` INT(11))   proc_label:BEGIN
	SELECT tai_khoan.tenDangNhap, matKhau, tenKhachHang, diaChi, sdt, anhDaiDien, diemTichLuy from tai_khoan, khach_hang
    where tai_khoan.tenDangNhap = khach_hang.tenDangNhap AND point <= diemTichLuy
    order by diemTichLuy;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_khach_hang` (IN `userKH` VARCHAR(15), IN `nameKH` VARCHAR(256), IN `adKH` VARCHAR(256), IN `phoneKH` VARCHAR(256), IN `imgKH` VARCHAR(256), IN `pointKH` INT(11))   proc_label:BEGIN
	IF (NOT EXISTS (SELECT * FROM khach_hang WHERE tenDangNhap = userKH)) THEN
    	signal sqlstate '45000' set message_text = 'Ten dang nhap khong ton tai';
    ELSEIF(SELECT LENGTH(phoneKH) <> 10 || phoneKH NOT REGEXP "^0[0-9]{9}") THEN
    	signal sqlstate '45000' set message_text = 'So dien thoai bat dau bang so 0 dinh dang 10 chu so';
    ELSE
    	UPDATE khach_hang SET tenKhachHang = nameKH, diaChi = adKH, sdt = phoneKH, anhDaiDien = imgKH, diemTichLuy = pointKH WHERE tenDangNhap = userKH;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_mon_an` (IN `nameMA` VARCHAR(50), IN `codeMA` VARCHAR(15), IN `desMA` VARCHAR(100), IN `priceMA` INT(11))   proc_label:BEGIN
IF (NOT EXISTS (SELECT * FROM mon_an WHERE maMonAn = codeMA)) THEN
 signal sqlstate '45000' set message_text = 'Mã món ăn không tồn tại';
 ELSEIF (priceMA < 0) THEN
 signal sqlstate '45000' set message_text = 'Giá món ăn tối thiểu là 0';
 ELSE
 UPDATE mon_an SET tenMonAn = nameMA, moTaMonAn = desMA, giaNiemYet = 
priceMA where maMonAn = codeMA;
 END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_tai_khoan` (IN `userKH` VARCHAR(15), IN `passKH` VARCHAR(256))   proc_label:BEGIN
	IF(NOT EXISTS (SELECT * FROM tai_khoan WHERE tenDangNhap <> userKH)) THEN
    	signal sqlstate '45000' set message_text = 'Tên đăng nhập không tồn tại';
    ELSEIF(SELECT LENGTH(passKH) < 8) THEN
    	signal sqlstate '45000' set message_text = 'Mật khẩu mới ít nhất 8 ký tự';
    ELSE
    	UPDATE tai_khoan SET matKhau = passKH WHERE tenDangNhap = userKH;
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `count_dish` (`codeNMA` VARCHAR(256)) RETURNS INT(11) DETERMINISTIC proc_label:BEGIN
	IF (SELECT LENGTH(codeNMA) <> 4 || codeNMA NOT REGEXP "^[a-zA-Z0-9]{4}") THEN
 		signal sqlstate '45000' set message_text = 'Ma nhom mon an sai dinh dang (4 ky tu bao gom chu hoac so)';
    ELSEIF (NOT EXISTS (SELECT * FROM nhom_mon_an WHERE maNhomMonAn = codeNMA)) THEN
    	signal sqlstate '45000' set message_text = 'Ma nhom mon an khong ton tai';
    ELSE
        return(
            SELECT COUNT(*)
            FROM mon_an_thuoc_nhom
            WHERE maNhomMonAn = codeNMA
        );
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `phan_loai` (`codeMA` VARCHAR(15), `price` INT) RETURNS VARCHAR(12) CHARSET utf8mb4 DETERMINISTIC proc_label:BEGIN
	DECLARE Price_Level VARCHAR(12);
	IF (SELECT LENGTH(codeMA) <> 4 || codeMA NOT REGEXP "^[a-zA-Z0-9]{4}") THEN
 		signal sqlstate '45000' set message_text = 'Ma mon an sai dinh dang (4 ky tu bao gom chu hoac so)';
    ELSEIF price < 0 THEN 
    	signal sqlstate '45000' set message_text = 'Gia mon an toi thieu bang 0';
    ELSEIF (NOT EXISTS (SELECT * FROM mon_an WHERE mon_an.maMonAn = codeMA)) THEN
    	signal sqlstate '45000' set message_text = 'Ma mon an khong ton tai';
    ELSEIF (NOT EXISTS (SELECT * FROM mon_an WHERE mon_an.maMonAn = codeMA AND mon_an.giaNiemYet = price)) THEN
        signal sqlstate '45000' set message_text = 'Ma mon an va gia mon an khong trung khop';
    ELSE 
    	BEGIN
        	IF ((SELECT COUNT(*) FROM mon_an WHERE mon_an.maMonAn <> codeMA AND mon_an.giaNiemYet <= price) < (SELECT FLOOR(COUNT(*)/3) FROM mon_an)) THEN
                SET Price_Level = "Thap";                
            ELSEIF ((SELECT COUNT(*) FROM mon_an WHERE mon_an.maMonAn <> codeMA AND mon_an.giaNiemYet >= price) < (SELECT FLOOR(COUNT(*)/3) FROM mon_an)) THEN
                SET Price_Level = "Cao";
            ELSE
            	SET Price_Level = "Trung binh"; 
            END IF;
            Return (Price_Level);
    	END;
 	END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `anh_mon_an`
--

CREATE TABLE `anh_mon_an` (
  `maMonAn` varchar(15) NOT NULL,
  `anhMonAn` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `anh_mon_an`
--

INSERT INTO `anh_mon_an` (`maMonAn`, `anhMonAn`) VALUES
('M001', 'https://cdn.tgdd.vn/Files/2022/04/04/1423782/goi-y-8-mon-nguoi-khai-vi-cho-nhung-buoi-tiec-hoi-hop-voi-gia-dinh-202204040912057499.jpg'),
('M002', 'https://cdn.tgdd.vn/Files/2022/04/04/1423782/goi-y-8-mon-nguoi-khai-vi-cho-nhung-buoi-tiec-hoi-hop-voi-gia-dinh-202204040914134517.jpg'),
('M003', 'https://cdn.tgdd.vn/Files/2022/04/04/1423782/goi-y-8-mon-nguoi-khai-vi-cho-nhung-buoi-tiec-hoi-hop-voi-gia-dinh-202204040914556821.jpg'),
('M004', 'https://cdn.tgdd.vn/Files/2022/04/04/1423782/goi-y-8-mon-nguoi-khai-vi-cho-nhung-buoi-tiec-hoi-hop-voi-gia-dinh-202204040921553201.jpg'),
('M005', 'https://vn-live-05.slatic.net/p/90ceda8d45ffefa0cb930c64e18cfbe4.jpg_525x525q80.jpg'),
('M006', 'https://cdn.tgdd.vn/Files/2018/06/13/1095115/cach-nau-mi-vit-tiem-ngon-ngat-ngay-khong-khac-gi-ngoai-hang-11-760x367.jpg'),
('M007', 'https://cdn.daotaobeptruong.vn/wp-content/uploads/2021/01/mi-cay.jpg'),
('M008', 'https://cdn.baogiaothong.vn/upload/1-2022/images/2022-03-31/ramen-696x502-1648704627-794-width640height461.jpg'),
('M009', 'https://vnn-imgs-f.vgcloud.vn/2019/02/26/16/thuong-thuc-mi-lanh-banh-phu-rau-xanh-trieu-tien-giua-long-ha-noi.jpg'),
('M010', 'https://bazantravel.com/cdn/medias/uploads/74/74113-com-ga-da-nang-700x700.jpg'),
('M011', 'https://img-global.cpcdn.com/recipes/0656ee1233846265/680x482cq70/c%C6%A1m-ga-lu%E1%BB%99c-recipe-main-photo.jpg'),
('M012', 'https://cdn.daynauan.info.vn/wp-content/uploads/2015/06/com-tam-suon-bi-cha.jpg'),
('M015', 'https://danviet.mediacdn.vn/upload/3-2018/images/2018-07-09/Nhung-mon-sup-vua-dep-vua-ngon-lai-lam-cuc-nhanh-1-1531106719-width1024height1024.jpg'),
('M016', 'https://danviet.mediacdn.vn/upload/3-2018/images/2018-07-09/Nhung-mon-sup-vua-dep-vua-ngon-lai-lam-cuc-nhanh-2-1531106738-width1024height1024.jpg'),
('M017', 'https://danviet.mediacdn.vn/upload/3-2018/images/2018-07-09/Nhung-mon-sup-vua-dep-vua-ngon-lai-lam-cuc-nhanh-4-1531106770-width1024height1024.jpg'),
('M018', 'https://danviet.mediacdn.vn/upload/3-2018/images/2018-07-09/Nhung-mon-sup-vua-dep-vua-ngon-lai-lam-cuc-nhanh-8-1531106839-width1024height1024.jpg'),
('M019', 'https://thuongdinhyen.com/uploads/images/anh-san-pham/soup-bao-ngu1.jpg'),
('M020', 'https://img-global.cpcdn.com/recipes/dcc8bd30ae5bc440/680x482cq70/bun-ch%E1%BA%A3-ha-n%E1%BB%99i-recipe-main-photo.jpg'),
('M021', 'https://cdn.daynauan.info.vn/wp-content/uploads/2018/08/bun-thang.jpg'),
('M022', 'https://luhanhvietnam.com.vn/du-lich/vnt_upload/news/11_2020/bun-moc-thanh-dam-de-an.jpg'),
('M023', 'https://cdn.tgdd.vn/2020/08/CookProduct/Untitled-1-1200x676-10.jpg'),
('M024', 'https://luhanhvietnam.com.vn/du-lich/vnt_upload/news/11_2020/hai-phong-co-mon-bun-tom.jpg'),
('M025', 'https://luhanhvietnam.com.vn/du-lich/vnt_upload/news/11_2020/bun-dau-mam-tom-la-mon-dan-da.jpg'),
('M026', 'https://cdn.tgdd.vn/Files/2018/04/01/1078873/nau-bun-bo-hue-cuc-de-tai-nha-tu-vien-gia-vi-co-san-202109161718049940.jpg'),
('M027', 'https://cdn.daotaobeptruong.vn/wp-content/uploads/2020/01/banh-xeo-mien-tay.jpg'),
('M028', 'https://cdn.tgdd.vn/Files/2021/08/03/1372652/cach-lam-banh-duc-nong-ngon-khong-dung-voi-va-han-the-202206021309198116.jpeg'),
('M029', 'https://cdn.tgdd.vn/2021/12/CookRecipe/Avatar/banh-mi-chao-thap-cam-thumbnail.jpg'),
('M030', 'https://saigonangi.com/wp-content/uploads/2020/10/77-1.png'),
('M031', 'https://cdn.huongnghiepaau.com/wp-content/uploads/2017/07/cach-lam-banh-pizza-bang-chao.jpg'),
('M032', 'https://cdn.tgdd.vn/2021/08/CookRecipe/Avatar/banh-cuon-nong-thit-bam-thumbnail.jpg'),
('M033', 'https://bizweb.dktcdn.net/100/442/328/products/banh-uot-cha.jpg?v=1644836447513'),
('M013', 'https://cdn.huongnghiepaau.com/wp-content/uploads/2019/01/com-rang-kim-chi.jpg'),
('M014', 'https://yt.cdnxbvn.com/medias/uploads/209/209926-nam-xao-thit-bo.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `anh_nha_hang`
--

CREATE TABLE `anh_nha_hang` (
  `tenDangNhap` varchar(15) NOT NULL,
  `anhNhaHang` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `anh_nha_hang`
--

INSERT INTO `anh_nha_hang` (`tenDangNhap`, `anhNhaHang`) VALUES
('username1', 'https://cdn3.ivivu.com/2019/06/an-sap-top-20-quan-an-ngon-sai-gon-b%E1%BA%A1n-nhat-dinh-phai-thu-ivi'),
('username2', 'https://cdn3.ivivu.com/2019/06/an-sap-top-20-quan-an-ngon-sai-gon-b%E1%BA%A1n-nhat-dinh-phai-thu-ivi'),
('username3', 'https://cdn3.ivivu.com/2019/06/an-sap-top-20-quan-an-ngon-sai-gon-b%E1%BA%A1n-nhat-dinh-phai-thu-ivi'),
('username4', 'https://cdn3.ivivu.com/2019/06/an-sap-top-20-quan-an-ngon-sai-gon-b%E1%BA%A1n-nhat-dinh-phai-thu-ivi'),
('username5', 'https://cdn3.ivivu.com/2019/06/an-sap-top-20-quan-an-ngon-sai-gon-b%E1%BA%A1n-nhat-dinh-phai-thu-ivi'),
('username6', 'https://cdn3.ivivu.com/2019/06/an-sap-top-20-quan-an-ngon-sai-gon-b%E1%BA%A1n-nhat-dinh-phai-thu-ivi'),
('username7', 'https://cdn3.ivivu.com/2019/06/an-sap-top-20-quan-an-ngon-sai-gon-b%E1%BA%A1n-nhat-dinh-phai-thu-ivi'),
('username8', 'https://cdn3.ivivu.com/2019/06/an-sap-top-20-quan-an-ngon-sai-gon-b%E1%BA%A1n-nhat-dinh-phai-thu-ivi');

-- --------------------------------------------------------

--
-- Table structure for table `cong_ty_giao_hang`
--

CREATE TABLE `cong_ty_giao_hang` (
  `tenCongTy` varchar(50) NOT NULL,
  `maCongTy` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cong_ty_giao_hang`
--

INSERT INTO `cong_ty_giao_hang` (`tenCongTy`, `maCongTy`) VALUES
('Giao hàng nhanh', 'CT1000'),
('Giao hàng tiết kiệm', 'CT1001'),
('Grab', 'CT1002'),
('Viettel Post', 'CT1003');

-- --------------------------------------------------------

--
-- Table structure for table `danh_gia_mon_an`
--

CREATE TABLE `danh_gia_mon_an` (
  `khachHang` varchar(256) NOT NULL,
  `maMonAn` varchar(256) NOT NULL,
  `ngayDanhGia` date DEFAULT NULL,
  `soSao` int(11) DEFAULT NULL,
  `moTa` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `danh_gia_mon_an`
--

INSERT INTO `danh_gia_mon_an` (`khachHang`, `maMonAn`, `ngayDanhGia`, `soSao`, `moTa`) VALUES
('username9', 'M019', '2022-12-02', 5, 'rất ngon, thích hợp cho mọi người'),
('username10', 'M003', '2022-12-03', 5, 'Món ăn ngon, gỏi có vị chua vừa phải, mọi người nên thử.'),
('username13', 'M024', '2022-12-06', 5, 'Mang lại cảm giác lạ miệng, mọi người nên thử một lần'),
('username15', 'M027', NULL, NULL, 'Bánh giòn rụm, nước chấm rất hợp'),
('username12', 'M026', '2022-12-02', 4, 'Bún hơi cay, nhưng nhìn chung ổn, hy vọng lần sau cải thiện'),
('username9', 'M001', '2022-12-02', 5, 'Ngon, sẽ thử lại nếu có dịp.'),
('username10', 'M008', '2022-12-03', 5, 'Nước vị đậm đà, ăn rất hợp miệng.'),
('username11', 'M031', '2022-12-03', 5, 'Vị phô mai béo ngậy, bánh dày và nóng, ăn rất ngon.'),
('username12', 'M013', '2022-12-04', 4, 'Kim chi có vị chua vừa phải, rất ngon'),
('username13', 'M033', '2022-12-04', 4, 'Ổn'),
('username14', 'M012', '2022-12-06', 5, 'Cơm ngon, hợp vị.'),
('username15', 'M014', '2022-12-06', 5, 'Bò được xào kĩ, có vị ngọt nhẹ, ăn rất ngon'),
('username11', 'M017', '2022-12-06', 5, 'Ăn nhẹ rất hợp.'),
('username14', 'M020', '2022-12-06', 5, 'Rất ngon,  mọi người nên thử.'),
('username9', 'M019', NULL, 5, NULL),
('username9', 'M019', NULL, 5, NULL),
('username9', 'M019', NULL, 5, NULL),
('username9', 'M019', NULL, 5, NULL);

--
-- Triggers `danh_gia_mon_an`
--
DELIMITER $$
CREATE TRIGGER `diem_sau_danh_gia` BEFORE INSERT ON `danh_gia_mon_an` FOR EACH ROW IF(EXISTS(SELECT * FROM khach_hang WHERE tenDangNhap = new.khachHang)) THEN
   BEGIN
   IF(EXISTS(SELECT * FROM mon_an WHERE maMonAn = new.maMonAn)) THEN
       IF(new.soSao = 5) THEN
       BEGIN
       	UPDATE khach_hang
        SET diemTichLuy := diemTichLuy + 10
        WHERE tenDangNhap = new.khachHang;
       END;
       END IF;
        ELSE 
    		SIGNAL SQLSTATE	'45000' SET MESSAGE_TEXT = "Không có món ăn đó";
        END IF;
   END;
ELSE 
    SIGNAL SQLSTATE	'45000' SET MESSAGE_TEXT = "Không có khách hàng đó";
END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `doi_diem`
--

CREATE TABLE `doi_diem` (
  `khachHang` varchar(256) NOT NULL,
  `maPhieu` varchar(256) NOT NULL,
  `loaiPhieu` varchar(256) NOT NULL,
  `ngayKetThuc` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `doi_diem`
--

INSERT INTO `doi_diem` (`khachHang`, `maPhieu`, `loaiPhieu`, `ngayKetThuc`) VALUES
('username9', 'CP0001', 'Phiếu giảm giá theo phần trăm', '2022-12-30'),
('username10', 'CP0002', 'Phiếu giảm giá theo tiền', '2022-12-30'),
('username14', 'CP0003', 'Phiếu giảm giá theo phần trăm', '2022-12-06'),
('username11', 'CP0002', 'Phiếu giảm giá theo tiền', '2022-12-30'),
('username15', 'CP0001', 'Phiếu giảm giá theo phần trăm', '2022-12-30'),
('username14', 'CP0003', 'Phiếu giảm giá theo phần trăm', '2022-12-06');

-- --------------------------------------------------------

--
-- Table structure for table `don_hang`
--

CREATE TABLE `don_hang` (
  `maDon` varchar(256) NOT NULL,
  `thoiGianLapDon` date DEFAULT NULL,
  `tinhTrangDonHang` varchar(256) DEFAULT NULL,
  `diaChiNhan` varchar(256) NOT NULL,
  `khachHang` varchar(256) NOT NULL,
  `giaThanhToan` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `don_hang`
--

INSERT INTO `don_hang` (`maDon`, `thoiGianLapDon`, `tinhTrangDonHang`, `diaChiNhan`, `khachHang`, `giaThanhToan`) VALUES
('DH1000', '2022-12-01', 'Đã hoàn thành', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh', 'username9', 568246),
('DH1001', '2022-12-02', 'Đã hoàn thành', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh', 'username10', 814000),
('DH1002', '2022-12-02', 'Đã hoàn thành', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh', 'username11', 113456),
('DH1003', '2022-12-03', 'Đã hoàn thành', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh', 'username12', 60098),
('DH1004', '2022-12-03', 'Đã hoàn thành', '345 Lê Văn Việt, Tăng Nhơ Phú A, Quận 9', 'username13', 296000),
('DH1005', '2022-12-04', 'Đã hoàn thành', '101 Phạm Ngũ Lão, Phường 4, Gò Vấp', 'username14', 54000),
('DH1006', '2022-12-05', 'Đã hoàn thành', '20 Bạch Đằng, Phường 2, Tân Bình', 'username15', 90000),
('DH1007', '2022-12-05', 'Đã hoàn thành', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh', 'username11', 60000),
('DH1008', '2022-12-05', 'Đang xử lí', '101 Phạm Ngũ Lão, Phường 4, Gò Vấp', 'username14', 60000);

-- --------------------------------------------------------

--
-- Table structure for table `khach_hang`
--

CREATE TABLE `khach_hang` (
  `tenDangNhap` varchar(15) NOT NULL,
  `tenKhachHang` varchar(256) NOT NULL,
  `diaChi` varchar(256) NOT NULL,
  `sdt` varchar(256) NOT NULL,
  `anhDaiDien` varchar(256) DEFAULT NULL,
  `diemTichLuy` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `khach_hang`
--

INSERT INTO `khach_hang` (`tenDangNhap`, `tenKhachHang`, `diaChi`, `sdt`, `anhDaiDien`, `diemTichLuy`) VALUES
('username9', 'Nguyễn Mậu Minh Đức', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh', '0123456789', 'img/2022_12_07_06_59_24am.png', 1442),
('username10', 'Phạm Hoàng Đức Huy', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh', '0124532384', 'img/2022_12_07_06_44_02am.png', 150),
('username11', 'Nguyễn Đình Thi', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh', '0451843498', 'img/2022_12_07_06_45_03am.png', 300),
('username12', 'Nguyễn Sơn Tín', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh', '0125232150', 'img/2022_12_08_06_33_13pm.png', 250),
('username13', 'Lý Gia Huy', '345 Lê Văn Việt, Tăng Nhơ Phú A, Quận 9', '0121236561', 'img/2022_12_08_06_32_22pm.png', 175),
('username14', 'Phạm Văn Ngọ', '101 Phạm Ngũ Lão, Phường 4, Gò Vấp', '0154879651', 'img/2022_12_08_06_32_31pm.png', 100),
('username15', 'Đặng Tấn Tài', '20 Bạch Đằng, Phường 2, Tân Bình', '0141201236', 'img/2022_12_08_06_32_49pm.png', 50);

-- --------------------------------------------------------

--
-- Table structure for table `mon_an`
--

CREATE TABLE `mon_an` (
  `tenMonAn` varchar(50) NOT NULL,
  `maMonAn` varchar(15) NOT NULL,
  `moTaMonan` varchar(100) NOT NULL,
  `giaNiemYet` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `mon_an`
--

INSERT INTO `mon_an` (`tenMonAn`, `maMonAn`, `moTaMonan`, `giaNiemYet`) VALUES
('Gỏi củ hủ dừa', 'M001', 'Món gỏi củ hủ dừa tôm thịt là món ăn đặc sản của người miền Tây, thường được dùng làm món khai vị.', 200000),
('Gỏi ngó sen tôm thịt', 'M002', 'Gỏi ngó sen tôm thịt là món gỏi phổ biến trong các bữa tiệc, với hương vị thanh ngọt của tôm, thịt, ', 100000),
('Gỏi bò mè bóp thầu', 'M003', 'Gỏi bò mè bóp thầu', 76000),
('Gỏi bưởi tôm mực', 'M004', 'Gỏi bưởi tôm mực với hương vị chua ngọt giúp bữa ăn thêm hương vị', 54000),
('Mì ý sốt kem paris', 'M005', 'Mì Ý sốt kem là một món ăn mang đậm phong vị Châu Âu. Sợi mì dai dai, chín tới, không bị nhũn, nát, ', 106000),
('Mì vịt tiềm', 'M006', 'Mì vịt tiềm là món ăn ngon nổi tiếng của người Hoa và có giá trị dinh dưỡng cao, vì thịt vịt có vị n', 83000),
('Mì cay', 'M007', 'Với vị cay nồng kết hợp với hải sản tươi ngon, mì cay 7 cấp độ siêu ngon, kích thích vị giác khiến b', 76000),
('Ramen', 'M008', 'Món ăn này là sự hòa quyện hoàn hảo giữa hương vị sợi vì độc đáo, nước súp thơm ngon đi kèm với các ', 89000),
('Mì lạnh', 'M009', 'Mì lạnh Hàn Quốc là món nổi tiếng và được sử dụng phổ biến của xứ sở kim chi đặc biệt vào dịp hè. Hi', 81000),
('Cơm gà Hong Kong', 'M010', 'Món ăn nguồn gốc từ Hong Kong, Trung Quốc, với hương vị đậm đà đặc trưng của món Hoa', 70000),
('Cơm gà Hải Nam', 'M011', 'Món ăn nguồn gốc từ Hải Nam, \r\nTrung Quốc, với hương vị đậm đà đặc trưng của món Hoa', 70000),
('Cơm sườn bì chả', 'M012', 'Món cơm tấm bình dân quen thuộc của người Việt Nam', 54000),
('Cơm rang kim chi ', 'M013', 'Món ăn kết hợp giữa cơm rang quen thuộc và kim chi, tạo nên sự kết hợp lạ mà quen.', 58000),
('Cơm bò xào nấm', 'M014', 'Sự kết hợp cân bằng và hoàn hảo cho một bữa ăn đầy đủ dinh dưỡng', 100000),
('Súp hạt tiêu', 'M015', 'Món súp được rất nhiều người yêu thích, với hương vị đặc trưng của hạt tiêu, kết hợp hoàn hảo với bá', 116000),
('Súp phô mai', 'M016', 'Món súp khoai tây phô mai là món súp rất được ưa chuộng là sự kết hợp giữa các nguyên liệu: khoai tâ', 95000),
('Súp lơ', 'M017', 'Món ăn đơn giản, nhưng vẫn thơm ngon và giàu dinh dưỡng', 60000),
('Súp Lasagna', 'M018', 'Tất cả mọi thứ đều được nấu trong một chảo – thêm các nguyên liệu vào khi bạn chế biến cho đến khi b', 50000),
('Bào ngư vi cá', 'M019', 'Món ăn đặc biệt bổ dưỡng với những nguyên liệu cao cấp, thích hợp để bồi bổ cho người ốm, phũ nữ đan', 1234),
('Bún chả Hà Nội', 'M020', 'Món ăn truyền thống của Hà Nội, được thực khách cả trong và ngoài nước ưa thích với chả nướng thơm p', 69000),
('Bún thang', 'M021', 'Bún thang là một món nước mang đậm hương vị của người Hà Nội. Món ăn nổi tiếng bởi sự cầu kỳ nhưng t', 75000),
('Bún mọc', 'M022', 'Với hương vị hấp dẫn từ những viên mọc hòa quyện cùng nước dùng đậm đà từ xương, bún mọc là món ăn đ', 74000),
('Bún riêu cua', 'M023', 'Món ăn bình dân nhưng không kém phần hấp dẫn với nước dùng ngọt vị, riêu cua thơm ngon', 120000),
('Bún tôm Hải Phòng', 'M024', 'Bún tôm là một món ăn đặc sản Hải Phòng thơm ngon, hấp dẫn nổi tiếng của người dân nơi đây với hương', 91000),
('Bún đậu mắm tôm', 'M025', 'Một mẹt bún đậu mắm tôm với đầy đủ các nguyên liệu hấp dẫn, sạch sẽ chắc hẳn là món ngon mà bất cứ a', 79000),
('Bún bò Huế', 'M026', 'Bún bò là một trong những đặc sản của xứ Huế, mặc dù món bún này phổ biến trên cả ba miền ở Việt Nam', 83000),
('Bánh xèo', 'M027', 'Bánh xèo gồm bột bên ngoài, bên trong có nhân là tôm, thịt, giá đỗ, kim chi, khoai tây, hẹ, tôm, thị', 51000),
('Bánh đúc Hà Nội', 'M028', 'Chỉ với những nguyên liệu cơ bản như mộc nhĩ, rau thơm, thịt xào hành tây, bánh đúc đã mang một hư', 89000),
('Bánh mì chảo', 'M029', 'Một phần bánh mì chảo gồm thịt bò bít tết, trứng ốp la, vài lát hành tây, được rưới nước sốt trên ch', 65000),
('Bánh mì gà', 'M030', 'Bánh mì gà không quá dài theo kiểu bánh mì Pháp thường thấy, cũng không dài như bánh mì truyền thống', 107000),
('Pizza', 'M031', 'Món ăn phổ biến và được ưa thính trên toàn thế giới, nguồn gốc từ Ý', 120000),
('Bánh cuốn nóng', 'M032', 'Món ăn đơn giản nhưng vẫn có dấu ấn riêng với thịt xay lẫn trong bánh, nước chấm đậm đà', 52000),
('Bánh ướt', 'M033', 'Món ăn đơn giản đổi vị cho ngày chán cơm', 70000);

-- --------------------------------------------------------

--
-- Table structure for table `mon_an_thuoc_nhom`
--

CREATE TABLE `mon_an_thuoc_nhom` (
  `maMonAn` varchar(256) NOT NULL,
  `maNhomMonAn` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `mon_an_thuoc_nhom`
--

INSERT INTO `mon_an_thuoc_nhom` (`maMonAn`, `maNhomMonAn`) VALUES
('M001', 'N001'),
('M002', 'N001'),
('M003', 'N001'),
('M004', 'N001'),
('M005', 'N002'),
('M006', 'N002'),
('M007', 'N002'),
('M008', 'N002'),
('M009', 'N002'),
('M010', 'N003'),
('M011', 'N003'),
('M012', 'N003'),
('M013', 'N003'),
('M014', 'N003'),
('M015', 'N004'),
('M016', 'N004'),
('M017', 'N004'),
('M018', 'N004'),
('M019', 'N004'),
('M020', 'N005'),
('M021', 'N005'),
('M022', 'N005'),
('M023', 'N005'),
('M024', 'N005'),
('M025', 'N005'),
('M026', 'N005'),
('M027', 'N006'),
('M028', 'N006'),
('M029', 'N006'),
('M030', 'N006'),
('M031', 'N006'),
('M032', 'N006'),
('M033', 'N006');

-- --------------------------------------------------------

--
-- Table structure for table `nguoi_giao_hang`
--

CREATE TABLE `nguoi_giao_hang` (
  `maDonHang` varchar(15) NOT NULL,
  `maCongTy` varchar(15) NOT NULL,
  `tenTaiXe` varchar(50) NOT NULL,
  `ngayGiaoHang` date NOT NULL,
  `soDienThoai` char(10) NOT NULL,
  `phiShip` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `nguoi_giao_hang`
--

INSERT INTO `nguoi_giao_hang` (`maDonHang`, `maCongTy`, `tenTaiXe`, `ngayGiaoHang`, `soDienThoai`, `phiShip`) VALUES
('DH1000', 'CT1000', 'Nguyễn Văn A', '2022-12-01', '0869756382', 30000),
('DH1001', 'CT1001', 'Nguyễn Văn B', '2022-12-02', '0923857463', 27000),
('DH1002', 'CT1002', 'Nguyễn Văn C', '2022-12-02', '0847859372', 30000),
('DH1003', 'CT1003', 'Nguyễn Văn D', '2022-12-03', '0869123456', 27000),
('DH1004', 'CT1002', 'Trần Văn K', '2022-12-04', '0923982348', 30000),
('DH1005', 'CT1002', 'Nguyễn Ngọc T', '2022-12-04', '0909090909', 25000),
('DH1006', 'CT1003', 'Mạc Diệc P', '2022-12-05', '0320250141', 20000),
('DH1007', 'CT1001', 'Trần Trung H', '2022-12-05', '0352615242', 30000),
('DH1008', 'CT1000', 'Tạ Trung H', '2022-12-05', '0254752364', 25000);

-- --------------------------------------------------------

--
-- Table structure for table `nguoi_nhan`
--

CREATE TABLE `nguoi_nhan` (
  `maDonHang` varchar(15) NOT NULL,
  `tenNguoiNhan` varchar(50) NOT NULL,
  `diaChiNhan` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `nguoi_nhan`
--

INSERT INTO `nguoi_nhan` (`maDonHang`, `tenNguoiNhan`, `diaChiNhan`) VALUES
('DH1000', 'Nguyễn Mậu Minh Đức', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh'),
('DH1001', 'Phạm Hoàng Đức Huy', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh'),
('DH1002', 'Nguyễn Đình Thi', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh'),
('DH1003', 'Nguyễn Sơn Tín', 'KTX khu A, Linh Trung, Thủ Đức, Hồ Chí Minh'),
('DH1004', 'Lý Gia Huy', '345 Lê Văn Việt, Tăng Nhơ Phú A, Quận 9'),
('DH1005', 'Phạm Văn Ngọ', '101 Phạm Ngũ Lão, Phường 4, Gò Vấp'),
('DH1006', 'Đặng Tấn Tài', '20 Bạch Đằng, Phường 2, Tân Bình'),
('DH1007', 'Bùi Lê Tân Khoa', '2o Võ Văn Ngân, Bình Thọ, Thủ Đức, Hồ Chí Minh'),
('DH1008', 'Phạm Văn Ngọ', '101 Phạm Ngũ Lão, Phường 4, Gò Vấp');

-- --------------------------------------------------------

--
-- Table structure for table `nha_hang`
--

CREATE TABLE `nha_hang` (
  `tenDangNhap` varchar(15) NOT NULL,
  `tenNhaHang` varchar(50) NOT NULL,
  `diaChi` varchar(50) NOT NULL,
  `moTaNhaHang` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `nha_hang`
--

INSERT INTO `nha_hang` (`tenDangNhap`, `tenNhaHang`, `diaChi`, `moTaNhaHang`) VALUES
('username1', 'Quán cháo lòng bà Út', '193 Cô Giang, Quận 1', 'Hơn 80 năm nay, gánh cháo lòng Cô Út trên đường Cô Giang – quận 1, là địa chỉ quen thuộc của thực khách ở Sài Gòn. Với hương vị đậm đà, vừa vặn mà ai ăn cũng khen nức nở món cháo của bà. Đây là một trong các quán ăn ngon Sài Gòn mà bạn nên thưởng thức ít nhất một lần khi du lịch đến đây.'),
('username2', 'Bánh xèo', '46A Đinh Công Tráng, Phường Tân Định, Quận 1', 'Nếu bạn muốn thưởng thức được món bánh xèo đúng hương vị thì quán bánh xèo này là một trong những các quán ăn ngon Sài Gòn ngon nức tiếng từ lâu. Bánh xèo theo kiểu miền Nam có vỏ rất giòn, bên trong phần nhân khá nhiều tôm thịt, tôm mềm nên khi cuốn rất tiện lợi.'),
('username3', 'Quán bánh mì Hòa Mã', '53 Cao Thắng, Quận 3', 'Bạn sẽ không khó để tìm đến tiệm bánh mì nhỏ mang tên Hòa Mã nằm trên đường Cao Thắng, quận 3. Theo lời kể lại của nhiều người thì đây là một trong những nơi bán bánh mì thịt đầu tiên ở Sài Gòn. Chủ nhân của nó là hai vợ chồng người Bắc di cư vào Nam từ trước những năm 50. Một ổ bánh mì thơm ngon phải kể đến là phần thập cẩm được chiên trong chiếc chảo nhỏ. Bên trong chảo là đủ thứ nguyên liệu hấp dẫn như trứng gà ốp la, thịt nguội, xúc xích, chả cá, chả lụa… Tất cả đều được chiên nóng cháy cạnh, tỉ mỉ cùng với ít hành tây và dùng nóng với bánh mì. Đây là một trong các quán ăn ngon Sài Gòn mà du khách nào cũng yêu thích khi tới Sài Gòn.'),
('username4', 'Phở Lệ', '413 – 415 Nguyễn Trãi, Phường 7, Quận 5', 'Có từ năm 1970 quán phở Lệ là một quán ăn ngon Sài Gòn mà du khách nên tới thưởng thức. Nước lèo của quán có vị ngọt từ xương cùng bò viên vừa vặn giúp cho món ăn này thu hút được nhiều du khách. Bạn sẽ cảm nhận được từng miếng bò viên cỡ lớn được cắt nhỏ vừa ăn, hơi giòn và có mỡ nên mềm mại chứ không khô. Tô phở được trang trí rất đẹp nhờ vài lát hành tây, hành lá tươi, nhìn giống phở Hà Nội một thời.'),
('username5', 'Dimsum Tiến Phát', '18 Ký Hòa, Phường 11, Quận 5', 'Tiến Phát là thương hiệu dimsum danh tiếng của người Hoa khu Chợ Lớn. Không gian tuy không gọi là quá sang trọng như những nhà hàng dimsum khác nhưng lại tạo cho thực khách cảm giác quen thuộc, cứ như mỗi lần xem phim Hồng Kông vậy.'),
('username6', 'Bánh đúc Phan Đăng Lưu', '116/11 Phan Đăng Lưu, Quận Phú Nhuận', 'Nổi tiếng về độ lâu đời và hương vị món ăn này ở Sài Gòn thì phải kể đến hàng bánh đúc Phan Đăng Lưu. Bánh ở đây hấp dẫn ở độ dẻo dai của bột, thịt nấm đủ đầy và nêm nếm vừa miệng. Hòa quyện thêm chút bùi bùi, thơm thơm cho bánh còn có đậu xanh nấu nhuyễn. Đảm bảo bạn sẽ “ghiền” món ăn này đó.'),
('username7', 'Lẩu cá Dân Ích', '99 Châu Văn Liêm, Phường 14, Quận 5', 'Nằm ở 1 góc đường Châu Văn Liêm, quán lẩu cá Dân Ích đã tồn tại và phát triển đến nay cũng đã hơn 40 năm tại Sài Gòn. Nơi đây lấy lòng được thực khách nhờ những món ăn đậm vị Trung Hoa như lẩu cá cù lao. Nước lẩu ở đây ngọt thanh từ xương hầm chứ không phải từ bọt ngọt đâu nhé. Nồi lẩu gồm có cá, tôm, chả cá, da heo, nấm… Rau và bún gạo, mì ăn kèm, đặc biệt ở đây có thêm bánh quẩy ăn với lẩu, khá lạ miệng nhưng siêu ngon.'),
('username8', 'Bún măng vịt', 'Hẻm 281 Lê Văn Sỹ, Phường 1, Quận Tân Bình', 'Giữa Sài Gòn bao la quán xá thế này để tìm được một quán bún măng gỏi vịt ngon là cả một vấn đề. Quán nằm sâu trong con hẻm đường Lê Văn Sỹ, quận Tân Bình. Vậy mà quán bún vịt này bán gần 50 năm nổi tiếng chỉ bán trong vòng 1 tiếng là hết sạch. Đĩa gỏi đấy ắp toàn thịt là thịt, vịt ít mỡ da mỏng, chắc thịt và mềm. Tô bún măng rất thơm và đậm đà, măng ngon sần sật thêm chén nước chấm chỉ cần pha chút sa tế thì quá là tuyệt vời rồi. Note liền quán ăn ngon Sài Gòn này nhé.');

-- --------------------------------------------------------

--
-- Table structure for table `nhom_mon_an`
--

CREATE TABLE `nhom_mon_an` (
  `tenNhomMonAn` varchar(30) NOT NULL,
  `maNhomMonAn` varchar(15) NOT NULL,
  `moTaNhomMonAn` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `nhom_mon_an`
--

INSERT INTO `nhom_mon_an` (`tenNhomMonAn`, `maNhomMonAn`, `moTaNhomMonAn`) VALUES
('Gỏi', 'N001', 'Món ăn bằng cá, tôm, thịt trộn với rau thơm sống và giấm. Tuy nhiên cũng có thể có các biến thế khác'),
('Mì', 'N002', 'Món ăn dạng sợi dài, được dùng kèm với nước sốt hoặc nước dùng. Thường có nguồn gốc nước ngoài.'),
('Cơm', 'N003', 'Món ăn làm từ gạo, được phục vụ kèm với các món khác. Là món truyền thống của các nước châu Á'),
('Súp', 'N004', 'Món ăn dạng lỏng, gồm nước súp nền (có thể đặc hoặc loãng) và các thành phần đi kèm.'),
('Bún', 'N005', 'Món ăn dạng sợi dài làm từ gạo, phục vụ kèm nước dùng. Là món truyền thống của Việt Nam.'),
('Bánh', 'N006', 'Món ăn gồm bột bánh được làm chín và các thành phần khác. Có nhiều dạng bánh khác nhau với cách chế ');

-- --------------------------------------------------------

--
-- Table structure for table `phieu_giam_gia`
--

CREATE TABLE `phieu_giam_gia` (
  `nhaHang` varchar(15) NOT NULL,
  `tenPhieu` varchar(256) DEFAULT NULL,
  `maPhieu` varchar(256) NOT NULL,
  `tienGiam` int(11) DEFAULT NULL,
  `phanTramGiam` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `phieu_giam_gia`
--

INSERT INTO `phieu_giam_gia` (`nhaHang`, `tenPhieu`, `maPhieu`, `tienGiam`, `phanTramGiam`) VALUES
('username1', 'Coupon giảm giá dịp black friday', 'CP0001', 0, 0.3),
('username4', 'Khuyến mại khai trương', 'CP0002', 50000, 0),
('username8', 'Khuyến mãi tháng 11', 'CP0003', 0, 0.4);

-- --------------------------------------------------------

--
-- Table structure for table `phieu_thanh_toan`
--

CREATE TABLE `phieu_thanh_toan` (
  `maPhieu` varchar(256) NOT NULL,
  `tinhTrang` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `phieu_thanh_toan`
--

INSERT INTO `phieu_thanh_toan` (`maPhieu`, `tinhTrang`) VALUES
('P1000', 'Đã thanh toán'),
('P1001', 'Đã thanh toán'),
('P1002', 'Đã thanh toán'),
('P1003', 'Đã thanh toán'),
('P1004', 'Đã thanh toán'),
('P1005', 'Đã thanh toán'),
('P1006', 'Đã thanh toán'),
('P1007', 'Đã thanh toán'),
('P1008', 'Đã thanh toán');

-- --------------------------------------------------------

--
-- Table structure for table `quan_li_mon_an`
--

CREATE TABLE `quan_li_mon_an` (
  `nhaHang` varchar(256) NOT NULL,
  `maMonAn` varchar(256) NOT NULL,
  `giaBan` int(11) DEFAULT NULL,
  `ngayDatGia` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `quan_li_mon_an`
--

INSERT INTO `quan_li_mon_an` (`nhaHang`, `maMonAn`, `giaBan`, `ngayDatGia`) VALUES
('username1', 'M010', 60000, '2022-11-17'),
('username1', 'M010', 50000, '2022-10-01'),
('username1', 'M001', 200000, '2022-11-03'),
('username1', 'M002', 100000, '2022-11-03'),
('username1', 'M003', 76000, '2022-11-03'),
('username1', 'M004', 54000, '2022-11-03'),
('username2', 'M005', 106000, '2022-11-03'),
('username2', 'M006', 83000, '2022-11-03'),
('username2', 'M007', 76000, '2022-11-05'),
('username3', 'M008', 89000, '2022-11-05'),
('username3', 'M009', 81000, '2022-11-05'),
('username4', 'M010', 70000, '2022-11-04'),
('username4', 'M011', 85000, '2022-11-04'),
('username4', 'M012', 54000, '2022-11-04'),
('username4', 'M013', 58000, '2022-11-04'),
('username4', 'M014', 100000, '2022-11-04'),
('username5', 'M015', 116000, '2022-11-05'),
('username5', 'M016', 95000, '2022-11-05'),
('username5', 'M017', 60000, '2022-11-05'),
('username5', 'M018', 50000, '2022-11-05'),
('username5', 'M019', 93000, '2022-11-05'),
('username6', 'M020', 69000, '2022-11-05'),
('username6', 'M021', 75000, '2022-11-05'),
('username6', 'M022', 74000, '2022-11-05'),
('username7', 'M023', 120000, '2022-11-05'),
('username7', 'M024', 91000, '2022-11-05'),
('username7', 'M025', 79000, '2022-11-05'),
('username7', 'M026', 83000, '2022-11-05'),
('username8', 'M027', 51000, '2022-11-05'),
('username8', 'M028', 89000, '2022-11-05'),
('username8', 'M029', 65000, '2022-11-05'),
('username8', 'M030', 107000, '2022-11-05'),
('username8', 'M031', 120000, '2022-11-05'),
('username8', 'M032', 52000, '2022-11-05'),
('username8', 'M033', 70000, '2022-11-03'),
('username1', 'M019', 123, '2022-12-02');

--
-- Triggers `quan_li_mon_an`
--
DELIMITER $$
CREATE TRIGGER `cap_nhat_gia_mon_an` AFTER INSERT ON `quan_li_mon_an` FOR EACH ROW UPDATE mon_an SET giaNiemYet = new.giaBan WHERE maMonAn = new.maMonAn
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tai_khoan`
--

CREATE TABLE `tai_khoan` (
  `tenDangNhap` varchar(15) NOT NULL,
  `matKhau` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tai_khoan`
--

INSERT INTO `tai_khoan` (`tenDangNhap`, `matKhau`) VALUES
('username1', '12345678'),
('username10', '12345678'),
('username100', '12345678'),
('username11', '12345678'),
('username12', '12345678'),
('username13', '12345678'),
('username14', '12345678'),
('username15', '12345678'),
('username2', '12345678'),
('username3', '12345678'),
('username4', '12345678'),
('username5', '12345678'),
('username6', '12345678'),
('username7', '12345678'),
('username8', '12345678'),
('username9', '12345678');

-- --------------------------------------------------------

--
-- Table structure for table `tao_don_hang`
--

CREATE TABLE `tao_don_hang` (
  `maDonHang` varchar(256) NOT NULL,
  `maGiamGia` varchar(256) DEFAULT NULL,
  `maPhieuThanhToan` varchar(256) DEFAULT NULL,
  `maMonAn` varchar(256) NOT NULL,
  `ngayTaoDon` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tao_don_hang`
--

INSERT INTO `tao_don_hang` (`maDonHang`, `maGiamGia`, `maPhieuThanhToan`, `maMonAn`, `ngayTaoDon`) VALUES
('DH1000', 'CP0001', 'P1000', 'M001', '2022-12-01'),
('DH1001', NULL, 'P1001', 'M008', '2022-12-02'),
('DH1002', 'CP0002', 'P1002', 'M031', '2022-12-02'),
('DH1003', NULL, 'P1003', 'M013', '2022-12-03'),
('DH1004', NULL, 'P1004', 'M033', '2022-12-04'),
('DH1005', NULL, 'P1005', 'M012', '2022-12-04'),
('DH1006', 'CP0001', 'P1006', 'M014', '2022-12-05'),
('DH1007', NULL, 'P1007', 'M017', '2022-12-05'),
('DH1008', 'CP0003', 'P1008', 'M020', '2022-12-05'),
('DH1000', NULL, 'P1000', 'M001', '2022-12-04'),
('DH1000', 'CP0001', 'P1000', 'M021', '2022-12-05'),
('DH1000', 'CP0002', 'P1000', 'M010', '2022-12-04'),
('DH1000', 'CP0001', 'P1000', 'M001', NULL),
('DH1000', 'CP0001', 'P1000', 'M001', NULL),
('DH1000', 'CP0001', 'P1000', 'M001', NULL),
('DH1000', 'CP0002', 'P1000', 'M010', NULL),
('DH1000', 'CP0002', 'P1000', 'M014', NULL),
('DH1000', 'CP0002', 'P1000', 'M010', NULL),
('DH1001', 'CP0001', 'P1001', 'M001', NULL),
('DH1001', 'CP0001', 'P1001', 'M001', NULL),
('DH1001', 'CP0001', 'P1001', 'M001', NULL),
('DH1001', 'CP0001', 'P1001', 'M001', NULL),
('DH1001', 'CP0001', 'P1001', 'M001', NULL),
('DH1000', 'CP0001', 'P1000', 'M019', NULL),
('DH1000', 'CP0003', 'P1000', 'M019', NULL),
('DH1000', 'CP0001', 'P1000', 'M019', NULL),
('DH1000', 'CP0001', 'P1000', 'M001', NULL),
('DH1000', 'CP0001', 'P1000', 'M001', NULL),
('DH1000', 'CP0001', 'P1000', 'M010', NULL),
('DH1000', 'CP0001', 'P1000', 'M011', NULL),
('DH1002', 'CP0001', 'P1002', 'M019', NULL),
('DH1002', 'CP0001', 'P1002', 'M019', NULL),
('DH1002', 'CP0001', 'P1002', 'M019', NULL),
('DH1002', 'CP0001', 'P1002', 'M019', NULL),
('DH1003', 'CP0001', 'P1003', 'M019', NULL),
('DH1003', NULL, 'P1003', 'M019', NULL),
('DH1001', 'CP0001', 'P1001', 'M010', NULL),
('DH1004', 'CP0001', 'P1004', 'M010', NULL),
('DH1004', 'CP0001', 'P1004', 'M010', NULL),
('DH1004', 'CP0001', 'P1004', 'M010', NULL),
('DH1004', 'CP0001', 'P1004', 'M010', NULL);

--
-- Triggers `tao_don_hang`
--
DELIMITER $$
CREATE TRIGGER `cap_nhat_don_hang` BEFORE INSERT ON `tao_don_hang` FOR EACH ROW IF(EXISTS(SELECT * FROM `don_hang` WHERE `maDon` = new.maDonHang)) THEN
BEGIN
IF(EXISTS(SELECT * FROM `mon_an` WHERE `maMonAn` = new.maMonAn)) THEN
BEGIN
IF(EXISTS(SELECT * FROM `phieu_giam_gia` WHERE `maPhieu` = new.maGiamGia)) THEN
    BEGIN
    	DECLARE tang_them INT DEFAULT 0;
        SELECT `giaNiemYet` INTO tang_them
        FROM `mon_an`
        WHERE new.`maMonAn` = `maMonAn`;
        
    	IF(EXISTS(SELECT maPhieu FROM `phieu_giam_gia` INNER JOIN `quan_li_mon_an` ON `quan_li_mon_an`.nhaHang = `phieu_giam_gia`.nhaHang WHERE `quan_li_mon_an`.`maMonAn` =new.maMonAn AND maPhieu = new.maGiamGia)) THEN
        BEGIN
            IF((SELECT `tienGiam` FROM `phieu_giam_gia` WHERE new.`maGiamGia` = `maPhieu`) > 0 ) THEN
            BEGIN
            
               	DECLARE giam_di INT DEFAULT 0;
                SELECT `tienGiam` INTO giam_di
                FROM `phieu_giam_gia` 
                WHERE new.`maGiamGia` = `maPhieu`;
                
                UPDATE `don_hang`
                SET `giaThanhToan` := `giaThanhToan` + tang_them - giam_di
                WHERE `maDon` = new.`maDonHang`;
            END;
            END IF;
            IF((SELECT `phanTramGiam` FROM `phieu_giam_gia` WHERE new.`maGiamGia` = `maPhieu`) > 0 ) THEN
            BEGIN
               	DECLARE giam_di FLOAT(3, 2) DEFAULT 0;
                SELECT `phanTramGiam` INTO giam_di
                FROM `phieu_giam_gia` 
                WHERE new.`maGiamGia` = `maPhieu`;
                
                UPDATE `don_hang`
                SET `giaThanhToan` := `giaThanhToan` + tang_them - tang_them * giam_di
                WHERE `maDon` = new.`maDonHang`;
            END;
            END IF;
        END;
        ELSE 
    		SIGNAL SQLSTATE	'45000' SET MESSAGE_TEXT = "Phiếu giảm giá không tồn tại cho món ăn này";
        END IF;
    END;
ELSEIF(NOT EXISTS(SELECT new.maGiamGia)) THEN
    BEGIN
        DECLARE tang_them INT DEFAULT 0;
        SELECT `giaNiemYet` INTO tang_them
        FROM `mon_an`
        WHERE new.`maMonAn` = `maMonAn`;
        
        UPDATE `don_hang`
        SET `giaThanhToan` := `giaThanhToan` + tang_them
        WHERE `maDon` = new.`maDonHang`;
    END;
ELSE
	SIGNAL SQLSTATE	'45000' SET MESSAGE_TEXT = "Không có phiếu đó đó";
END IF;
    END;
ELSE 
	SIGNAL SQLSTATE	'45000' SET MESSAGE_TEXT = "Không có món ăn đó";
END IF;
    END;
ELSE 
	SIGNAL SQLSTATE	'45000' SET MESSAGE_TEXT = "Không có đơn hàng đó";
END IF
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `anh_mon_an`
--
ALTER TABLE `anh_mon_an`
  ADD KEY `fk_anhmonan_mamonan` (`maMonAn`);

--
-- Indexes for table `anh_nha_hang`
--
ALTER TABLE `anh_nha_hang`
  ADD KEY `fk_anhnh_tendn` (`tenDangNhap`);

--
-- Indexes for table `cong_ty_giao_hang`
--
ALTER TABLE `cong_ty_giao_hang`
  ADD PRIMARY KEY (`maCongTy`);

--
-- Indexes for table `danh_gia_mon_an`
--
ALTER TABLE `danh_gia_mon_an`
  ADD KEY `maMonAn` (`maMonAn`),
  ADD KEY `khachHang` (`khachHang`);

--
-- Indexes for table `doi_diem`
--
ALTER TABLE `doi_diem`
  ADD KEY `khachHang` (`khachHang`),
  ADD KEY `maPhieu` (`maPhieu`);

--
-- Indexes for table `don_hang`
--
ALTER TABLE `don_hang`
  ADD PRIMARY KEY (`maDon`),
  ADD KEY `khachHang` (`khachHang`);

--
-- Indexes for table `khach_hang`
--
ALTER TABLE `khach_hang`
  ADD KEY `tenDangNhap` (`tenDangNhap`);

--
-- Indexes for table `mon_an`
--
ALTER TABLE `mon_an`
  ADD PRIMARY KEY (`maMonAn`);

--
-- Indexes for table `mon_an_thuoc_nhom`
--
ALTER TABLE `mon_an_thuoc_nhom`
  ADD KEY `maMonAn` (`maMonAn`),
  ADD KEY `maNhomMonAn` (`maNhomMonAn`);

--
-- Indexes for table `nguoi_giao_hang`
--
ALTER TABLE `nguoi_giao_hang`
  ADD PRIMARY KEY (`maDonHang`,`maCongTy`),
  ADD KEY `fk_maCT_nguoigiao` (`maCongTy`);

--
-- Indexes for table `nguoi_nhan`
--
ALTER TABLE `nguoi_nhan`
  ADD PRIMARY KEY (`maDonHang`);

--
-- Indexes for table `nha_hang`
--
ALTER TABLE `nha_hang`
  ADD PRIMARY KEY (`tenDangNhap`);

--
-- Indexes for table `nhom_mon_an`
--
ALTER TABLE `nhom_mon_an`
  ADD PRIMARY KEY (`maNhomMonAn`);

--
-- Indexes for table `phieu_giam_gia`
--
ALTER TABLE `phieu_giam_gia`
  ADD PRIMARY KEY (`maPhieu`),
  ADD KEY `nhaHang` (`nhaHang`);

--
-- Indexes for table `phieu_thanh_toan`
--
ALTER TABLE `phieu_thanh_toan`
  ADD PRIMARY KEY (`maPhieu`);

--
-- Indexes for table `quan_li_mon_an`
--
ALTER TABLE `quan_li_mon_an`
  ADD KEY `maMonAn` (`maMonAn`),
  ADD KEY `nhaHang` (`nhaHang`);

--
-- Indexes for table `tai_khoan`
--
ALTER TABLE `tai_khoan`
  ADD PRIMARY KEY (`tenDangNhap`);

--
-- Indexes for table `tao_don_hang`
--
ALTER TABLE `tao_don_hang`
  ADD KEY `maDonHang` (`maDonHang`),
  ADD KEY `maGiamGia` (`maGiamGia`),
  ADD KEY `maPhieuThanhToan` (`maPhieuThanhToan`),
  ADD KEY `maMonAn` (`maMonAn`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `anh_mon_an`
--
ALTER TABLE `anh_mon_an`
  ADD CONSTRAINT `fk_anhmonan_mamonan` FOREIGN KEY (`maMonAn`) REFERENCES `mon_an` (`maMonAn`);

--
-- Constraints for table `anh_nha_hang`
--
ALTER TABLE `anh_nha_hang`
  ADD CONSTRAINT `fk_anhnh_tendn` FOREIGN KEY (`tenDangNhap`) REFERENCES `nha_hang` (`tenDangNhap`);

--
-- Constraints for table `danh_gia_mon_an`
--
ALTER TABLE `danh_gia_mon_an`
  ADD CONSTRAINT `danh_gia_mon_an_ibfk_1` FOREIGN KEY (`maMonAn`) REFERENCES `mon_an` (`maMonAn`),
  ADD CONSTRAINT `danh_gia_mon_an_ibfk_2` FOREIGN KEY (`khachHang`) REFERENCES `khach_hang` (`tenDangNhap`);

--
-- Constraints for table `doi_diem`
--
ALTER TABLE `doi_diem`
  ADD CONSTRAINT `doi_diem_ibfk_1` FOREIGN KEY (`khachHang`) REFERENCES `khach_hang` (`tenDangNhap`),
  ADD CONSTRAINT `doi_diem_ibfk_2` FOREIGN KEY (`maPhieu`) REFERENCES `phieu_giam_gia` (`maPhieu`);

--
-- Constraints for table `don_hang`
--
ALTER TABLE `don_hang`
  ADD CONSTRAINT `don_hang_ibfk_1` FOREIGN KEY (`khachHang`) REFERENCES `khach_hang` (`tenDangNhap`);

--
-- Constraints for table `khach_hang`
--
ALTER TABLE `khach_hang`
  ADD CONSTRAINT `khach_hang_ibfk_1` FOREIGN KEY (`tenDangNhap`) REFERENCES `tai_khoan` (`tenDangNhap`);

--
-- Constraints for table `mon_an_thuoc_nhom`
--
ALTER TABLE `mon_an_thuoc_nhom`
  ADD CONSTRAINT `mon_an_thuoc_nhom_ibfk_1` FOREIGN KEY (`maMonAn`) REFERENCES `mon_an` (`maMonAn`),
  ADD CONSTRAINT `mon_an_thuoc_nhom_ibfk_2` FOREIGN KEY (`maMonAn`) REFERENCES `mon_an` (`maMonAn`),
  ADD CONSTRAINT `mon_an_thuoc_nhom_ibfk_3` FOREIGN KEY (`maNhomMonAn`) REFERENCES `nhom_mon_an` (`maNhomMonAn`);

--
-- Constraints for table `nguoi_giao_hang`
--
ALTER TABLE `nguoi_giao_hang`
  ADD CONSTRAINT `fk_maCT_nguoigiao` FOREIGN KEY (`maCongTy`) REFERENCES `cong_ty_giao_hang` (`maCongTy`),
  ADD CONSTRAINT `fk_madon_nguoigiao` FOREIGN KEY (`maDonHang`) REFERENCES `don_hang` (`maDon`);

--
-- Constraints for table `nguoi_nhan`
--
ALTER TABLE `nguoi_nhan`
  ADD CONSTRAINT `fk_nguoinhan_madon` FOREIGN KEY (`maDonHang`) REFERENCES `don_hang` (`maDon`);

--
-- Constraints for table `nha_hang`
--
ALTER TABLE `nha_hang`
  ADD CONSTRAINT `fk_nh_tendn` FOREIGN KEY (`tenDangNhap`) REFERENCES `tai_khoan` (`tenDangNhap`);

--
-- Constraints for table `phieu_giam_gia`
--
ALTER TABLE `phieu_giam_gia`
  ADD CONSTRAINT `phieu_giam_gia_ibfk_1` FOREIGN KEY (`nhaHang`) REFERENCES `nha_hang` (`tenDangNhap`);

--
-- Constraints for table `quan_li_mon_an`
--
ALTER TABLE `quan_li_mon_an`
  ADD CONSTRAINT `quan_li_mon_an_ibfk_1` FOREIGN KEY (`maMonAn`) REFERENCES `mon_an` (`maMonAn`),
  ADD CONSTRAINT `quan_li_mon_an_ibfk_2` FOREIGN KEY (`nhaHang`) REFERENCES `nha_hang` (`tenDangNhap`);

--
-- Constraints for table `tao_don_hang`
--
ALTER TABLE `tao_don_hang`
  ADD CONSTRAINT `tao_don_hang_ibfk_1` FOREIGN KEY (`maDonHang`) REFERENCES `don_hang` (`maDon`),
  ADD CONSTRAINT `tao_don_hang_ibfk_2` FOREIGN KEY (`maGiamGia`) REFERENCES `phieu_giam_gia` (`maPhieu`),
  ADD CONSTRAINT `tao_don_hang_ibfk_3` FOREIGN KEY (`maPhieuThanhToan`) REFERENCES `phieu_thanh_toan` (`maPhieu`),
  ADD CONSTRAINT `tao_don_hang_ibfk_4` FOREIGN KEY (`maMonAn`) REFERENCES `mon_an` (`maMonAn`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
