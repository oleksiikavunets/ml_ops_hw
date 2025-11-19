# Installation

For local environment installation run [install_dev_tools.sh](install_dev_tools.sh) in cmd
```commandline
./install_dev_tools.sh
```

# Run

In order to execute inference run in cmd
```commandline
python3 inference.py example.jpg
```

# Run in docker
In order to execute inference in docker build image and run the container.
## Build 
```commandline
docker build -f Dockerfile.slim -t slim .
```

## Run
```commandline
docker run -it slim example.jpg
```