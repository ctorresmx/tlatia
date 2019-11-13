#!/bin/sh
echo Building...
swift build -c release

echo Copying executable to "/usr/local/bin/"
cp .build/release/tlatia /usr/local/bin/

echo Finished...