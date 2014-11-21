ohai-brightbox Cookbook
=======================
This cookbook installs an ohai plugin to gather metadata for Brightbox
(http://brightbox.com) cloud instances.

Requirements
------------

#### cookbooks
- `ohai` - ohai-brightbox needs the ohai cookbook to install the plugin

Usage
-----
#### ohai-brightbox::default
Just include `ohai-brightbox` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ohai-brightbox]"
  ]
}
```

License and Authors
-------------------
Authors: John Daniels <john@semantici.st>
Licence: Apache, see LICENCE
