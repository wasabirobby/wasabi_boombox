CREATE TABLE IF NOT EXISTS `boombox_songs` (
  `identifier` varchar(64) NOT NULL,
  `label` varchar(30) NOT NULL,
  `link` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
