ALTER TABLE  `hb_subscription_items` CHANGE  `type`  `type` ENUM(  'Hosting',  'Addon',  'Other' ) NOT NULL;