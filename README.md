# AlternativeModuleUpdate
Alternative update of the module via GitHub directly in the module itself. 
Supports Magisk, KSU, Apatch.

`module_update.sh` should be located in the module_archive.zip  
In `module.prop`, the line `updateJson` needs to be removed if it exists.  

Two lines need to be added to the module itself to connect `module_update.sh`:
```shell
source "./module_update.sh"
module_update
```

In `module_update.sh` itself, the following lines need to be changed: `CURRENT_VERSION`, `UPDATE_URL`, `ZIP_FILE`.
