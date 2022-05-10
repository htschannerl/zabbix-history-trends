-- zabbix.custom_trends source

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `custom_trends` AS
select
    `hosts`.`hostid` AS `hostid`,
    `hosts`.`host` AS `host`,
    `hosts`.`status` AS `status`,
    `items`.`itemid` AS `itemid`,
    `items`.`name` AS `items_name`,
    `items`.`key_` AS `key_`,
    `hstgrp`.`name` AS `group_name`,
    `hstgrp`.`groupid` AS `groupid`,
    (case
        when (`trends`.`clock` is not null) then date_format(from_unixtime(`trends`.`clock`), '%Y-%m-%d')
        else date_format(from_unixtime(`trends_uint`.`clock`), '%Y-%m-%d')
    end) AS `date`,
    (case
        when (`trends`.`clock` is not null) then date_format(from_unixtime(`trends`.`clock`), '%H:%i:%s')
        else date_format(from_unixtime(`trends_uint`.`clock`), '%H:%i:%s')
    end) AS `time`,
    (case
        when (`trends`.`clock` is not null) then `trends`.`clock`
        else `trends_uint`.`clock`
    end) AS `clock`,
    (case
        when (`trends`.`clock` is not null) then `trends`.`value_min`
        else `trends_uint`.`value_min`
    end) AS `value_min`,
    (case
        when (`trends`.`clock` is not null) then `trends`.`value_avg`
        else `trends_uint`.`value_avg`
    end) AS `value_avg`,
    (case
        when (`trends`.`clock` is not null) then `trends`.`value_max`
        else `trends_uint`.`value_max`
    end) AS `value_max`,
    `item_tag`.`tag` AS `tag`,
    `item_tag`.`value` AS `tag_value`
from
    ((((((`hosts`
left join `items` on
    ((`items`.`hostid` = `hosts`.`hostid`)))
left join `trends` on
    ((`trends`.`itemid` = `items`.`itemid`)))
left join `trends_uint` on
    ((`trends_uint`.`itemid` = `items`.`itemid`)))
left join `item_tag` on
    ((`item_tag`.`itemid` = `items`.`itemid`)))
left join `hosts_groups` on
    ((`hosts_groups`.`hostid` = `hosts`.`hostid`)))
left join `hstgrp` on
    ((`hstgrp`.`groupid` = `hosts_groups`.`groupid`)));