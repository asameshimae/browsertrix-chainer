# browsertrix-chainer
Simple script to batch process a list of URLs using browsertrix-crawler and predefined parameters

## Installation
1. Download [runqueue.sh](https://raw.githubusercontent.com/asameshimae/browsertrix-chainer/main/runqueue.sh) (or `git clone https://github.com/asameshimae/browsertrix-chainer.git`) and place it in the directory where you run browsertrix-crawler, usualy a directory containing the `crawls/` subdirectory (e.g. `cp browsertrix-chainer/runqueue.sh .`)
2. Ensure that `runqueue.sh` is executable (e.g. `chmod +x runqueue.sh`)

## Usage
1. In the same directory as `runqueue.sh`, create a text file called `queue.txt`. This file should contain one URL per line, ending with a newline.
2. Run the script, e.g. `./runqueue.sh`

The script will report progress between browsertrix sessions. A list of successful crawls (where browsertrix exits with code 0) will be appended to `queue-done.txt` and failures to `queue-errors.txt`. Attempted crawls, whether or not successful, will be removed from `queue.txt` to prevent re-running. Additionally, the browsertrix commands used will be appended to `queue-commands.txt`.

## Customisation
You may find it useful to customise the `ARGS` variable to suit your crawls, e.g. making copies of `runqueue.sh` for different types of site. In a future release, it will likely be possible to pass arguments to `runqueue.sh` via the commandline, or to specify a YAML file (excluding site/collection parameters).
