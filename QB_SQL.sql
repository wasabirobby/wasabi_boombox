DROP TABLE IF EXISTS `boombox_songs`;
CREATE TABLE IF NOT EXISTS `boombox_songs` (
  `citizenid` varchar(64) NOT NULL,
  `label` varchar(30) NOT NULL,
  `link` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
