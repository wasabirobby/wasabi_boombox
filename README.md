# wasabi_boombox 2.0

This resource was created as a ESX free portable boombox script capable of playing youtube links.

**UPDATE:**
This is 2.0 of wasabi_boombox and no longer requires nh-context/keyboard unlike my previous version (It utilizes ox_lib).
Previous bugs such as boomboxes duplicating, falling over, and songs not stopping should be resolved with this version moving forward as well as additional new features.

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
- Import `SQL.sql` file to database
- Download ox_lib(If you don't have): https://github.com/overextended/ox_lib/releases
- Download qtarget(If you don't have): https://github.com/overextended/qtarget
- Download xsound(If you don't have): https://github.com/Xogy/xsound
- Put script in your `resources` directory
- Make sure the following are running in your `server.cfg`:
```
ensure ox_lib
ensure qtarget
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
