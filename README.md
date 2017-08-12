# glynx-env "cookbook"

This is a central repo for all of the glynx cookbooks necessary for standing up production and development systems.

Underneath the cookbooks directory you will find the following cookbooks:

* glynx_application - setup and configure the rails server
* glynx_database - setup and configure the postgres/postgis database
* glynx_elasticsearch - setup and configure elastic search for catalog entry indexing

## Updating the environment files

From the root of this repository:

```
berks
berks apply glynx_production -f <LOCATION FOR CHEF REPO>/environments/glynx_production.json
knife environment from file !$
```
