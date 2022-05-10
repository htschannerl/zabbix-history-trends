-- zabbix.custom_history source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `custom_history` AS
select
    `hosts`.`hostid` AS `hostid`,
    `hosts`.`host` AS `host`,
    `hosts`.`status` AS `status`,
    `items`.`itemid` AS `itemid`,
    `items`.`name` AS `items_name`,
    `items`.`key_` AS `key_`,
    (case
        when (`history`.`clock` is not null) then date_format(from_unixtime(`history`.`clock`), '%Y-%m-%d')
        when (`history_log`.`clock` is not null) then date_format(from_unixtime(`history_log`.`clock`), '%Y-%m-%d')
        when (`history_str`.`clock` is not null) then date_format(from_unixtime(`history_str`.`clock`), '%Y-%m-%d')
        when (`history_text`.`clock` is not null) then date_format(from_unixtime(`history_text`.`clock`), '%Y-%m-%d')
        else date_format(from_unixtime(`history_uint`.`clock`), '%Y-%m-%d')
    end) AS `date`,
    (case
        when (`history`.`clock` is not null) then date_format(from_unixtime(`history`.`clock`), '%H:%i:%s')
        when (`history_log`.`clock` is not null) then date_format(from_unixtime(`history_log`.`clock`), '%H:%i:%s')
        when (`history_str`.`clock` is not null) then date_format(from_unixtime(`history_str`.`clock`), '%H:%i:%s')
        when (`history_text`.`clock` is not null) then date_format(from_unixtime(`history_text`.`clock`), '%H:%i:%s')
        else date_format(from_unixtime(`history_uint`.`clock`), '%H:%i:%s')
    end) AS `time`,
    (case
        when (`history`.`clock` is not null) then `history`.`clock`
        when (`history_log`.`clock` is not null) then `history_log`.`clock`
        when (`history_str`.`clock` is not null) then `history_str`.`clock`
        when (`history_text`.`clock` is not null) then `history_text`.`clock`
        else `history_uint`.`clock`
    end) AS `clock`,
    (case
        when (`history`.`clock` is not null) then `history`.`value`
        when (`history_log`.`clock` is not null) then `history_log`.`value`
        when (`history_str`.`clock` is not null) then `history_str`.`value`
        when (`history_text`.`clock` is not null) then `history_text`.`value`
        else `history_uint`.`value`
    end) AS `value`,
    `item_tag`.`tag` AS `tag`,
    `item_tag`.`value` AS `tag_value`
from
    (((((((`hosts`
left join `items` on
    ((`items`.`hostid` = `hosts`.`hostid`)))
left join `history` on
    ((`history`.`itemid` = `items`.`itemid`)))
left join `history_log` on
    ((`history_log`.`itemid` = `items`.`itemid`)))
left join `history_str` on
    ((`history_str`.`itemid` = `items`.`itemid`)))
left join `history_text` on
    ((`history_text`.`itemid` = `items`.`itemid`)))
left join `history_uint` on
    ((`history_uint`.`itemid` = `items`.`itemid`)))
left join `item_tag` on
    ((`item_tag`.`itemid` = `items`.`itemid`)));