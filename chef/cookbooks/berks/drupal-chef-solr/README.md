Installs [solr](http://lucene.apache.org/solr/) and starts the service.

## Recipes

- `default` - This will install java, download solr and setup the service
- `drupal` - Download [drupal/apachesolr](https://drupal.org/project/apachesolr) and configure Solr with it

## Attributes
---

### Default recipe attributes:

- `node['solr']['version']` - Version of solr to install
- `node['solr']['url']` - Url of solr source to download
- `node['solr']['data_dir']` - Location for solr data and config
- `node['solr']['dir']` - Location of the solr sorce files
- `node['solr']['port']` - The port the Solr service is bound to
- `node['solr']['user']` - A user to run the Solr instance as
- `node['solr']['config]` - Configuration folder path relative to data_dir

### Drupal recipe attributes:
- `node['solr']['drupal']['version']` - Version of drupal apachesolr module to download
- `node['solr']['drupal']['url']` - URL to download drupal apachesolr from
- `node['solr']['drupal']['config_files']` - Names of the Drupal apachesolr config files to use
- `node['solr']['drupal']['config_files_path']` - Path to the drupal apachesolr config files
- `node['solr']['drupal']['disable_stemming']` - The stemming defaults to enabled.

## License and Author

License: [MIT](https://github.com/dkinzer/chef-solr/blob/master/LICENSE)

Author: [David Kinzer](https://github.com/dkinzer)

Originally a fork of https://github.com/dwradcliffe/chef-solr
