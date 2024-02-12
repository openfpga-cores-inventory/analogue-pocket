# openFPGA Cores Inventory
openFPGA Cores Inventory is the premier destination for keeping track of cores built with [openFPGA](https://www.analogue.co/developer).

## Installation
You will need to install [Ruby](https://www.ruby-lang.org/en/documentation/installation/), then run the following command in the root of the project:

```bash
$ bundle install
```

## Running the app
In the project root, run the following command:

```bash
$ bundle exec jekyll serve
```

Then navigate to `http://localhost:4000/`

## Cores API
openFPGA Cores Inventory provides a read-only API for developers. More information can be found in the [documentation](_docs/v2.md).

## Adding a new core
To add a new core, you will need to edit the `_data/repos.yml` file. You must add the following fields:

```yaml
- username: ericlewis
  cores:
    - display_name: Asteroids for Analogue Pocket
      repository: openfpga-asteroids
```

- `username` is the core author's GitHub username. It can be found after the first `/` in the core's URL (e.g. `https://github.com/ericlewis/openfpga-asteroids` -> `ericlewis`).
- `display_name` is used in the `Name` column of the [cores table](https://openfpga-cores-inventory.github.io/analogue-pocket/). A good value for this is usually the name used at the top of the core's `README.md` file.
- `repository` is the core's GitHub repository name. It can be found after the last `/` in the core's URL (e.g. `https://github.com/ericlewis/openfpga-asteroids` -> `openfpga-asteroids`).

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)
