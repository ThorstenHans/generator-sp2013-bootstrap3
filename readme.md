# Sharepoint 2013 generator

Yeoman generator for scaffolding out a SharePoint 2013 HTML Master & Page
Layouts project. Based on Kevin Mess' `generator-sp2013`


## Getting Started

- Make sure you have [yo](https://github.com/yeoman/yo) installed: `npm install -g yo`
- Install the generator: `npm install -g generator-sp2013-bootstrap3`
- Run: `yo sp2013-bootstrap3`
- Run `grunt` for building and `grunt server` for preview


## Options

* `--skip-install`

  Skips the automatic execution of `bower` and `npm` after
  scaffolding has finished.

* `--test-framework=[framework]`

  Defaults to `mocha`. Can be switched for
  another supported testing framework like `jasmine`.


## Contribute

Todo...

## WebDAV deployment

Added WebDAV deployment support.

* Specify your mapped masterpage folder during generator execution
* execute `grunt deploy` to deploy the processed output automatically to your WebDAV



## License

[BSD license](http://opensource.org/licenses/bsd-license.php)
