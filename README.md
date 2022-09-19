# wasabi_boombox 2.1.1

This resource was created as a ESX/QB free portable boombox script capable of playing youtube links.

<b>Features:</b>
- Usable boombox
- Full animations and boombox prop
- Ability to save songs for later use
- Play any youtube song
- Adjust volume
- Stop music on boombox pick-up
- Play music truly anywhere
- Uses 0.00ms on idle and 0.01ms~ when boombox prop attached to hand


## Installation

- Download this script
- Import if framework ESX use this one > `ESXSQL.sql` if framework is QB use this one > `QBSQL.sql` file to database.
- For QBCore Add item Name Into Items Table.
- Download ox_lib(If you don't have): https://github.com/overextended/ox_lib/releases.
- Download qtarget(If using ESX): https://github.com/overextended/qtarget.
- Download qb-target(If using QB): https://github.com/qbcore-framework/qb-target.
- Download xsound(If you don't have): https://github.com/Xogy/xsound.
- Put script in your `resources` directory.
- Make sure the following are running in your `server.cfg`:

##QBCore SQl
```
CREATE TABLE IF NOT EXISTS `boombox_songs` (
  `citizenid` varchar(64) NOT NULL,
  `label` varchar(30) NOT NULL,
  `link` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

```
ensure ox_lib
ensure qtarget or ensure qb-target
ensure xsound
ensure wasabi_boombox
```

### Extra Information
- Inventory image included in the `InventoryImages` directory
- You must add the item `boombox`(or whatever config item is set as) to your items database/table.

## Preview
https://www.youtube.com/watch?v=P4VfaLsN_U8

# Support
Join our discord <a href='https://discord.gg/XJFNyMy3Bv'>HERE</a> for additional scripts and support!
