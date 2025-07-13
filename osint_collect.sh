#!/bin/bash

MOBILE="$1"
NAME="$2"
EMAIL="$3"
DESC="$4"

OUTPUT_FILE="osint_output.txt"
echo "Starting OSINT Data Collection..." > $OUTPUT_FILE

# Tools directories
SPIDERFOOT_DIR="spiderfoot"
MAIGRET_DIR="maigret"
PHOTON_DIR="photon"

# Clone tools if not present
if [ ! -d "$SPIDERFOOT_DIR" ]; then
    echo "Cloning SpiderFoot..."
    git clone https://github.com/smicallef/spiderfoot.git
    cd $SPIDERFOOT_DIR && pip install -r requirements.txt && cd ..
fi

if [ ! -d "$MAIGRET_DIR" ]; then
    echo "Cloning Maigret..."
    git clone https://github.com/soxoj/maigret.git
    cd $MAIGRET_DIR && pip install -r requirements.txt && cd ..
fi

if [ ! -d "$PHOTON_DIR" ]; then
    echo "Cloning Photon..."
    git clone https://github.com/s0md3v/Photon.git photon
    cd $PHOTON_DIR && pip install -r requirements.txt && cd ..
fi

# Collect Mobile Data with Maigret if mobile provided
if [ ! -z "$MOBILE" ]; then
    echo "Running Mobile OSINT for $MOBILE..." >> $OUTPUT_FILE
    cd $MAIGRET_DIR
    python3 maigret.py "$MOBILE" --output ../$OUTPUT_FILE
    cd ..
fi

# Collect Email Data with SpiderFoot if email provided
if [ ! -z "$EMAIL" ]; then
    echo "Running Email OSINT for $EMAIL..." >> $OUTPUT_FILE
    cd $SPIDERFOOT_DIR
    python3 sf.py -s "$EMAIL" >> ../$OUTPUT_FILE
    cd ..
fi

# Collect Name Data with Maigret if name provided
if [ ! -z "$NAME" ]; then
    echo "Running Username OSINT for $NAME..." >> $OUTPUT_FILE
    cd $MAIGRET_DIR
    python3 maigret.py "$NAME" --output ../$OUTPUT_FILE
    cd ..
fi

# Collect Web/Image Data with Photon if description provided
if [ ! -z "$DESC" ]; then
    echo "Running Web Crawler OSINT for $DESC..." >> $OUTPUT_FILE
    cd $PHOTON_DIR
    python3 photon.py -u "$DESC" -o ../photon_results
    cat ../photon_results/* >> ../$OUTPUT_FILE
    cd ..
fi

echo "Data Collection Completed. Output saved to $OUTPUT_FILE"
