'use strict';
var util = require('util');
var path = require('path');
var spawn = require('child_process').spawn;
var yeoman = require('yeoman-generator');
var _ = require('underscore.string');

var AppGenerator = module.exports = function Appgenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  // setup the test-framework property, Gruntfile template will need this
  this.testFramework = options['test-framework'] || 'mocha';

  // for hooks to resolve on mocha by default
  if (!options['test-framework']) {
    options['test-framework'] = 'mocha';
  }

  // resolved to mocha by default (could be switched to jasmine for instance)
  this.hookFor('test-framework', { as: 'app' });
  
  this.on('end', function () {
    this.installDependencies({ skipInstall: options['skip-install'] });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(AppGenerator, yeoman.generators.Base);

AppGenerator.prototype.askFor = function askFor() {
  var cb = this.async();

  // welcome message
  console.log(this.yeoman);
  console.log('Out of the box I include HTML5 Boilerplate, jQuery and Modernizr.');

  var prompts = [{
    name: 'masterName',
    message: 'What is the name of your master file?'
  },
  {
    type: 'confirm',
    name: 'compassBootstrap',
    message: 'Would you like to include Twitter Bootstrap for Sass?',
    default: true
  },
  {
    type: 'confirm',
    name: 'autoprefixer',
    message: 'Would you like to use autoprefixer for your CSS?',
    default: false
  },
  {
    name: 'webDavProperty',
    message: "Provide a property name for the WebDav Root Url (we're looking in ENV and .webdavconf)"
  }
  ];

  this.prompt(prompts, function (props) {
    this.compassBootstrap = props.compassBootstrap;
    this.includeRequireJS = false;//props.includeRequireJS;
    this.autoprefixer = props.autoprefixer;
    this.masterName = props.masterName;
    this.webDavProperty = props.webDavProperty;
    this.masterSlug = _.slugify(this.masterName);

    cb();
  }.bind(this));
};

AppGenerator.prototype.app = function app() {
  this.mkdir('app');
  this.mkdir('app/scripts');
  this.mkdir('app/styles');
  this.mkdir('app/images');
  this.mkdir('app/jade');
  this.copy('gitignore', '.gitignore');
  this.copy('gitattributes', '.gitattributes');
  this.copy('bowerrc', '.bowerrc');
  this.copy('_bower.json', 'bower.json');
  this.copy('jshintrc', '.jshintrc');
  this.copy('editorconfig', '.editorconfig');
  this.copy('favicon.ico', 'app/images/favicon.ico');
  if (this.compassBootstrap) {
    this.copy('glyphicons-halflings.png', 'app/images/glyphicons-halflings.png');
    this.copy('glyphicons-halflings-white.png', 'app/images/glyphicons-halflings-white.png');
  }
  if (this.compassBootstrap) {
    this.copy('bootstrap.js', 'app/scripts/vendor/bootstrap.js');
  }
  if (this.compassBootstrap) {
    this.copy('main.scss', 'app/styles/main.scss');
  } else {
    this.copy('main.css', 'app/styles/main.css');
  }
  this.copy('ei_logo.png', 'app/images/ei_logo.png');
  
  this.template('_webdavconf.json','.webdavconf.json');
  this.template('Gruntfile.coffee', 'Gruntfile.coffee');
  this.template('_package.json', 'package.json');
  this.template('master.jade', 'app/jade/' + this.masterSlug + '.jade');
  this.template('layout.jade', 'app/jade/layout.jade');
};

AppGenerator.prototype.install = function () {
  if (this.options['skip-install']) {
    return;
  }

  var done = this.async();
  this.installDependencies({
    skipMessage: this.options['skip-install-message'],
    skipInstall: this.options['skip-install'],
    callback: done
  });
};

