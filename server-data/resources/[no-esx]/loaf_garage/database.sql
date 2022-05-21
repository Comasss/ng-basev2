ALTER TABLE `owned_vehicles` ADD COLUMN `damages` LONGTEXT;
ALTER TABLE `owned_vehicles` ADD COLUMN `garage` VARCHAR(255) NOT NULL DEFAULT 'square';
ALTER TABLE `owned_vehicles` ALTER `job` SET DEFAULT '';

ALTER TABLE `owned_vehicles` ADD COLUMN `stored` TINYINT(4) NOT NULL DEFAULT 0;