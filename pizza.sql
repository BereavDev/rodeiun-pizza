-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 19 Nis 2021, 00:06:40
-- Sunucu sürümü: 10.4.18-MariaDB
-- PHP Sürümü: 7.3.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `pizza`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `bans`
--

CREATE TABLE `bans` (
  `banID` int(11) NOT NULL,
  `banSebep` varchar(51) NOT NULL DEFAULT 'Yok',
  `banAtan` varchar(25) NOT NULL DEFAULT 'Yok',
  `banYiyen` varchar(26) NOT NULL DEFAULT 'Yok',
  `banSure` int(11) NOT NULL DEFAULT 0,
  `banIP` varchar(60) NOT NULL DEFAULT '127.0.0.1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `bans`
--

INSERT INTO `bans` (`banID`, `banSebep`, `banAtan`, `banYiyen`, `banSure`, `banIP`) VALUES
(1, 'kendime', 'Franklin_Repane', 'Franklin_Repane', 1617819714, '127.0.0.1');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `evler`
--

CREATE TABLE `evler` (
  `evID` int(11) NOT NULL,
  `evAdres` varchar(60) NOT NULL DEFAULT 'Yok',
  `evPos` varchar(50) NOT NULL DEFAULT '0.0|0.0|0.0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `evler`
--

INSERT INTO `evler` (`evID`, `evAdres`, `evPos`) VALUES
(1, 'Deneme', '2085.208|-1762.580|13.398'),
(2, 'Deneme', '2090.480|-1769.739|13.392'),
(3, 'denme', '2078.897|-1707.058|13.391');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `oyuncular`
--

CREATE TABLE `oyuncular` (
  `ID` int(11) NOT NULL,
  `Isim` varchar(25) NOT NULL,
  `Sifre` varchar(50) NOT NULL,
  `Skor` int(11) NOT NULL DEFAULT 0,
  `Para` int(11) NOT NULL DEFAULT 0,
  `pMaas` int(11) NOT NULL DEFAULT 0,
  `Admin` int(2) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Tablo döküm verisi `oyuncular`
--

INSERT INTO `oyuncular` (`ID`, `Isim`, `Sifre`, `Skor`, `Para`, `pMaas`, `Admin`) VALUES
(1, 'Franklin_Repane', 'fd2a3314d4d196fd5fc17d54743e59f5', 2, 8700, 3000, 3);

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`banID`);

--
-- Tablo için indeksler `evler`
--
ALTER TABLE `evler`
  ADD PRIMARY KEY (`evID`);

--
-- Tablo için indeksler `oyuncular`
--
ALTER TABLE `oyuncular`
  ADD PRIMARY KEY (`ID`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `bans`
--
ALTER TABLE `bans`
  MODIFY `banID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Tablo için AUTO_INCREMENT değeri `evler`
--
ALTER TABLE `evler`
  MODIFY `evID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Tablo için AUTO_INCREMENT değeri `oyuncular`
--
ALTER TABLE `oyuncular`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
